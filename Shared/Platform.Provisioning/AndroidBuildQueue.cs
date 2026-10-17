using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

public sealed record AndroidBuildJob(Guid Id, string TenantId, Guid AppId, string DeploymentId, int BuildNumber,
    string State, int Attempts, ProvisioningStepResult? Receipt, string? ErrorCode, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt)
{ public AndroidBuildScope? Scope { get; init; } }
public sealed record AndroidBuildLease(AndroidBuildJob Job, Guid Token);

/// <summary>Durable manual releases. The original onboarding job and its first release remain immutable.</summary>
public sealed class AndroidBuildQueue(string connectionString) : IAsyncDisposable
{
    private readonly NpgsqlDataSource db = NpgsqlDataSource.Create(connectionString);
    internal static async Task InitializeAsync(NpgsqlConnection connection, NpgsqlTransaction transaction, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.android_build_jobs (
                id uuid PRIMARY KEY, tenant_id text NOT NULL REFERENCES platform_provisioning.jobs(tenant_id),
                app_id uuid NOT NULL, deployment_id text NOT NULL, build_number integer NOT NULL CHECK(build_number > 0),
                state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Succeeded','Failed')),
                attempts integer NOT NULL DEFAULT 0, receipt jsonb, error_code text, claim_token uuid, lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(),
                UNIQUE(tenant_id,build_number), CHECK(state <> 'Succeeded' OR receipt IS NOT NULL)
            );
            ALTER TABLE platform_provisioning.android_build_jobs ADD COLUMN IF NOT EXISTS scope jsonb;
            CREATE UNIQUE INDEX IF NOT EXISTS android_build_jobs_tenant_identity ON platform_provisioning.android_build_jobs(id,tenant_id);
            CREATE UNIQUE INDEX IF NOT EXISTS android_build_jobs_one_active ON platform_provisioning.android_build_jobs(tenant_id) WHERE state IN ('Pending','Running');
            CREATE INDEX IF NOT EXISTS android_build_jobs_available ON platform_provisioning.android_build_jobs(deployment_id,available_at,id) WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_android_build_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF (NEW.id,NEW.tenant_id,NEW.app_id,NEW.deployment_id,NEW.build_number,NEW.scope) IS DISTINCT FROM
                   (OLD.id,OLD.tenant_id,OLD.app_id,OLD.deployment_id,OLD.build_number,OLD.scope) OR
                   (OLD.state='Succeeded' AND NEW IS DISTINCT FROM OLD) THEN
                    RAISE EXCEPTION 'The Android release identity and completed receipt are immutable' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_android_build_v1 ON platform_provisioning.android_build_jobs;
            CREATE TRIGGER immutable_android_build_v1 BEFORE UPDATE ON platform_provisioning.android_build_jobs
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_android_build_v1();
            """, connection, transaction);
        await command.ExecuteNonQueryAsync(ct);
    }
    public async Task<IReadOnlyList<AndroidBuildJob>> ListAsync(string tenant, CancellationToken ct = default)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command = db.CreateCommand("SELECT id,tenant_id,app_id,deployment_id,build_number,state,attempts,receipt::text,error_code,created_at,updated_at,scope::text FROM platform_provisioning.android_build_jobs WHERE tenant_id=$1 ORDER BY build_number DESC");
        command.Parameters.AddWithValue(tenant);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<AndroidBuildJob>(); while(await reader.ReadAsync(ct)) result.Add(Read(reader)); return result;
    }
    public async Task<AndroidBuildJob> EnqueueAsync(Guid id, string tenant, Guid app, string deployment, int expectedNumber, CancellationToken ct = default, AndroidBuildScope? scope = null,IosReleasePlan? iosPlan=null)
    {
        IosReleasePlan.Tenant(tenant);scope?.Validate(tenant,deployment);iosPlan?.Validate();
        if(iosPlan!=null && (scope==null || iosPlan.ReleaseId!=id || iosPlan.TenantId!=tenant || iosPlan.DeploymentId!=deployment || iosPlan.MobileIdentityId!=scope.IdentityId ||
            iosPlan.BuildNumber!=expectedNumber || iosPlan.IosBundleId!=scope.IosBundleId || iosPlan.ProjectId!=scope.ProjectId || iosPlan.StoreUrl!=scope.StoreUrl || iosPlan.Branding!=scope.Branding))throw new ProvisioningConflictException();
        if(id==Guid.Empty || app==Guid.Empty || expectedNumber<1) throw new ArgumentException("A release identity and version are required.");
        await using var connection = await db.OpenConnectionAsync(ct);
        await using var transaction = await connection.BeginTransactionAsync(ct);
        // Serialize allocation against this tenant's immutable onboarding row, including concurrent requests from other replicas.
        await using(var original = new NpgsqlCommand("SELECT state,request->>'DeploymentId',request->>'MobileReleaseProfile',steps->'mobile-android-release'->'Resources'->>'buildNumber' FROM platform_provisioning.jobs WHERE tenant_id=$1 FOR UPDATE",connection,transaction))
        {
            original.Parameters.AddWithValue(tenant);await using var reader=await original.ExecuteReaderAsync(ct);
            if(!await reader.ReadAsync(ct) || reader.GetString(0)!="Succeeded" || reader.GetString(1)!=deployment ||
                reader.GetString(2) is not ("AndroidAppDistribution" or "AndroidIosAppDistribution") || reader.IsDBNull(3) || iosPlan!=null && reader.GetString(2)!="AndroidIosAppDistribution") throw new ProvisioningConflictException();
        }
        var prior=(await ListAsync(tenant,ct)).FirstOrDefault(j=>j.Id==id);
        if(prior!=null)
        {
            if(prior.AppId!=app || prior.DeploymentId!=deployment || prior.BuildNumber!=expectedNumber || prior.Scope!=scope)throw new ProvisioningConflictException();
            await using(var paired=new NpgsqlCommand("SELECT request::text FROM platform_provisioning.ios_build_jobs WHERE id=$1",connection,transaction))
            {
                paired.Parameters.AddWithValue(id);var json=await paired.ExecuteScalarAsync(ct) as string;
                if((json==null?null:JsonSerializer.Deserialize<IosReleasePlan>(json,new JsonSerializerOptions(JsonSerializerDefaults.Web)))!=iosPlan)throw new ProvisioningConflictException();
            }
            await transaction.CommitAsync(ct);return prior;
        }
        // Promotion and canonical domain changes use the same tenant lock. Queueing freezes the selected active identity.
        await using(var gate=new NpgsqlCommand("SELECT pg_advisory_xact_lock(hashtextextended($1,734180227))",connection,transaction))
        {gate.Parameters.AddWithValue(tenant);await gate.ExecuteNonQueryAsync(ct);}
        await using(var active=new NpgsqlCommand("SELECT id FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$1 AND state='Active'",connection,transaction))
        {
            active.Parameters.AddWithValue(tenant);var current=await active.ExecuteScalarAsync(ct);
            if(scope==null ? current is Guid : current is not Guid idValue || idValue!=scope.IdentityId)throw new ProvisioningConflictException();
        }
        await using(var insert = new NpgsqlCommand("""
            INSERT INTO platform_provisioning.android_build_jobs(id,tenant_id,app_id,deployment_id,build_number,scope)
            SELECT $1,$2,$3,$4,$5,$6::jsonb FROM platform_provisioning.jobs j WHERE j.tenant_id=$2
                AND $5=1+GREATEST((j.steps->'mobile-android-release'->'Resources'->>'buildNumber')::integer,
                    COALESCE((SELECT max(build_number) FROM platform_provisioning.android_build_jobs WHERE tenant_id=$2),0))
                AND NOT EXISTS(SELECT 1 FROM platform_provisioning.android_build_jobs WHERE tenant_id=$2 AND state IN ('Pending','Running'))
                AND NOT EXISTS(SELECT 1 FROM platform_provisioning.ios_build_jobs WHERE tenant_id=$2 AND state IN ('Pending','Running'))
            """,connection,transaction))
        {
            insert.Parameters.AddWithValue(id);insert.Parameters.AddWithValue(tenant);insert.Parameters.AddWithValue(app);
            insert.Parameters.AddWithValue(deployment);insert.Parameters.AddWithValue(expectedNumber);
            insert.Parameters.Add(new NpgsqlParameter {NpgsqlDbType=NpgsqlTypes.NpgsqlDbType.Jsonb,Value=scope==null?DBNull.Value:JsonSerializer.Serialize(scope)});
            if(await insert.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningConflictException();
        }
        if(iosPlan!=null)await IosBuildQueue.AddAsync(connection,transaction,iosPlan,ct);
        await transaction.CommitAsync(ct);return (await ListAsync(tenant,ct)).Single(j=>j.Id==id);
    }
    public async Task<AndroidBuildLease?> ClaimAsync(string deployment, CancellationToken ct)
    {
        var token=Guid.NewGuid();
        await using var command=db.CreateCommand("""
            UPDATE platform_provisioning.android_build_jobs SET state='Running',attempts=attempts+1,claim_token=$1,lease_until=now()+interval '2 minutes',updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.android_build_jobs WHERE deployment_id=$2 AND
                ((state='Pending' AND available_at<=now()) OR (state='Running' AND lease_until<now()))
                ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING id,tenant_id,app_id,deployment_id,build_number,state,attempts,receipt::text,error_code,created_at,updated_at,scope::text
            """);
        command.Parameters.AddWithValue(token);command.Parameters.AddWithValue(deployment);
        await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?new(Read(reader),token):null;
    }
    public Task RenewAsync(AndroidBuildLease lease,CancellationToken ct)=>OwnedAsync(lease,"lease_until=now()+interval '2 minutes',updated_at=now()",ct);
    public Task CompleteAsync(AndroidBuildLease lease,ProvisioningStepResult receipt,CancellationToken ct)
    {
        if(receipt.Provider!="AndroidAppDistribution" || receipt.Resources.GetValueOrDefault("buildNumber")!=lease.Job.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture))
            throw new InvalidOperationException("The Android build receipt does not match the queued version.");
        lease.Job.Scope?.ValidateReceipt(receipt,lease.Job.BuildNumber);
        return OwnedAsync(lease,"state='Succeeded',receipt=$3::jsonb,error_code=NULL,claim_token=NULL,lease_until=NULL,updated_at=now()",ct,JsonSerializer.Serialize(receipt));
    }
    public Task FailAsync(AndroidBuildLease lease,Exception error,CancellationToken ct)=>OwnedAsync(lease,
        "state=CASE WHEN attempts>=3 THEN 'Failed' ELSE 'Pending' END,error_code=$3,available_at=now()+interval '30 seconds',claim_token=NULL,lease_until=NULL,updated_at=now()",ct,error.GetType().Name);
    private async Task OwnedAsync(AndroidBuildLease lease,string update,CancellationToken ct,string? value=null)
    {
        await using var command=db.CreateCommand($"UPDATE platform_provisioning.android_build_jobs SET {update} WHERE id=$1 AND claim_token=$2 AND state='Running' AND lease_until>now()");
        command.Parameters.AddWithValue(lease.Job.Id);command.Parameters.AddWithValue(lease.Token);if(value!=null)command.Parameters.AddWithValue(value);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningLeaseLostException();
    }
    private static AndroidBuildJob Read(NpgsqlDataReader r)=>new(r.GetGuid(0),r.GetString(1),r.GetGuid(2),r.GetString(3),r.GetInt32(4),r.GetString(5),r.GetInt32(6),
        r.IsDBNull(7)?null:JsonSerializer.Deserialize<ProvisioningStepResult>(r.GetString(7)),r.IsDBNull(8)?null:r.GetString(8),r.GetFieldValue<DateTimeOffset>(9),r.GetFieldValue<DateTimeOffset>(10)) {Scope=r.IsDBNull(11)?null:JsonSerializer.Deserialize<AndroidBuildScope>(r.GetString(11))};
    public ValueTask DisposeAsync()=>db.DisposeAsync();
}
