using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Domain proof precedes enrollment. A verified Cloudflare zone can belong to only one tenant, across portal replicas.</summary>
public sealed class TenantDomainRegistry(string connectionString) : IAsyncDisposable
{
    private readonly NpgsqlDataSource db = NpgsqlDataSource.Create(connectionString);
    private const string Columns = "request::text,state,challenge,expires_at,zone_id,zone_name,error_code,created_at,updated_at,attempts,verify_requested,is_primary";
    internal static async Task InitializeAsync(NpgsqlConnection connection, NpgsqlTransaction transaction, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.domain_requests (
                id uuid PRIMARY KEY, tenant_id text NOT NULL CHECK(tenant_id ~ '^[a-f0-9]{32}$'), owner_subject uuid NOT NULL,
                deployment_id text NOT NULL, request jsonb NOT NULL, challenge text NOT NULL,
                expires_at timestamptz NOT NULL DEFAULT now()+interval '24 hours',
                state text NOT NULL DEFAULT 'PendingCheck' CHECK(state IN ('PendingCheck','AwaitingOwnership','Verified','Provisioning','Active','Failed','Expired')),
                zone_id text, zone_name text, is_primary boolean NOT NULL DEFAULT false CHECK(NOT is_primary OR state='Active'), verify_requested boolean NOT NULL DEFAULT false,
                attempts integer NOT NULL DEFAULT 0, error_code text, claim_token uuid, lease_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(),
                CHECK((zone_id IS NULL)=(zone_name IS NULL)), CHECK(zone_id IS NULL OR zone_id ~ '^[a-f0-9]{32}$'),
                UNIQUE(id,tenant_id), UNIQUE(id,tenant_id,owner_subject),
                CHECK(jsonb_typeof(request)='object'),
                CHECK(COALESCE(request->>'TenantId','')=tenant_id AND COALESCE(request->>'OwnerSubject','')=owner_subject::text AND
                    COALESCE(request->>'Id','')=id::text AND COALESCE(request->>'DeploymentId','')=deployment_id)
            );
            CREATE UNIQUE INDEX IF NOT EXISTS domain_requests_one_primary ON platform_provisioning.domain_requests(tenant_id) WHERE is_primary;
            CREATE INDEX IF NOT EXISTS domain_requests_owner ON platform_provisioning.domain_requests(owner_subject,created_at DESC);
            CREATE INDEX IF NOT EXISTS domain_requests_tenant ON platform_provisioning.domain_requests(tenant_id,created_at DESC);
            CREATE INDEX IF NOT EXISTS domain_requests_available ON platform_provisioning.domain_requests(deployment_id,available_at,id)
                WHERE state='PendingCheck' OR (state='AwaitingOwnership' AND verify_requested);
            CREATE TABLE IF NOT EXISTS platform_provisioning.domain_zone_claims (
                zone_id text PRIMARY KEY CHECK(zone_id ~ '^[a-f0-9]{32}$'), zone_name text NOT NULL UNIQUE,
                tenant_id text NOT NULL, verified_request_id uuid NOT NULL,
                FOREIGN KEY(verified_request_id,tenant_id) REFERENCES platform_provisioning.domain_requests(id,tenant_id),
                created_at timestamptz NOT NULL DEFAULT now()
            );
            CREATE INDEX IF NOT EXISTS domain_zone_claims_tenant ON platform_provisioning.domain_zone_claims(tenant_id);
            CREATE INDEX IF NOT EXISTS domain_zone_claims_request ON platform_provisioning.domain_zone_claims(verified_request_id);
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_domain_request_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF (NEW.id,NEW.tenant_id,NEW.owner_subject,NEW.deployment_id,NEW.request,NEW.challenge,NEW.expires_at) IS DISTINCT FROM
                   (OLD.id,OLD.tenant_id,OLD.owner_subject,OLD.deployment_id,OLD.request,OLD.challenge,OLD.expires_at) THEN
                    RAISE EXCEPTION 'The domain owner, hosts and proof challenge are immutable' USING ERRCODE='23514';
                END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_domain_request_v1 ON platform_provisioning.domain_requests;
            CREATE TRIGGER immutable_domain_request_v1 BEFORE UPDATE ON platform_provisioning.domain_requests
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_domain_request_v1();
            """, connection, transaction);
        await command.ExecuteNonQueryAsync(ct);
    }
    public async Task<TenantDomainBinding> CreateAsync(TenantDomainRequest request, CancellationToken ct = default)
    {
        request.Validate();
        var prior = await GetAsync(request.Id, request.OwnerSubject, ct);
        if (prior != null)
        {
            if (prior.Request != request) throw new ProvisioningConflictException();
            return prior;
        }
        await using var command = db.CreateCommand("""
            INSERT INTO platform_provisioning.domain_requests(id,tenant_id,owner_subject,deployment_id,request,challenge)
            SELECT $1,$2,$3,$4,$5::jsonb,$6 WHERE
                (SELECT count(*) FROM platform_provisioning.domain_requests WHERE owner_subject=$3 AND expires_at>now() AND state IN ('PendingCheck','AwaitingOwnership'))<10
            ON CONFLICT DO NOTHING
            """);
        command.Parameters.AddWithValue(request.Id); command.Parameters.AddWithValue(request.TenantId); command.Parameters.AddWithValue(request.OwnerSubject);
        command.Parameters.AddWithValue(request.DeploymentId); command.Parameters.AddWithValue(JsonSerializer.Serialize(request)); command.Parameters.AddWithValue(TenantDomainNames.Challenge(request.Id));
        await command.ExecuteNonQueryAsync(ct);
        var saved = await GetAsync(request.Id, request.OwnerSubject, ct);
        if (saved == null || saved.Request != request) throw new ProvisioningConflictException();
        return saved;
    }
    public async Task<TenantDomainBinding?> GetAsync(Guid id, Guid owner, CancellationToken ct = default)
    {
        await using var command = db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.domain_requests WHERE id=$1 AND owner_subject=$2");
        command.Parameters.AddWithValue(id); command.Parameters.AddWithValue(owner);
        await using var reader = await command.ExecuteReaderAsync(ct); return await reader.ReadAsync(ct) ? Read(reader) : null;
    }
    public async Task<TenantDomainBinding> RequireVerifiedAsync(Guid id, Guid owner, string tenant, string deployment, CancellationToken ct = default)
    {
        var binding = await GetAsync(id, owner, ct);
        if (binding == null || binding.Request.TenantId != tenant || binding.Request.DeploymentId != deployment ||
            binding.State is not ("Verified" or "Provisioning" or "Active"))
            throw new TenantDomainException("DomainNotVerified");
        return binding;
    }
    public async Task<bool> RequestVerificationAsync(Guid id, Guid owner, CancellationToken ct = default)
    {
        await using var command = db.CreateCommand("""
            UPDATE platform_provisioning.domain_requests SET verify_requested=true,attempts=0,error_code=NULL,available_at=now(),updated_at=now()
            WHERE id=$1 AND owner_subject=$2 AND state='AwaitingOwnership' AND expires_at>now() AND claim_token IS NULL
            """);
        command.Parameters.AddWithValue(id); command.Parameters.AddWithValue(owner); return await command.ExecuteNonQueryAsync(ct) == 1;
    }
    public async Task<TenantDomainLease?> ClaimAsync(string deployment, CancellationToken ct)
    {
        var token = Guid.NewGuid();
        await using var command = db.CreateCommand($"""
            UPDATE platform_provisioning.domain_requests SET claim_token=$1,lease_until=now()+interval '2 minutes',attempts=attempts+1,updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.domain_requests WHERE deployment_id=$2 AND expires_at>now() AND available_at<=now()
                AND (state='PendingCheck' OR (state='AwaitingOwnership' AND verify_requested)) AND (claim_token IS NULL OR lease_until<now())
                ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED) RETURNING {Columns}
            """);
        command.Parameters.AddWithValue(token); command.Parameters.AddWithValue(deployment);
        await using var reader = await command.ExecuteReaderAsync(ct); return await reader.ReadAsync(ct) ? new(Read(reader), token) : null;
    }
    public async Task RenewCheckAsync(TenantDomainLease lease, CancellationToken ct)
    {
        await using var command = db.CreateCommand("UPDATE platform_provisioning.domain_requests SET lease_until=now()+interval '2 minutes' WHERE id=$1 AND claim_token=$2 AND lease_until>now() AND expires_at>now()");
        command.Parameters.AddWithValue(lease.Binding.Request.Id); command.Parameters.AddWithValue(lease.Token);
        if (await command.ExecuteNonQueryAsync(ct) != 1) throw new ProvisioningLeaseLostException();
    }
    public async Task CompleteCheckAsync(TenantDomainLease lease, TenantDomainAccess access, CancellationToken ct)
    {
        if (!System.Text.RegularExpressions.Regex.IsMatch(access.ZoneId, "^[a-f0-9]{32}\\z") || TenantDomainNames.Normalize(access.ZoneName) != access.ZoneName ||
            !TenantDomainNames.Within(lease.Binding.Request.StoreHost, access.ZoneName) || !TenantDomainNames.Within(lease.Binding.Request.AdminHost, access.ZoneName))
            throw new InvalidOperationException("The checked Cloudflare zone does not own both tenant hostnames.");
        await using var connection = await db.OpenConnectionAsync(ct); await using var transaction = await connection.BeginTransactionAsync(ct);
        await using (var owned = new NpgsqlCommand("SELECT id FROM platform_provisioning.domain_requests WHERE id=$1 AND claim_token=$2 AND lease_until>now() AND expires_at>now() FOR UPDATE", connection, transaction))
        {
            owned.Parameters.AddWithValue(lease.Binding.Request.Id); owned.Parameters.AddWithValue(lease.Token);
            if (await owned.ExecuteScalarAsync(ct) == null) throw new ProvisioningLeaseLostException();
        }
        var proved = lease.Binding.State == "AwaitingOwnership";
        if (proved)
        {
            await using var claim = new NpgsqlCommand("""
                INSERT INTO platform_provisioning.domain_zone_claims(zone_id,zone_name,tenant_id,verified_request_id) VALUES($1,$2,$3,$4) ON CONFLICT DO NOTHING
                """, connection, transaction);
            claim.Parameters.AddWithValue(access.ZoneId); claim.Parameters.AddWithValue(access.ZoneName); claim.Parameters.AddWithValue(lease.Binding.Request.TenantId); claim.Parameters.AddWithValue(lease.Binding.Request.Id);
            await claim.ExecuteNonQueryAsync(ct);
            await using var readClaim = new NpgsqlCommand("SELECT tenant_id FROM platform_provisioning.domain_zone_claims WHERE zone_id=$1 AND zone_name=$2", connection, transaction);
            readClaim.Parameters.AddWithValue(access.ZoneId); readClaim.Parameters.AddWithValue(access.ZoneName);
            var tenant = await readClaim.ExecuteScalarAsync(ct) as string;
            if (tenant != lease.Binding.Request.TenantId) throw new TenantDomainException("DomainAlreadyAssigned");
        }
        await using var update = new NpgsqlCommand("""
            UPDATE platform_provisioning.domain_requests SET zone_id=$3,zone_name=$4,state=$5,verify_requested=false,
                error_code=NULL,claim_token=NULL,lease_until=NULL,updated_at=now() WHERE id=$1 AND claim_token=$2
            """, connection, transaction);
        update.Parameters.AddWithValue(lease.Binding.Request.Id); update.Parameters.AddWithValue(lease.Token); update.Parameters.AddWithValue(access.ZoneId); update.Parameters.AddWithValue(access.ZoneName);
        update.Parameters.AddWithValue(proved ? "Verified" : "AwaitingOwnership");
        if (await update.ExecuteNonQueryAsync(ct) != 1) throw new ProvisioningLeaseLostException();
        await transaction.CommitAsync(ct);
    }
    public async Task FailCheckAsync(TenantDomainLease lease, string code, bool permanent, CancellationToken ct)
    {
        _ = new TenantDomainException(code);
        await using var command = db.CreateCommand("""
            UPDATE platform_provisioning.domain_requests SET state=CASE WHEN $3 THEN 'Failed' ELSE state END,
                error_code=$4,verify_requested=CASE WHEN $3 OR $4='DomainProofMissing' THEN false ELSE verify_requested END,
                available_at=now()+interval '30 seconds',claim_token=NULL,lease_until=NULL,updated_at=now()
            WHERE id=$1 AND claim_token=$2 AND lease_until>now()
            """);
        command.Parameters.AddWithValue(lease.Binding.Request.Id); command.Parameters.AddWithValue(lease.Token); command.Parameters.AddWithValue(permanent); command.Parameters.AddWithValue(code);
        if (await command.ExecuteNonQueryAsync(ct) != 1) throw new ProvisioningLeaseLostException();
    }
    public async Task MarkActiveAsync(Guid id, Guid owner, string tenant, string deployment, CancellationToken ct,Guid? expectedPrevious=null,bool enforcePrevious=false)
    {
        var binding=await RequireVerifiedAsync(id,owner,tenant,deployment,ct);
        if(binding.State=="Active" && binding.IsPrimary)return;
        await using var connection=await db.OpenConnectionAsync(ct);await using var transaction=await connection.BeginTransactionAsync(ct);
        await using(var gate=new NpgsqlCommand("SELECT pg_advisory_xact_lock(hashtextextended($1,734180227))",connection,transaction))
        {gate.Parameters.AddWithValue(tenant);await gate.ExecuteNonQueryAsync(ct);}
        if(enforcePrevious)
        {
            await using var current=new NpgsqlCommand("SELECT id FROM platform_provisioning.domain_requests WHERE tenant_id=$1 AND is_primary",connection,transaction);
            current.Parameters.AddWithValue(tenant);var primary=await current.ExecuteScalarAsync(ct);
            if((primary as Guid?)!=expectedPrevious && (primary as Guid?)!=id)throw new TenantDomainException("DomainPrimaryChanged");
        }
        await using(var previous=new NpgsqlCommand("UPDATE platform_provisioning.domain_requests SET is_primary=false,updated_at=now() WHERE tenant_id=$1 AND is_primary AND id<>$2",connection,transaction))
        {previous.Parameters.AddWithValue(tenant);previous.Parameters.AddWithValue(id);await previous.ExecuteNonQueryAsync(ct);}
        await using var command=new NpgsqlCommand("""
            UPDATE platform_provisioning.domain_requests SET state='Active',is_primary=true,error_code=NULL,updated_at=now()
            WHERE id=$1 AND owner_subject=$2 AND tenant_id=$3 AND deployment_id=$4 AND
                state IN ('Active','Verified','Provisioning')
                AND EXISTS(SELECT 1 FROM platform_provisioning.domain_zone_claims c WHERE c.zone_id=domain_requests.zone_id AND c.tenant_id=domain_requests.tenant_id)
            """,connection,transaction);
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(owner);command.Parameters.AddWithValue(tenant);command.Parameters.AddWithValue(deployment);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new TenantDomainException("DomainNotVerified");
        await using(var supersede=new NpgsqlCommand("""
            UPDATE platform_provisioning.mobile_identity_versions SET state='Superseded',error_code='DomainTargetChanged',
                linux_token=NULL,linux_until=NULL,ios_token=NULL,ios_until=NULL,updated_at=now()
            WHERE tenant_id=$1 AND NOT legacy AND state IN ('Preparing','WaitingBuilds','Ready','Failed') AND domain_request_id IS DISTINCT FROM $2
            """,connection,transaction))
        {supersede.Parameters.AddWithValue(tenant);supersede.Parameters.AddWithValue(id);await supersede.ExecuteNonQueryAsync(ct);}
        await transaction.CommitAsync(ct);
    }
    public async Task<TenantDomainBinding?> PrimaryForWorkerAsync(string tenant,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.domain_requests WHERE tenant_id=$1 AND is_primary AND state='Active'");
        command.Parameters.AddWithValue(tenant);await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?Read(reader):null;
    }
    public async Task<IReadOnlyList<TenantDomainBinding>> ListAsync(string tenant,Guid owner,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.domain_requests WHERE tenant_id=$1 AND owner_subject=$2 ORDER BY created_at DESC LIMIT 100");
        command.Parameters.AddWithValue(tenant);command.Parameters.AddWithValue(owner);
        await using var reader=await command.ExecuteReaderAsync(ct);var result=new List<TenantDomainBinding>();
        while(await reader.ReadAsync(ct))result.Add(Read(reader));return result;
    }
    private static TenantDomainBinding Read(NpgsqlDataReader r) => new(JsonSerializer.Deserialize<TenantDomainRequest>(r.GetString(0))!,r.GetString(1),r.GetString(2),
        r.GetFieldValue<DateTimeOffset>(3),r.IsDBNull(4)?null:r.GetString(4),r.IsDBNull(5)?null:r.GetString(5),r.IsDBNull(6)?null:r.GetString(6),r.GetFieldValue<DateTimeOffset>(7),r.GetFieldValue<DateTimeOffset>(8)) { Attempts=r.GetInt32(9), VerificationRequested=r.GetBoolean(10), IsPrimary=r.GetBoolean(11) };
    public ValueTask DisposeAsync() => db.DisposeAsync();
}
