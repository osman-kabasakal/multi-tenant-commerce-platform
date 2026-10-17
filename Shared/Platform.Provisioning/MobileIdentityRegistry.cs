using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Append-only package identities with one active pointer and separate fenced Linux/Mac build lanes.</summary>
public sealed class MobileIdentityRegistry(string connectionString) : IAsyncDisposable
{
    private readonly NpgsqlDataSource db=NpgsqlDataSource.Create(connectionString);
    private const string Columns="request::text,generation,legacy,state,attempts,prepared::text,android_receipt::text,ios_receipt::text,error_code,created_at,updated_at,ios_attempts";
    internal static async Task InitializeAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,CancellationToken ct)
    {
        await using var command=new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.mobile_package_owners (
                package text PRIMARY KEY CHECK(length(package) BETWEEN 3 AND 220),tenant_id text NOT NULL CHECK(tenant_id ~ '^[a-f0-9]{32}$'),
                created_at timestamptz NOT NULL DEFAULT now()
            );
            CREATE INDEX IF NOT EXISTS mobile_package_owners_tenant ON platform_provisioning.mobile_package_owners(tenant_id);
            CREATE TABLE IF NOT EXISTS platform_provisioning.mobile_identity_versions (
                id uuid PRIMARY KEY,tenant_id text NOT NULL REFERENCES platform_provisioning.jobs(tenant_id),business_app_id uuid NOT NULL,owner_subject uuid NOT NULL,
                generation integer NOT NULL CHECK(generation>=0),legacy boolean NOT NULL DEFAULT false,
                android_package text NOT NULL UNIQUE,ios_bundle text NOT NULL UNIQUE,domain_request_id uuid,expected_active_id uuid,request jsonb NOT NULL,
                state text NOT NULL DEFAULT 'Preparing' CHECK(state IN ('Preparing','WaitingBuilds','Ready','Active','Retired','Failed','Superseded')),
                attempts integer NOT NULL DEFAULT 0,ios_attempts integer NOT NULL DEFAULT 0,prepared jsonb,android_receipt jsonb,ios_receipt jsonb,error_code text,
                linux_token uuid,linux_until timestamptz,ios_token uuid,ios_until timestamptz,
                available_at timestamptz NOT NULL DEFAULT now(),created_at timestamptz NOT NULL DEFAULT now(),updated_at timestamptz NOT NULL DEFAULT now(),
                UNIQUE(id,tenant_id),UNIQUE(tenant_id,generation),
                FOREIGN KEY(expected_active_id,tenant_id) REFERENCES platform_provisioning.mobile_identity_versions(id,tenant_id),
                FOREIGN KEY(domain_request_id,tenant_id,owner_subject) REFERENCES platform_provisioning.domain_requests(id,tenant_id,owner_subject),
                CHECK(COALESCE(request->>'Id','')=id::text AND COALESCE(request->>'TenantId','')=tenant_id AND COALESCE(request->>'BusinessAppId','')=business_app_id::text AND
                    COALESCE(request->>'OwnerSubject','')=owner_subject::text AND COALESCE(request->>'AndroidPackageName','')=android_package AND COALESCE(request->>'IosBundleId','')=ios_bundle),
                CHECK(NOT legacy OR generation=0 AND state IN ('Active','Retired')),
                CHECK(legacy OR expected_active_id IS NOT NULL),
                CHECK(legacy OR state NOT IN ('Ready','Active','Retired') OR prepared IS NOT NULL AND android_receipt IS NOT NULL AND ios_receipt IS NOT NULL)
            );
            CREATE UNIQUE INDEX IF NOT EXISTS mobile_identity_one_active ON platform_provisioning.mobile_identity_versions(tenant_id) WHERE state='Active';
            CREATE UNIQUE INDEX IF NOT EXISTS mobile_identity_one_change ON platform_provisioning.mobile_identity_versions(tenant_id) WHERE state IN ('Preparing','WaitingBuilds','Ready');
            CREATE INDEX IF NOT EXISTS mobile_identity_owner ON platform_provisioning.mobile_identity_versions(owner_subject,business_app_id,generation DESC);
            CREATE INDEX IF NOT EXISTS mobile_identity_domain ON platform_provisioning.mobile_identity_versions(domain_request_id);
            CREATE INDEX IF NOT EXISTS mobile_identity_expected ON platform_provisioning.mobile_identity_versions(expected_active_id,tenant_id);
            CREATE INDEX IF NOT EXISTS mobile_identity_linux ON platform_provisioning.mobile_identity_versions((request->>'DeploymentId'),available_at,id)
                WHERE NOT legacy AND (state IN ('Preparing','WaitingBuilds') AND android_receipt IS NULL OR state='Ready');
            CREATE INDEX IF NOT EXISTS mobile_identity_ios ON platform_provisioning.mobile_identity_versions((request->>'DeploymentId'),available_at,id)
                WHERE state='WaitingBuilds' AND prepared IS NOT NULL AND ios_receipt IS NULL;
            INSERT INTO platform_provisioning.mobile_package_owners(package,tenant_id)
                SELECT android_package,tenant_id FROM platform_provisioning.mobile_identity_versions
                UNION SELECT ios_bundle,tenant_id FROM platform_provisioning.mobile_identity_versions
                UNION SELECT COALESCE(request->>'AndroidPackageName','com.example.tenant'||tenant_id),tenant_id FROM platform_provisioning.jobs
                    WHERE request->>'MobileReleaseProfile' IN ('AndroidAppDistribution','AndroidIosAppDistribution')
                UNION SELECT COALESCE(request->>'IosBundleId','com.example.tenant'||tenant_id),tenant_id FROM platform_provisioning.jobs
                    WHERE request->>'MobileReleaseProfile' IN ('AndroidAppDistribution','AndroidIosAppDistribution')
                ON CONFLICT DO NOTHING;
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_mobile_identity_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN
                IF (NEW.id,NEW.tenant_id,NEW.business_app_id,NEW.owner_subject,NEW.generation,NEW.legacy,NEW.android_package,NEW.ios_bundle,NEW.domain_request_id,NEW.expected_active_id,NEW.request) IS DISTINCT FROM
                    (OLD.id,OLD.tenant_id,OLD.business_app_id,OLD.owner_subject,OLD.generation,OLD.legacy,OLD.android_package,OLD.ios_bundle,OLD.domain_request_id,OLD.expected_active_id,OLD.request) OR
                    OLD.prepared IS NOT NULL AND NEW.prepared IS DISTINCT FROM OLD.prepared OR
                    OLD.android_receipt IS NOT NULL AND NEW.android_receipt IS DISTINCT FROM OLD.android_receipt OR
                    OLD.ios_receipt IS NOT NULL AND NEW.ios_receipt IS DISTINCT FROM OLD.ios_receipt THEN
                    RAISE EXCEPTION 'The package identity, signing bindings and completed build receipts are immutable' USING ERRCODE='23514';
                END IF;
                IF NOT NEW.legacy AND NEW.state IN ('Ready','Active','Retired') AND NOT (
                    COALESCE(NEW.android_receipt->>'Provider','')='AndroidAppDistribution' AND
                    COALESCE(NEW.android_receipt->'Resources'->>'androidApplicationId','')=NEW.android_package AND
                    COALESCE(NEW.android_receipt->'Resources'->>'signingCertificateSha256','')=COALESCE(NEW.prepared->>'AndroidCertificateSha256','!') AND
                    COALESCE(NEW.android_receipt->'Resources'->>'androidAppId','')=COALESCE(NEW.prepared->>'AndroidAppId','!') AND
                    COALESCE(NEW.android_receipt->'Resources'->>'storeUrl','')=NEW.request->>'StoreUrl' AND
                    COALESCE(NEW.ios_receipt->>'SigningCertificateSha256','')=COALESCE(NEW.prepared->'IosPlan'->>'SigningCertificateSha256','!') AND
                    COALESCE(NEW.ios_receipt->>'FirebaseSdkSha256','')=COALESCE(NEW.prepared->'IosPlan'->>'FirebaseSdkSha256','!') AND
                    COALESCE((NEW.ios_receipt->>'SymbolsUploaded')::boolean,false)
                ) THEN RAISE EXCEPTION 'Both matching signed platform builds are required before activation' USING ERRCODE='23514'; END IF;
                RETURN NEW;
            END;
            $$;
            DROP TRIGGER IF EXISTS immutable_mobile_identity_v1 ON platform_provisioning.mobile_identity_versions;
            CREATE TRIGGER immutable_mobile_identity_v1 BEFORE UPDATE ON platform_provisioning.mobile_identity_versions
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_mobile_identity_v1();
            """,connection,transaction);await command.ExecuteNonQueryAsync(ct);
    }
    public static Guid InitialId(string tenant,string deployment)
    {
        IosReleasePlan.Tenant(tenant);return new Guid(SHA256.HashData(Encoding.UTF8.GetBytes("mobile-initial-v1:"+deployment+":"+tenant))[..16]);
    }
    public async Task<MobileIdentityVersion?> GetAsync(Guid id,Guid owner,CancellationToken ct=default)
    {
        await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.mobile_identity_versions WHERE id=$1 AND owner_subject=$2");
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(owner);return await OneAsync(command,ct);
    }
    public async Task<MobileIdentityVersion?> ActiveForWorkerAsync(string tenant,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$1 AND state='Active'");
        command.Parameters.AddWithValue(tenant);return await OneAsync(command,ct);
    }
    public async Task<MobileIdentityVersion?> GetForWorkerAsync(string tenant,Guid id,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.mobile_identity_versions WHERE id=$1 AND tenant_id=$2");
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(tenant);return await OneAsync(command,ct);
    }
    public async Task<IReadOnlyList<MobileIdentityVersion>> ListAsync(string tenant,Guid owner,CancellationToken ct=default)
    {
        IosReleasePlan.Tenant(tenant);await using var command=db.CreateCommand($"SELECT {Columns} FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$1 AND owner_subject=$2 ORDER BY generation DESC LIMIT 100");
        command.Parameters.AddWithValue(tenant);command.Parameters.AddWithValue(owner);await using var reader=await command.ExecuteReaderAsync(ct);
        var result=new List<MobileIdentityVersion>();while(await reader.ReadAsync(ct))result.Add(Read(reader));return result;
    }
    public async Task<bool> TryReservePackageAsync(string package,string tenant,CancellationToken ct)
    {
        await using var connection=await db.OpenConnectionAsync(ct);
        await using var transaction=await connection.BeginTransactionAsync(ct);
        var result=await ReserveAsync(connection,transaction,package,tenant,ct);await transaction.CommitAsync(ct);return result;
    }
    private static async Task<bool> ReserveAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,string package,string tenant,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);
        if(package.Length>220 || !System.Text.RegularExpressions.Regex.IsMatch(package,"^[A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)+\\z"))throw new ArgumentException("Use a bounded mobile package identity.");
        await using(var insert=new NpgsqlCommand("INSERT INTO platform_provisioning.mobile_package_owners(package,tenant_id) VALUES($1,$2) ON CONFLICT DO NOTHING",connection,transaction))
        {insert.Parameters.AddWithValue(package);insert.Parameters.AddWithValue(tenant);await insert.ExecuteNonQueryAsync(ct);}
        await using var owner=new NpgsqlCommand("SELECT tenant_id FROM platform_provisioning.mobile_package_owners WHERE package=$1",connection,transaction);
        owner.Parameters.AddWithValue(package);return (await owner.ExecuteScalarAsync(ct) as string)==tenant;
    }
    public async Task<bool> PackageTakenAsync(string package,string tenant,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);
        await using var command=db.CreateCommand("SELECT EXISTS(SELECT 1 FROM platform_provisioning.mobile_package_owners WHERE package=$1 AND tenant_id<>$2)");
        command.Parameters.AddWithValue(package);command.Parameters.AddWithValue(tenant);return await command.ExecuteScalarAsync(ct) is true;
    }
    public Task<MobileIdentityVersion> EnsureInitialAsync(ProvisioningJob original,Guid businessApp,Guid owner,CancellationToken ct=default)
    {
        var r=original.Request;
        return ImportInitialAsync(new(InitialId(r.TenantId,r.DeploymentId!),r.TenantId,businessApp,owner,r.DeploymentId!,
            r.AndroidPackageName??"com.example.tenant"+r.TenantId,r.IosBundleId??"com.example.tenant"+r.TenantId,
            original.Steps["publication"].Resources["storeUrl"],r.Domain,null,DomainActivationPlan.Digest(r),1),original,ct);
    }
    public async Task<MobileIdentityVersion> ImportInitialAsync(MobileIdentityRequest request,ProvisioningJob original,CancellationToken ct=default)
    {
        request.Validate(legacy:true);
        if(request.Id!=InitialId(request.TenantId,request.DeploymentId) || original.State!="Succeeded" || original.Request.MobileReleaseProfile is not ("AndroidAppDistribution" or "AndroidIosAppDistribution") || original.Request.TenantId!=request.TenantId ||
            original.Request.DeploymentId!=request.DeploymentId || DomainActivationPlan.Digest(original.Request)!=request.OriginalRequestSha256 ||
            request.AndroidPackageName!=(original.Request.AndroidPackageName??"com.example.tenant"+request.TenantId) ||
            request.IosBundleId!=(original.Request.IosBundleId??"com.example.tenant"+request.TenantId) || original.Request.Domain!=request.Domain ||
            !original.Steps.TryGetValue("publication",out var published) || published.Resources.GetValueOrDefault("storeUrl")!=request.StoreUrl ||
            !original.Steps.TryGetValue("mobile-android-release",out var android) || android.Resources.GetValueOrDefault("androidApplicationId")!=request.AndroidPackageName ||
            !IosReleasePlan.Digest(android.Resources.GetValueOrDefault("signingCertificateSha256")))throw new ProvisioningConflictException();
        var prior=await GetAsync(request.Id,request.OwnerSubject,ct);if(prior!=null){if(prior.Request!=request)throw new ProvisioningConflictException();return prior;}
        if(!await TryReservePackageAsync(request.AndroidPackageName,request.TenantId,ct) || !await TryReservePackageAsync(request.IosBundleId,request.TenantId,ct))
            throw new ProvisioningConflictException();
        await using var command=db.CreateCommand("""
            INSERT INTO platform_provisioning.mobile_identity_versions(id,tenant_id,business_app_id,owner_subject,generation,legacy,android_package,ios_bundle,domain_request_id,request,state,android_receipt)
            VALUES($1,$2,$3,$4,0,true,$5,$6,$7,$8::jsonb,'Active',$9::jsonb) ON CONFLICT DO NOTHING
            """);AddRequest(command,request,includeExpected:false);command.Parameters.AddWithValue(JsonSerializer.Serialize(android));await command.ExecuteNonQueryAsync(ct);
        var saved=await GetAsync(request.Id,request.OwnerSubject,ct);if(saved==null || saved.Request!=request)throw new ProvisioningConflictException();return saved;
    }
    public async Task<MobileIdentityVersion> EnqueueAsync(MobileIdentityRequest request,CancellationToken ct=default)
    {
        request.Validate();await using var connection=await db.OpenConnectionAsync(ct);await using var transaction=await connection.BeginTransactionAsync(ct);
        await using(var parent=new NpgsqlCommand("SELECT state FROM platform_provisioning.jobs WHERE tenant_id=$1 AND request->>'DeploymentId'=$2 FOR UPDATE",connection,transaction))
        {parent.Parameters.AddWithValue(request.TenantId);parent.Parameters.AddWithValue(request.DeploymentId);if((await parent.ExecuteScalarAsync(ct) as string)!="Succeeded")throw new ProvisioningConflictException();}
        var prior=await GetAsync(request.Id,request.OwnerSubject,ct);if(prior!=null){if(prior.Request!=request)throw new ProvisioningConflictException();await transaction.CommitAsync(ct);return prior;}
        await using(var active=new NpgsqlCommand("SELECT id FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$1 AND owner_subject=$2 AND state='Active'",connection,transaction))
        {active.Parameters.AddWithValue(request.TenantId);active.Parameters.AddWithValue(request.OwnerSubject);if(await active.ExecuteScalarAsync(ct) is not Guid id || id!=request.ExpectedActiveId)throw new ProvisioningConflictException();}
        await using(var obsolete=new NpgsqlCommand("""
            UPDATE platform_provisioning.mobile_identity_versions SET state='Superseded',error_code='DomainTargetChanged',linux_token=NULL,linux_until=NULL,ios_token=NULL,ios_until=NULL,updated_at=now()
            WHERE tenant_id=$1 AND NOT legacy AND state IN ('Preparing','WaitingBuilds','Ready','Failed') AND domain_request_id IS DISTINCT FROM $2
            """,connection,transaction))
        {obsolete.Parameters.AddWithValue(request.TenantId);obsolete.Parameters.Add(new NpgsqlParameter{NpgsqlDbType=NpgsqlTypes.NpgsqlDbType.Uuid,Value=request.Domain?.Id is {} domainId?domainId:DBNull.Value});await obsolete.ExecuteNonQueryAsync(ct);}
        foreach(var package in new[]{request.AndroidPackageName,request.IosBundleId}.Distinct(StringComparer.Ordinal).Order(StringComparer.Ordinal))
            if(!await ReserveAsync(connection,transaction,package,request.TenantId,ct))throw new ProvisioningConflictException();
        await using var insert=new NpgsqlCommand("""
            INSERT INTO platform_provisioning.mobile_identity_versions(id,tenant_id,business_app_id,owner_subject,android_package,ios_bundle,domain_request_id,expected_active_id,request,generation)
            SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9::jsonb,1+COALESCE((SELECT max(generation) FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$2),0)
            WHERE (($7 IS NOT NULL AND EXISTS(SELECT 1 FROM platform_provisioning.domain_requests WHERE id=$7 AND tenant_id=$2 AND owner_subject=$4 AND state='Active' AND is_primary)) OR
                ($7 IS NULL AND NOT EXISTS(SELECT 1 FROM platform_provisioning.domain_requests WHERE tenant_id=$2 AND state='Active' AND is_primary) AND EXISTS(
                    SELECT 1 FROM platform_provisioning.jobs WHERE tenant_id=$2 AND steps->'publication'->'Resources'->>'storeUrl'=($9::jsonb)->>'StoreUrl')))
                AND NOT EXISTS(SELECT 1 FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$2 AND state IN ('Preparing','WaitingBuilds','Ready'))
            ON CONFLICT DO NOTHING
            """,connection,transaction);AddRequest(insert,request,includeExpected:true);
        if(await insert.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningConflictException();await transaction.CommitAsync(ct);return (await GetAsync(request.Id,request.OwnerSubject,ct))!;
    }
    private static void AddRequest(NpgsqlCommand command,MobileIdentityRequest r,bool includeExpected)
    {
        command.Parameters.AddWithValue(r.Id);command.Parameters.AddWithValue(r.TenantId);command.Parameters.AddWithValue(r.BusinessAppId);command.Parameters.AddWithValue(r.OwnerSubject);
        command.Parameters.AddWithValue(r.AndroidPackageName);command.Parameters.AddWithValue(r.IosBundleId);
        command.Parameters.Add(new NpgsqlParameter{NpgsqlDbType=NpgsqlTypes.NpgsqlDbType.Uuid,Value=r.Domain?.Id is {} id?id:DBNull.Value});
        if(includeExpected)command.Parameters.AddWithValue(r.ExpectedActiveId!.Value);
        command.Parameters.AddWithValue(JsonSerializer.Serialize(r));
    }
    public async Task<MobileIdentityLease?> ClaimLinuxAsync(string deployment,CancellationToken ct)
    {
        var token=Guid.NewGuid();await using var command=db.CreateCommand($"""
            UPDATE platform_provisioning.mobile_identity_versions SET linux_token=$1,linux_until=now()+interval '2 minutes',attempts=attempts+1,updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.mobile_identity_versions WHERE NOT legacy AND request->>'DeploymentId'=$2 AND (state IN ('Preparing','WaitingBuilds') AND android_receipt IS NULL OR state='Ready') AND available_at<=now() AND (linux_token IS NULL OR linux_until<now()) ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING {Columns}
            """);command.Parameters.AddWithValue(token);command.Parameters.AddWithValue(deployment);var version=await OneAsync(command,ct);return version==null?null:new(version,token,"android");
    }
    public async Task<MobileIdentityLease?> ClaimIosAsync(IosWorkerIdentity worker,CancellationToken ct)
    {
        worker.Validate();var token=Guid.NewGuid();await using var command=db.CreateCommand($"""
            UPDATE platform_provisioning.mobile_identity_versions SET ios_token=$1,ios_until=now()+interval '2 minutes',ios_attempts=ios_attempts+1,updated_at=now()
            WHERE id=(SELECT id FROM platform_provisioning.mobile_identity_versions WHERE state='WaitingBuilds' AND ios_receipt IS NULL AND prepared IS NOT NULL
                AND request->>'DeploymentId'=$2 AND prepared->'IosPlan'->>'DevelopmentTeam'=$3 AND prepared->'IosPlan'->>'SigningCertificateSha256'=$4 AND prepared->'IosPlan'->>'SourceHash'=$5
                AND available_at<=now() AND (ios_token IS NULL OR ios_until<now()) ORDER BY available_at,id LIMIT 1 FOR UPDATE SKIP LOCKED)
            RETURNING {Columns}
            """);command.Parameters.AddWithValue(token);command.Parameters.AddWithValue(worker.DeploymentId);command.Parameters.AddWithValue(worker.DevelopmentTeam);
        command.Parameters.AddWithValue(worker.SigningCertificateSha256);command.Parameters.AddWithValue(worker.SourceHash);var version=await OneAsync(command,ct);return version==null?null:new(version,token,"ios");
    }
    public Task RenewAsync(MobileIdentityLease lease,CancellationToken ct)=>OwnedAsync(lease,lease.Platform=="ios"?"ios_until=now()+interval '2 minutes'":"linux_until=now()+interval '2 minutes'",ct);
    public async Task PrepareAsync(MobileIdentityLease lease,PreparedMobileIdentity prepared,CancellationToken ct)
    {
        if(lease.Platform!="android")throw new ProvisioningLeaseLostException();prepared.Validate(lease.Version.Request);
        await using var project=db.CreateCommand("SELECT COALESCE(steps->'google-firebase'->'Resources'->>'projectId','')=$2 AND COALESCE(steps->'google-firebase'->'Resources'->>'projectNumber','')=$3 FROM platform_provisioning.jobs WHERE tenant_id=$1 AND state='Succeeded'");
        project.Parameters.AddWithValue(lease.Version.Request.TenantId);project.Parameters.AddWithValue(prepared.ProjectId);project.Parameters.AddWithValue(prepared.ProjectNumber);
        if(await project.ExecuteScalarAsync(ct) is not true)throw new ProvisioningConflictException();
        await OwnedAsync(lease,"prepared=$3::jsonb,state='WaitingBuilds',error_code=NULL,updated_at=now()",ct,JsonSerializer.Serialize(prepared));
    }
    public async Task CompleteAndroidAsync(MobileIdentityLease lease,ProvisioningStepResult receipt,CancellationToken ct)
    {
        if(lease.Platform!="android")throw new ProvisioningLeaseLostException();var current=await GetForWorkerAsync(lease.Version.Request.TenantId,lease.Version.Request.Id,ct) ?? throw new ProvisioningLeaseLostException();
        (current.Prepared??throw new InvalidOperationException("Prepare the signing bindings before build completion.")).ValidateAndroid(current.Request,receipt);
        await OwnedAsync(lease,"android_receipt=$3::jsonb,state=CASE WHEN ios_receipt IS NOT NULL THEN 'Ready' ELSE 'WaitingBuilds' END,linux_token=NULL,linux_until=NULL,error_code=NULL,updated_at=now()",ct,JsonSerializer.Serialize(receipt));
        await TryPromoteAsync(current.Request.Id,current.Request.TenantId,ct);
    }
    public async Task CompleteIosAsync(MobileIdentityLease lease,IosReleaseReceipt receipt,CancellationToken ct)
    {
        if(lease.Platform!="ios")throw new ProvisioningLeaseLostException();var prepared=lease.Version.Prepared??throw new InvalidOperationException("Missing prepared iOS identity.");
        prepared.Validate(lease.Version.Request);receipt.Validate(prepared.IosPlan);
        await OwnedAsync(lease,"ios_receipt=$3::jsonb,state=CASE WHEN android_receipt IS NOT NULL THEN 'Ready' ELSE 'WaitingBuilds' END,ios_token=NULL,ios_until=NULL,error_code=NULL,updated_at=now()",ct,JsonSerializer.Serialize(receipt));
        await TryPromoteAsync(lease.Version.Request.Id,lease.Version.Request.TenantId,ct);
    }
    public async Task<bool> TryPromoteAsync(Guid id,string tenant,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);await using var connection=await db.OpenConnectionAsync(ct);await using var transaction=await connection.BeginTransactionAsync(ct);
        await using(var gate=new NpgsqlCommand("SELECT pg_advisory_xact_lock(hashtextextended($1,734180227))",connection,transaction)){gate.Parameters.AddWithValue(tenant);await gate.ExecuteNonQueryAsync(ct);}
        MobileIdentityVersion version;
        await using(var read=new NpgsqlCommand($"SELECT {Columns} FROM platform_provisioning.mobile_identity_versions WHERE id=$1 AND tenant_id=$2 FOR UPDATE",connection,transaction))
        {read.Parameters.AddWithValue(id);read.Parameters.AddWithValue(tenant);version=await OneAsync(read,ct)??throw new ProvisioningConflictException();}
        if(version.State=="Active"){await transaction.CommitAsync(ct);return true;}
        if(version.State!="Ready"){await transaction.CommitAsync(ct);return false;}
        var prepared=version.Prepared??throw new InvalidOperationException();prepared.ValidateAndroid(version.Request,version.AndroidReceipt!);version.IosReceipt!.Validate(prepared.IosPlan);
        await using var active=new NpgsqlCommand("SELECT id FROM platform_provisioning.mobile_identity_versions WHERE tenant_id=$1 AND state='Active' FOR UPDATE",connection,transaction);active.Parameters.AddWithValue(tenant);
        if(await active.ExecuteScalarAsync(ct) is not Guid previous || previous!=version.Request.ExpectedActiveId)throw new ProvisioningConflictException();
        await using var domain=new NpgsqlCommand("SELECT id FROM platform_provisioning.domain_requests WHERE tenant_id=$1 AND is_primary AND state='Active'",connection,transaction);domain.Parameters.AddWithValue(tenant);
        var currentPrimary=await domain.ExecuteScalarAsync(ct);
        if(version.Request.Domain==null ? currentPrimary is Guid : currentPrimary is not Guid primary || primary!=version.Request.Domain.Id)
        {
            await using var stale=new NpgsqlCommand("UPDATE platform_provisioning.mobile_identity_versions SET state='Superseded',error_code='DomainTargetChanged',updated_at=now() WHERE id=$1",connection,transaction);stale.Parameters.AddWithValue(id);await stale.ExecuteNonQueryAsync(ct);
            await transaction.CommitAsync(ct);return false;
        }
        await using(var retire=new NpgsqlCommand("UPDATE platform_provisioning.mobile_identity_versions SET state='Retired',updated_at=now() WHERE id=$1",connection,transaction)){retire.Parameters.AddWithValue(previous);await retire.ExecuteNonQueryAsync(ct);}
        await using(var promote=new NpgsqlCommand("UPDATE platform_provisioning.mobile_identity_versions SET state='Active',linux_token=NULL,linux_until=NULL,ios_token=NULL,ios_until=NULL,error_code=NULL,updated_at=now() WHERE id=$1",connection,transaction)){promote.Parameters.AddWithValue(id);await promote.ExecuteNonQueryAsync(ct);}
        await transaction.CommitAsync(ct);return true;
    }
    public Task FailAsync(MobileIdentityLease lease,string code,CancellationToken ct)
    {
        _=new TenantDomainException(code);var lane=lease.Platform=="ios"?"ios":"linux";
        var attempts=lease.Platform=="ios"?"ios_attempts":"attempts";
        return OwnedAsync(lease,$"state=CASE WHEN {attempts}>=5 THEN 'Failed' ELSE state END,error_code=$3,available_at=now()+interval '30 seconds',{lane}_token=NULL,{lane}_until=NULL,updated_at=now()",ct,code);
    }
    public async Task<bool> RetryAsync(Guid id,Guid owner,CancellationToken ct)
    {
        var version=await GetAsync(id,owner,ct);
        if(version==null || version.State!="Failed")return false;
        await using var command=db.CreateCommand("""
            UPDATE platform_provisioning.mobile_identity_versions SET state=CASE WHEN prepared IS NULL THEN 'Preparing' WHEN android_receipt IS NOT NULL AND ios_receipt IS NOT NULL THEN 'Ready' ELSE 'WaitingBuilds' END,
                attempts=0,ios_attempts=0,error_code=NULL,linux_token=NULL,linux_until=NULL,ios_token=NULL,ios_until=NULL,available_at=now(),updated_at=now()
            WHERE id=$1 AND owner_subject=$2 AND state='Failed' AND ((domain_request_id IS NOT NULL AND EXISTS(
                SELECT 1 FROM platform_provisioning.domain_requests d WHERE d.id=domain_request_id AND d.tenant_id=mobile_identity_versions.tenant_id AND d.state='Active' AND d.is_primary)) OR
                (domain_request_id IS NULL AND NOT EXISTS(SELECT 1 FROM platform_provisioning.domain_requests d WHERE d.tenant_id=mobile_identity_versions.tenant_id AND d.is_primary)))
            """);
        command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(owner);return await command.ExecuteNonQueryAsync(ct)==1;
    }
    private async Task OwnedAsync(MobileIdentityLease lease,string update,CancellationToken ct,params string[] values)
    {
        var lane=lease.Platform switch{"android"=>"linux","ios"=>"ios",_=>throw new ArgumentException("Unknown mobile worker lane.")};
        await using var command=db.CreateCommand($"UPDATE platform_provisioning.mobile_identity_versions SET {update} WHERE id=$1 AND {lane}_token=$2 AND {lane}_until>now() AND state IN ('Preparing','WaitingBuilds','Ready')");
        command.Parameters.AddWithValue(lease.Version.Request.Id);command.Parameters.AddWithValue(lease.Token);foreach(var value in values)command.Parameters.AddWithValue(value);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw new ProvisioningLeaseLostException();
    }
    private static async Task<MobileIdentityVersion?> OneAsync(NpgsqlCommand command,CancellationToken ct)
    {await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?Read(reader):null;}
    private static MobileIdentityVersion Read(NpgsqlDataReader r)=>new(JsonSerializer.Deserialize<MobileIdentityRequest>(r.GetString(0))!,r.GetInt32(1),r.GetBoolean(2),r.GetString(3),r.GetInt32(4),
        r.IsDBNull(5)?null:JsonSerializer.Deserialize<PreparedMobileIdentity>(r.GetString(5)),r.IsDBNull(6)?null:JsonSerializer.Deserialize<ProvisioningStepResult>(r.GetString(6)),
        r.IsDBNull(7)?null:JsonSerializer.Deserialize<IosReleaseReceipt>(r.GetString(7)),r.IsDBNull(8)?null:r.GetString(8),r.GetFieldValue<DateTimeOffset>(9),r.GetFieldValue<DateTimeOffset>(10)) { IosAttempts=r.GetInt32(11) };
    public ValueTask DisposeAsync()=>db.DisposeAsync();
}
