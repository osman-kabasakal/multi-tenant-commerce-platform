using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

public sealed record DomainActivationPlan(Guid Id,string TenantId,Guid OwnerSubject,string DeploymentId,TenantDomainSelection Domain,
    Guid? PreviousPrimaryDomainId,string OriginalRequestSha256,Guid BusinessAppId,bool CreateMobileIdentity,string? NewPackageName)
{
    public static string Digest(TenantProvisioningRequest request)=>Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(request)))).ToLowerInvariant();
    public void Validate()
    {
        IosReleasePlan.Tenant(TenantId);Domain.Validate();
        if(Id!=Domain.Id || OwnerSubject!=Domain.OwnerSubject || BusinessAppId==Guid.Empty || !IosReleasePlan.Digest(OriginalRequestSha256) ||
            !System.Text.RegularExpressions.Regex.IsMatch(DeploymentId,"^[a-z][a-z0-9-]{2,39}\\z") || PreviousPrimaryDomainId==Guid.Empty ||
            CreateMobileIdentity!=(NewPackageName!=null) || NewPackageName!=null && (NewPackageName.Length>200 ||
                !System.Text.RegularExpressions.Regex.IsMatch(NewPackageName,"^[a-z][a-z0-9]*(\\.[a-z][a-z0-9]*)+\\z")))
            throw new ArgumentException("Use an immutable owned domain migration plan.");
    }
}
public sealed record DomainActivationJob(DomainActivationPlan Plan,string State,int Attempts,IReadOnlyDictionary<string,ProvisioningStepResult> Steps,
    string? ErrorCode,DateTimeOffset CreatedAt,DateTimeOffset UpdatedAt);
public sealed record DomainActivationLease(DomainActivationJob Job,Guid Token);

