using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

public sealed record ReadinessDeliveryLease(TenantProvisioningRequest Request,ProvisioningStepResult Publication,Guid Token,int Attempts,string BindingSha256);
public sealed record ReadinessDeliveryStatus(string State,int Attempts,string? ErrorCode);

/// <summary>Runtime row operations only. The provisioning schema owner installs the outbox and trigger.</summary>
public sealed class PostgresReadinessDeliveryQueue(string connectionString) : IAsyncDisposable,IDisposable
{
    private readonly NpgsqlDataSource _source=NpgsqlDataSource.Create(connectionString);
    public void Dispose()=>_source.Dispose();
    public ValueTask DisposeAsync()=>_source.DisposeAsync();
    public async Task VerifyAsync(string deployment,string binding,CancellationToken ct=default)
    {
        await using var command=_source.CreateCommand("""
            SELECT pg_catalog.to_regclass('platform_provisioning.readiness_deliveries') IS NOT NULL AND EXISTS(
                SELECT 1 FROM pg_catalog.pg_trigger WHERE tgrelid=pg_catalog.to_regclass('platform_provisioning.jobs')
                AND tgname='enqueue_tenant_ready_v1' AND NOT tgisinternal AND tgenabled IN ('O','A'))
            """);
        if(await command.ExecuteScalarAsync(ct) is not true)throw new InvalidOperationException("Apply the owner provisioning schema before enabling readiness delivery.");
        await using var drift=Command("SELECT EXISTS(SELECT 1 FROM platform_provisioning.readiness_deliveries WHERE deployment_id=$1 AND binding_sha256 IS NOT NULL AND binding_sha256<>$2)",deployment,binding);
        if(await drift.ExecuteScalarAsync(ct) is true)throw new InvalidOperationException("The existing readiness delivery target changed; use its original configuration or an explicit migration.");
    }
    public async Task<ReadinessDeliveryLease?> ClaimAsync(string deployment,string binding,TimeSpan duration,CancellationToken ct=default)
    {
        if(duration<TimeSpan.FromSeconds(3) || duration>TimeSpan.FromMinutes(10) || !System.Text.RegularExpressions.Regex.IsMatch(binding,"^[a-f0-9]{64}$"))throw new ArgumentException("Invalid readiness delivery lease.");
        var token=Guid.NewGuid();
        await using var command=Command("""
            UPDATE platform_provisioning.readiness_deliveries d
            SET state='Running',attempts=d.attempts+1,claim_token=$1,lease_until=now()+$2,binding_sha256=$3,updated_at=now()
            WHERE d.tenant_id=(SELECT candidate.tenant_id FROM platform_provisioning.readiness_deliveries candidate
                WHERE EXISTS(SELECT 1 FROM platform_provisioning.jobs j WHERE j.tenant_id=candidate.tenant_id AND j.state='Succeeded') AND deployment_id=$4 AND (binding_sha256 IS NULL OR binding_sha256=$3) AND
                ((state='Pending' AND available_at<=now()) OR (state='Running' AND lease_until<now()))
                ORDER BY available_at,tenant_id FOR UPDATE SKIP LOCKED LIMIT 1)
            RETURNING (SELECT request::text FROM platform_provisioning.jobs WHERE tenant_id=d.tenant_id),
                (SELECT (steps->'publication')::text FROM platform_provisioning.jobs WHERE tenant_id=d.tenant_id),d.attempts
            """,token,duration,binding,deployment);
        await using var reader=await command.ExecuteReaderAsync(ct);
        if(!await reader.ReadAsync(ct))return null;
        return new(JsonSerializer.Deserialize<TenantProvisioningRequest>(reader.GetString(0))!,JsonSerializer.Deserialize<ProvisioningStepResult>(reader.GetString(1))!,token,reader.GetInt32(2),binding);
    }
    public Task RenewAsync(ReadinessDeliveryLease lease,TimeSpan duration,CancellationToken ct=default)=>OwnedAsync(lease,"lease_until=now()+$4",ct,duration);
    public Task SentAsync(ReadinessDeliveryLease lease,CancellationToken ct=default)=>OwnedAsync(lease,"state='Sent',claim_token=NULL,lease_until=NULL,error_code=NULL",ct);
    public Task FailedAsync(ReadinessDeliveryLease lease,string safeCode,int maxAttempts,CancellationToken ct=default)
    {
        if(!System.Text.RegularExpressions.Regex.IsMatch(safeCode,"^[a-zA-Z0-9:._-]{1,120}$") || maxAttempts<1)throw new ArgumentException("Use safe delivery failure metadata.");
        return OwnedAsync(lease,"state=CASE WHEN attempts >= $4 THEN 'Failed' ELSE 'Pending' END,available_at=now()+$5,error_code=$6,claim_token=NULL,lease_until=NULL",ct,maxAttempts,TimeSpan.FromSeconds(Math.Min(300,Math.Pow(2,Math.Min(lease.Attempts,8)))) ,safeCode);
    }
    public async Task<ReadinessDeliveryStatus?> GetAsync(string tenant,CancellationToken ct=default)
    {
        await using var command=Command("SELECT state,attempts,error_code FROM platform_provisioning.readiness_deliveries WHERE tenant_id=$1",tenant);
        await using var reader=await command.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct)?new(reader.GetString(0),reader.GetInt32(1),reader.IsDBNull(2)?null:reader.GetString(2)):null;
    }
    public async Task<bool> RetryAsync(string tenant,CancellationToken ct=default)
    {
        await using var command=Command("UPDATE platform_provisioning.readiness_deliveries SET state='Pending',available_at=now(),error_code=NULL,updated_at=now() WHERE tenant_id=$1 AND state='Failed'",tenant);
        return await command.ExecuteNonQueryAsync(ct)==1;
    }
    private NpgsqlCommand Command(string sql,params object[] values)
    {var command=_source.CreateCommand(sql);foreach(var value in values)command.Parameters.Add(new NpgsqlParameter{Value=value});return command;}
    private async Task OwnedAsync(ReadinessDeliveryLease lease,string assignments,CancellationToken ct,params object[] extra)
    {
        await using var command=Command($"UPDATE platform_provisioning.readiness_deliveries SET {assignments},updated_at=now() WHERE tenant_id=$1 AND claim_token=$2 AND binding_sha256=$3 AND state='Running' AND lease_until>now()",lease.Request.TenantId,lease.Token,lease.BindingSha256);
        foreach(var value in extra)command.Parameters.Add(new NpgsqlParameter{Value=value});
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningLeaseLostException();
    }
}

