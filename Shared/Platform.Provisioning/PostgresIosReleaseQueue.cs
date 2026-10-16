using System.Text.Json;
using System.Text.RegularExpressions;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Separate Mac work lane; immutable plans and expiring claim tokens survive worker restarts.</summary>
public sealed class PostgresIosReleaseQueue(string connectionString) : IIosReleaseQueue, IAsyncDisposable
{
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    private readonly NpgsqlDataSource db = NpgsqlDataSource.Create(connectionString);

    internal static async Task InitializeAsync(NpgsqlConnection connection, NpgsqlTransaction transaction, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.ios_release_jobs (
                tenant_id text PRIMARY KEY REFERENCES platform_provisioning.jobs(tenant_id),
                request jsonb NOT NULL,
                state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Succeeded','Failed')),
                attempts integer NOT NULL DEFAULT 0 CHECK(attempts >= 0),
                receipt jsonb,
                claim_token uuid,
                lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(),
                error_code text,
                created_at timestamptz NOT NULL DEFAULT now(),
                updated_at timestamptz NOT NULL DEFAULT now(),
                CHECK(COALESCE(request->>'tenantId','')=tenant_id),
                CHECK(state<>'Succeeded' OR receipt IS NOT NULL)
            );
            CREATE INDEX IF NOT EXISTS ios_release_jobs_available
                ON platform_provisioning.ios_release_jobs((request->>'deploymentId'),available_at,tenant_id)
                WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_ios_release_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF NEW.request IS DISTINCT FROM OLD.request OR NEW.tenant_id IS DISTINCT FROM OLD.tenant_id THEN
                    RAISE EXCEPTION 'The original iOS release plan is immutable' USING ERRCODE='23514';
                END IF;
                IF OLD.state='Succeeded' AND NEW IS DISTINCT FROM OLD THEN
                    RAISE EXCEPTION 'A completed iOS release cannot be replaced' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_ios_release_v1 ON platform_provisioning.ios_release_jobs;
            CREATE TRIGGER immutable_ios_release_v1 BEFORE UPDATE ON platform_provisioning.ios_release_jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_ios_release_v1();
            """, connection, transaction);
        await command.ExecuteNonQueryAsync(ct);
    }

    public async Task<IosReleaseJob> EnqueueAsync(IosReleasePlan plan, CancellationToken ct = default)
    {
        plan.Validate();
        await using var command = db.CreateCommand("INSERT INTO platform_provisioning.ios_release_jobs(tenant_id,request) VALUES($1,$2::jsonb) ON CONFLICT DO NOTHING");
        command.Parameters.AddWithValue(plan.TenantId);
        command.Parameters.AddWithValue(JsonSerializer.Serialize(plan, Json));
        await command.ExecuteNonQueryAsync(ct);
        var job = await GetAsync(plan.TenantId, ct);
        if (job == null || job.Plan != plan) throw new ProvisioningConflictException();
        return job;
    }

    public async Task<IosReleaseJob?> GetAsync(string tenant, CancellationToken ct = default)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command = db.CreateCommand("""
            SELECT request::text,state,attempts,receipt::text,error_code,created_at,updated_at
            FROM platform_provisioning.ios_release_jobs WHERE tenant_id=$1
            """);
        command.Parameters.AddWithValue(tenant);
        await using var reader = await command.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct) ? Read(reader) : null;
    }

    public async Task<IosReleaseLease?> ClaimAsync(IosWorkerIdentity identity, TimeSpan duration, CancellationToken ct = default)
    {
        identity.Validate(); LeaseDuration(duration);
        var token = Guid.NewGuid();
        await using var command = db.CreateCommand("""
            UPDATE platform_provisioning.ios_release_jobs SET state='Running',attempts=attempts+1,
                claim_token=$1,lease_until=now()+$2,updated_at=now()
            WHERE tenant_id=(SELECT tenant_id FROM platform_provisioning.ios_release_jobs
                WHERE request->>'deploymentId'=$3 AND request->>'developmentTeam'=$4
                    AND request->>'signingCertificateSha256'=$5 AND request->>'sourceHash'=$6
                    AND ((state='Pending' AND available_at<=now()) OR (state='Running' AND lease_until<now()))
                ORDER BY available_at,tenant_id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING request::text,state,attempts,receipt::text,error_code,created_at,updated_at
            """);
        command.Parameters.AddWithValue(token); command.Parameters.AddWithValue(duration);
        command.Parameters.AddWithValue(identity.DeploymentId); command.Parameters.AddWithValue(identity.DevelopmentTeam);
        command.Parameters.AddWithValue(identity.SigningCertificateSha256); command.Parameters.AddWithValue(identity.SourceHash);
        await using var reader = await command.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct) ? new(Read(reader), token) : null;
    }

    public async Task RenewAsync(IosReleaseLease lease, TimeSpan duration, CancellationToken ct = default)
    {
        LeaseDuration(duration);
        await using var command = Owned("lease_until=now()+$3,updated_at=now()", lease);
        command.Parameters.AddWithValue(duration); await RequireOwned(command, ct);
    }

    public async Task CompleteAsync(IosReleaseLease lease, IosReleaseReceipt receipt, CancellationToken ct = default)
    {
        receipt.Validate(lease.Job.Plan);
        await using var command = Owned("state='Succeeded',receipt=$3::jsonb,claim_token=NULL,lease_until=NULL,error_code=NULL,updated_at=now()", lease);
        command.CommandText += " AND request=$4::jsonb";
        command.Parameters.AddWithValue(JsonSerializer.Serialize(receipt, Json));
        command.Parameters.AddWithValue(JsonSerializer.Serialize(lease.Job.Plan, Json)); await RequireOwned(command, ct);
    }

    public async Task FailAsync(IosReleaseLease lease, string errorCode, int maxAttempts, CancellationToken ct = default)
    {
        if (maxAttempts is < 1 or > 20 || !Regex.IsMatch(errorCode, "^[A-Za-z0-9_.:-]{1,160}\\z"))
            throw new ArgumentException("Use a bounded safe iOS error code and retry limit.");
        await using var command = Owned("""
            state=CASE WHEN attempts >= $3 THEN 'Failed' ELSE 'Pending' END,
            available_at=now()+$4,error_code=$5,claim_token=NULL,lease_until=NULL,updated_at=now()
            """, lease);
        command.Parameters.AddWithValue(maxAttempts);
        command.Parameters.AddWithValue(TimeSpan.FromSeconds(Math.Min(300, Math.Pow(2, Math.Min(lease.Job.Attempts, 8)))));
        command.Parameters.AddWithValue(errorCode); await RequireOwned(command, ct);
    }

    public async Task<bool> RetryAsync(string tenant, CancellationToken ct = default)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command = db.CreateCommand("""
            UPDATE platform_provisioning.ios_release_jobs SET state='Pending',attempts=0,error_code=NULL,available_at=now(),updated_at=now()
            WHERE tenant_id=$1 AND state='Failed'
            """);
        command.Parameters.AddWithValue(tenant);
        return await command.ExecuteNonQueryAsync(ct) == 1;
    }

    private NpgsqlCommand Owned(string update, IosReleaseLease lease)
    {
        // update is an internal literal; every external value is a parameter.
        var command = db.CreateCommand($"UPDATE platform_provisioning.ios_release_jobs SET {update} WHERE tenant_id=$1 AND claim_token=$2 AND state='Running' AND lease_until>now()");
        command.Parameters.AddWithValue(lease.Job.Plan.TenantId); command.Parameters.AddWithValue(lease.Token);
        return command;
    }
    private static async Task RequireOwned(NpgsqlCommand command, CancellationToken ct)
    {
        if (await command.ExecuteNonQueryAsync(ct) != 1) throw new ProvisioningLeaseLostException();
    }
    private static void LeaseDuration(TimeSpan value)
    {
        if (value < TimeSpan.FromSeconds(3) || value > TimeSpan.FromMinutes(15)) throw new ArgumentOutOfRangeException(nameof(value));
    }
    private static IosReleaseJob Read(NpgsqlDataReader reader) => new(
        JsonSerializer.Deserialize<IosReleasePlan>(reader.GetString(0), Json)!, reader.GetString(1), reader.GetInt32(2),
        reader.IsDBNull(3) ? null : JsonSerializer.Deserialize<IosReleaseReceipt>(reader.GetString(3), Json),
        reader.IsDBNull(4) ? null : reader.GetString(4), reader.GetFieldValue<DateTimeOffset>(5), reader.GetFieldValue<DateTimeOffset>(6));
    public ValueTask DisposeAsync() => db.DisposeAsync();
}
