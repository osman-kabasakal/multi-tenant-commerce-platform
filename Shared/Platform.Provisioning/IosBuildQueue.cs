using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Subsequent iOS versions. The initial onboarding release and identity-version receipts remain untouched.</summary>
public sealed class IosBuildQueue(string connectionString):IAsyncDisposable
{
    private static readonly JsonSerializerOptions Json=new(JsonSerializerDefaults.Web);
    private readonly NpgsqlDataSource db=NpgsqlDataSource.Create(connectionString);
    internal static async Task InitializeAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,CancellationToken ct)
    {
        await using var command=new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.ios_build_jobs (
                id uuid PRIMARY KEY,
                tenant_id text NOT NULL REFERENCES platform_provisioning.jobs(tenant_id),request jsonb NOT NULL,
                state text NOT NULL DEFAULT 'Pending' CHECK(state IN ('Pending','Running','Succeeded','Failed')),
                attempts integer NOT NULL DEFAULT 0 CHECK(attempts>=0),receipt jsonb,error_code text,claim_token uuid,lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(),created_at timestamptz NOT NULL DEFAULT now(),updated_at timestamptz NOT NULL DEFAULT now(),
                FOREIGN KEY(id,tenant_id) REFERENCES platform_provisioning.android_build_jobs(id,tenant_id),
                CHECK(request->>'tenantId'=tenant_id AND request->>'releaseId'=id::text),CHECK(state<>'Succeeded' OR receipt IS NOT NULL)
            );
            CREATE INDEX IF NOT EXISTS ios_build_jobs_available ON platform_provisioning.ios_build_jobs((request->>'deploymentId'),available_at,id) WHERE state IN ('Pending','Running');
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_ios_build_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF (NEW.id,NEW.tenant_id,NEW.request) IS DISTINCT FROM (OLD.id,OLD.tenant_id,OLD.request) OR
                   (OLD.state='Succeeded' AND NEW IS DISTINCT FROM OLD) THEN
                    RAISE EXCEPTION 'A queued iOS build and completed release are immutable' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_ios_build_v1 ON platform_provisioning.ios_build_jobs;
            CREATE TRIGGER immutable_ios_build_v1 BEFORE UPDATE ON platform_provisioning.ios_build_jobs FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_ios_build_v1();
            """,connection,transaction);await command.ExecuteNonQueryAsync(ct);
    }
    internal static async Task AddAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,IosReleasePlan plan,CancellationToken ct)
    {
        plan.Validate();if(plan.ReleaseId==null)throw new ArgumentException("A manual iOS release id is required.");
        await using var command=new NpgsqlCommand("INSERT INTO platform_provisioning.ios_build_jobs(id,tenant_id,request) VALUES($1,$2,$3::jsonb)",connection,transaction);
        command.Parameters.AddWithValue(plan.ReleaseId.Value);command.Parameters.AddWithValue(plan.TenantId);command.Parameters.AddWithValue(JsonSerializer.Serialize(plan,Json));await command.ExecuteNonQueryAsync(ct);
    }
    public async Task<IReadOnlyList<IosReleaseJob>> ListAsync(string tenant,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command=db.CreateCommand("SELECT request::text,state,attempts,receipt::text,error_code,created_at,updated_at FROM platform_provisioning.ios_build_jobs WHERE tenant_id=$1 ORDER BY created_at DESC");
        command.Parameters.AddWithValue(tenant);await using var reader=await command.ExecuteReaderAsync(ct);
        var rows=new List<IosReleaseJob>();while(await reader.ReadAsync(ct))rows.Add(Read(reader));return rows;
    }
    public async Task<IosReleaseLease?> ClaimAsync(IosWorkerIdentity identity,TimeSpan duration,CancellationToken ct)
    {
        identity.Validate();Duration(duration);
        await using(var failed=db.CreateCommand("""
            UPDATE platform_provisioning.ios_build_jobs i SET state='Failed',error_code='AndroidBuildFailed',updated_at=now()
            FROM platform_provisioning.android_build_jobs a WHERE i.id=a.id AND i.state='Pending' AND a.state='Failed' AND i.request->>'deploymentId'=$1
            """)){failed.Parameters.AddWithValue(identity.DeploymentId);await failed.ExecuteNonQueryAsync(ct);}
        var token=Guid.NewGuid();await using var command=db.CreateCommand("""
            UPDATE platform_provisioning.ios_build_jobs SET state='Running',attempts=attempts+1,claim_token=$1,lease_until=now()+$2,updated_at=now()
            WHERE id=(SELECT i.id FROM platform_provisioning.ios_build_jobs i JOIN platform_provisioning.android_build_jobs a ON a.id=i.id AND a.tenant_id=i.tenant_id
                WHERE a.state='Succeeded' AND i.request->>'deploymentId'=$3 AND i.request->>'developmentTeam'=$4
                AND i.request->>'signingCertificateSha256'=$5 AND i.request->>'sourceHash'=$6
                AND ((i.state='Pending' AND i.available_at<=now()) OR (i.state='Running' AND i.lease_until<now()))
                ORDER BY i.available_at,i.id LIMIT 1 FOR UPDATE OF i SKIP LOCKED)
            RETURNING request::text,state,attempts,receipt::text,error_code,created_at,updated_at
            """);
        command.Parameters.AddWithValue(token);command.Parameters.AddWithValue(duration);command.Parameters.AddWithValue(identity.DeploymentId);
        command.Parameters.AddWithValue(identity.DevelopmentTeam);command.Parameters.AddWithValue(identity.SigningCertificateSha256);command.Parameters.AddWithValue(identity.SourceHash);
        await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?new(Read(reader),token):null;
    }
    public async Task RenewAsync(IosReleaseLease lease,TimeSpan duration,CancellationToken ct)
    {Duration(duration);await using var c=Owned(lease,"lease_until=now()+$3,updated_at=now()");c.Parameters.AddWithValue(duration);await ApplyAsync(c,ct);}
    public async Task CompleteAsync(IosReleaseLease lease,IosReleaseReceipt receipt,CancellationToken ct)
    {receipt.Validate(lease.Job.Plan);await using var c=Owned(lease,"state='Succeeded',receipt=$3::jsonb,error_code=NULL,claim_token=NULL,lease_until=NULL,updated_at=now()");c.CommandText+=" AND request=$4::jsonb";c.Parameters.AddWithValue(JsonSerializer.Serialize(receipt,Json));c.Parameters.AddWithValue(JsonSerializer.Serialize(lease.Job.Plan,Json));await ApplyAsync(c,ct);}
    public async Task FailAsync(IosReleaseLease lease,string code,int maximum,CancellationToken ct)
    {
        if(maximum is <1 or >20 || !System.Text.RegularExpressions.Regex.IsMatch(code,"^[A-Za-z0-9_.:-]{1,160}\\z"))throw new ArgumentException("Use a bounded failure code.");
        await using var c=Owned(lease,"state=CASE WHEN attempts>=$3 THEN 'Failed' ELSE 'Pending' END,error_code=$4,claim_token=NULL,lease_until=NULL,available_at=now()+interval '30 seconds',updated_at=now()");
        c.Parameters.AddWithValue(maximum);c.Parameters.AddWithValue(code);await ApplyAsync(c,ct);
    }
    private NpgsqlCommand Owned(IosReleaseLease lease,string update)
    {
        lease.Job.Plan.Validate();var c=db.CreateCommand($"UPDATE platform_provisioning.ios_build_jobs SET {update} WHERE id=$1 AND claim_token=$2 AND state='Running' AND lease_until>now()");
        c.Parameters.AddWithValue(lease.Job.Plan.ReleaseId??throw new ProvisioningLeaseLostException());c.Parameters.AddWithValue(lease.Token);return c;
    }
    private static async Task ApplyAsync(NpgsqlCommand c,CancellationToken ct){if(await c.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningLeaseLostException();}
    private static void Duration(TimeSpan d){if(d<TimeSpan.FromSeconds(3)||d>TimeSpan.FromMinutes(15))throw new ArgumentOutOfRangeException(nameof(d));}
    private static IosReleaseJob Read(NpgsqlDataReader r)=>new(JsonSerializer.Deserialize<IosReleasePlan>(r.GetString(0),Json)!,r.GetString(1),r.GetInt32(2),r.IsDBNull(3)?null:JsonSerializer.Deserialize<IosReleaseReceipt>(r.GetString(3),Json),r.IsDBNull(4)?null:r.GetString(4),r.GetFieldValue<DateTimeOffset>(5),r.GetFieldValue<DateTimeOffset>(6));
    public ValueTask DisposeAsync()=>db.DisposeAsync();
}