internal static class ReadinessDeliverySchema
{
    internal static async Task InitializeAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,CancellationToken ct)
    {
        await using var command=new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.schema_versions(version integer PRIMARY KEY CHECK(version>=1),installed_at timestamptz NOT NULL DEFAULT now());
            DO $$ BEGIN
                IF EXISTS(SELECT 1 FROM platform_provisioning.schema_versions WHERE version=1) AND
                    pg_catalog.to_regclass('platform_provisioning.readiness_deliveries') IS NULL THEN
                    RAISE EXCEPTION 'The readiness outbox is missing; restore the original queue database' USING ERRCODE='55000';
                END IF;
            END $$;
            CREATE TABLE IF NOT EXISTS platform_provisioning.readiness_deliveries(
                tenant_id text PRIMARY KEY REFERENCES platform_provisioning.jobs(tenant_id),
                deployment_id text NOT NULL,state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Sent','Failed')),
                attempts integer NOT NULL DEFAULT 0 CHECK(attempts>=0),binding_sha256 text CHECK(binding_sha256 ~ '^[a-f0-9]{64}$'),
                claim_token uuid,lease_until timestamptz,available_at timestamptz NOT NULL DEFAULT now(),error_code text,
                created_at timestamptz NOT NULL DEFAULT now(),updated_at timestamptz NOT NULL DEFAULT now());
            CREATE INDEX IF NOT EXISTS readiness_deliveries_available ON platform_provisioning.readiness_deliveries(deployment_id,available_at,tenant_id)
                WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.enqueue_tenant_ready_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF NEW.state='Succeeded' AND OLD.state<>'Succeeded' AND
                    (NEW.steps->'publication'->>'Provider'='Local' OR
                     (NEW.steps->'publication'->>'Provider'='Portable' AND NEW.steps->'publication'->'Resources'->>'readiness'='Verified')) AND
                    NEW.steps->'publication'->'Resources' ? 'storeUrl' AND NEW.steps->'publication'->'Resources' ? 'adminUrl' THEN
                    INSERT INTO platform_provisioning.readiness_deliveries(tenant_id,deployment_id)
                    VALUES(NEW.tenant_id,COALESCE(NEW.request->>'DeploymentId','')) ON CONFLICT DO NOTHING;
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS enqueue_tenant_ready_v1 ON platform_provisioning.jobs;
            CREATE TRIGGER enqueue_tenant_ready_v1 AFTER UPDATE OF state ON platform_provisioning.jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.enqueue_tenant_ready_v1();
            INSERT INTO platform_provisioning.schema_versions(version) VALUES(1) ON CONFLICT DO NOTHING;
            """,connection,transaction);
        await command.ExecuteNonQueryAsync(ct);
    }
}