/// <summary>A separate migration queue preserves the original onboarding request, installer checkpoints and release history.</summary>
public sealed class DomainActivationQueue(string connectionString) : IAsyncDisposable
{
    private readonly NpgsqlDataSource db=NpgsqlDataSource.Create(connectionString);
    private const string Columns="plan::text,state,attempts,steps::text,error_code,created_at,updated_at";
    internal static async Task InitializeAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,CancellationToken ct)
    {
        await using var command=new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.domain_activation_jobs (
                id uuid PRIMARY KEY,tenant_id text NOT NULL REFERENCES platform_provisioning.jobs(tenant_id),owner_subject uuid NOT NULL,
                plan jsonb NOT NULL,state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Succeeded','Failed')),
                attempts integer NOT NULL DEFAULT 0,steps jsonb NOT NULL DEFAULT '{}',error_code text,claim_token uuid,lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(),created_at timestamptz NOT NULL DEFAULT now(),updated_at timestamptz NOT NULL DEFAULT now(),
                FOREIGN KEY(id,tenant_id,owner_subject) REFERENCES platform_provisioning.domain_requests(id,tenant_id,owner_subject),
                CHECK(COALESCE(plan->>'Id','')=id::text AND COALESCE(plan->>'TenantId','')=tenant_id AND COALESCE(plan->>'OwnerSubject','')=owner_subject::text)
            );
            CREATE INDEX IF NOT EXISTS domain_activation_owner ON platform_provisioning.domain_activation_jobs(owner_subject,created_at DESC);
            CREATE UNIQUE INDEX IF NOT EXISTS domain_activation_one_active ON platform_provisioning.domain_activation_jobs(tenant_id) WHERE state IN ('Pending','Running');
            CREATE INDEX IF NOT EXISTS domain_activation_available ON platform_provisioning.domain_activation_jobs((plan->>'DeploymentId'),available_at,id) WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_domain_activation_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF (NEW.id,NEW.tenant_id,NEW.owner_subject,NEW.plan) IS DISTINCT FROM (OLD.id,OLD.tenant_id,OLD.owner_subject,OLD.plan) OR
                    (OLD.state='Succeeded' AND NEW IS DISTINCT FROM OLD) OR EXISTS(
                        SELECT 1 FROM jsonb_each(OLD.steps) AS step WHERE NEW.steps->step.key IS DISTINCT FROM step.value) THEN
                    RAISE EXCEPTION 'The domain migration plan and completed checkpoints are immutable' USING ERRCODE='23514';
                END IF;
                IF NEW.state='Succeeded' AND (NOT (NEW.steps ?& ARRAY['dns','https','store-address','primary']) OR
                    COALESCE(NEW.steps->'https'->'Resources'->>'readiness','')<>'Verified' OR
                    COALESCE(NEW.steps->'primary'->'Resources'->>'domainRequestId','')<>replace(NEW.id::text,'-','') OR
                    (COALESCE((NEW.plan->>'CreateMobileIdentity')::boolean,false) AND NOT NEW.steps ? 'mobile-identity')) THEN
                    RAISE EXCEPTION 'The domain migration is incomplete' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_domain_activation_v1 ON platform_provisioning.domain_activation_jobs;
            CREATE TRIGGER immutable_domain_activation_v1 BEFORE UPDATE ON platform_provisioning.domain_activation_jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_domain_activation_v1();
            """,connection,transaction);await command.ExecuteNonQueryAsync(ct);
    }
    public async Task<bool> HasPendingAsync(string tenant,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);await using var command=db.CreateCommand("SELECT EXISTS(SELECT 1 FROM platform_provisioning.domain_activation_jobs WHERE tenant_id=$1 AND state IN ('Pending','Running'))");
        command.Parameters.AddWithValue(tenant);return await command.ExecuteScalarAsync(ct) is true;
    }
    public async Task<DomainActivationJob?> GetAsync(Guid id,Guid owner,CancellationToken ct=default)
    {
        await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.domain_activation_jobs WHERE id=$1 AND owner_subject=$2");
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(owner);await using var reader=await command.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct)?Read(reader):null;
    }
    public async Task<DomainActivationJob> EnqueueAsync(DomainActivationPlan plan,CancellationToken ct=default)
    {
        plan.Validate();
        await using var connection=await db.OpenConnectionAsync(ct);await using var transaction=await connection.BeginTransactionAsync(ct);
        await using(var original=new NpgsqlCommand("SELECT state FROM platform_provisioning.jobs WHERE tenant_id=$1 AND request->>'DeploymentId'=$2 FOR UPDATE",connection,transaction))
        {original.Parameters.AddWithValue(plan.TenantId);original.Parameters.AddWithValue(plan.DeploymentId);if((await original.ExecuteScalarAsync(ct) as string)!="Succeeded")throw new ProvisioningConflictException();}
        var prior=await GetAsync(plan.Id,plan.OwnerSubject,ct);
        if(prior!=null){if(prior.Plan!=plan)throw new ProvisioningConflictException();await transaction.CommitAsync(ct);return prior;}
        await using var command=new NpgsqlCommand("""
            INSERT INTO platform_provisioning.domain_activation_jobs(id,tenant_id,owner_subject,plan)
            SELECT $1,$2,$3,$4::jsonb FROM platform_provisioning.domain_requests WHERE id=$1 AND tenant_id=$2 AND owner_subject=$3
                AND state IN ('Active','Verified')
                AND NOT EXISTS(SELECT 1 FROM platform_provisioning.domain_activation_jobs WHERE tenant_id=$2 AND state IN ('Pending','Running'))
            ON CONFLICT DO NOTHING
            """,connection,transaction);
        command.Parameters.AddWithValue(plan.Id);command.Parameters.AddWithValue(plan.TenantId);command.Parameters.AddWithValue(plan.OwnerSubject);command.Parameters.AddWithValue(JsonSerializer.Serialize(plan));
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningConflictException();
        await transaction.CommitAsync(ct);return (await GetAsync(plan.Id,plan.OwnerSubject,ct))!;
    }
    public async Task<DomainActivationLease?> ClaimAsync(string deployment,CancellationToken ct)
    {
        var token=Guid.NewGuid();await using var command=db.CreateCommand($"""
            UPDATE platform_provisioning.domain_activation_jobs SET state='Running',attempts=attempts+1,claim_token=$1,lease_until=now()+interval '2 minutes',updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.domain_activation_jobs WHERE plan->>'DeploymentId'=$2 AND
                ((state='Pending' AND available_at<=now()) OR (state='Running' AND lease_until<now())) ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING {Columns}
            """);command.Parameters.AddWithValue(token);command.Parameters.AddWithValue(deployment);
        await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?new(Read(reader),token):null;
    }
    public Task RenewAsync(DomainActivationLease lease,CancellationToken ct)=>OwnedAsync(lease,"lease_until=now()+interval '2 minutes',updated_at=now()",ct);
    public Task CheckpointAsync(DomainActivationLease lease,string step,ProvisioningStepResult receipt,CancellationToken ct)
    {
        if(step is not ("dns" or "https" or "store-address" or "primary" or "mobile-identity"))throw new ArgumentException("Unknown domain migration step.");
        return OwnedAsync(lease,"steps=steps||jsonb_build_object($3::text,$4::jsonb),error_code=NULL,updated_at=now()",ct,step,JsonSerializer.Serialize(receipt));
    }
    public Task CompleteAsync(DomainActivationLease lease,CancellationToken ct)=>OwnedAsync(lease,"state='Succeeded',error_code=NULL,claim_token=NULL,lease_until=NULL,updated_at=now()",ct);
    public Task DeferAsync(DomainActivationLease lease,ProvisioningDeferredException pending,CancellationToken ct)=>OwnedAsync(lease,
        "state='Pending',attempts=GREATEST(attempts-1,0),error_code=$3,available_at=now()+interval '30 seconds',claim_token=NULL,lease_until=NULL,updated_at=now()",ct,pending.ReasonCode);
    public Task FailAsync(DomainActivationLease lease,string code,CancellationToken ct)
    {
        _=new TenantDomainException(code);
        return OwnedAsync(lease,"state=CASE WHEN attempts>=5 THEN 'Failed' ELSE 'Pending' END,error_code=$3,available_at=now()+interval '30 seconds',claim_token=NULL,lease_until=NULL,updated_at=now()",ct,code);
    }
    public async Task<bool> RetryAsync(Guid id,Guid owner,CancellationToken ct)
    {
        await using var command=db.CreateCommand("UPDATE platform_provisioning.domain_activation_jobs SET state='Pending',attempts=0,error_code=NULL,available_at=now(),updated_at=now() WHERE id=$1 AND owner_subject=$2 AND state='Failed'");
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(owner);return await command.ExecuteNonQueryAsync(ct)==1;
    }
    private async Task OwnedAsync(DomainActivationLease lease,string update,CancellationToken ct,params string[] values)
    {
        await using var command=db.CreateCommand($"UPDATE platform_provisioning.domain_activation_jobs SET {update} WHERE id=$1 AND claim_token=$2 AND state='Running' AND lease_until>now()");
        command.Parameters.AddWithValue(lease.Job.Plan.Id);command.Parameters.AddWithValue(lease.Token);foreach(var value in values)command.Parameters.AddWithValue(value);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningLeaseLostException();
    }
    private static DomainActivationJob Read(NpgsqlDataReader r)=>new(JsonSerializer.Deserialize<DomainActivationPlan>(r.GetString(0))!,r.GetString(1),r.GetInt32(2),
        JsonSerializer.Deserialize<Dictionary<string,ProvisioningStepResult>>(r.GetString(3))!,r.IsDBNull(4)?null:r.GetString(4),r.GetFieldValue<DateTimeOffset>(5),r.GetFieldValue<DateTimeOffset>(6));
    public ValueTask DisposeAsync()=>db.DisposeAsync();
}
