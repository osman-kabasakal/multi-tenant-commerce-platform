using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Platform.Provisioning;
using Platform.Security;

namespace SaasManager.Infrastructure.Data;

/// <summary>Owner-only initialization. Runtime web hosts use verification and never perform this DDL.</summary>
public sealed class PortableDatabaseBootstrap(PortableBootstrapOptions options,ISecretStore secrets,PostgresSecretStore security)
{
    public const string BindingName="platform-database-bootstrap-v1";
    private const long LockId=734180227;
    public async Task InitializeAsync(CancellationToken ct=default)
    {
        await using var shared=new NpgsqlConnection(options.SecurityConnection);await shared.OpenAsync(ct);
        await using var application=new NpgsqlConnection(options.SaasConnection);await application.OpenAsync(ct);
        await using var queueDb=new NpgsqlConnection(options.QueueConnection);await queueDb.OpenAsync(ct);
        await using var sharedLock=await LockAsync(shared,ct);await using var appLock=await LockAsync(application,ct);
        await using var queueLock=options.Spec.Queue==options.Spec.Security?null:await LockAsync(queueDb,ct);
        var hasBinding=await TableAsync(shared,"platform_security.secrets",ct) && await ScalarAsync<bool>(shared,
            "SELECT EXISTS(SELECT 1 FROM platform_security.secrets WHERE scope='system' AND name=$1)",ct,BindingName);
        var app=await ReadStateAsync(application,ct);
        var queueState=await ReadStateAsync(queueDb,ct,queue:true);
        RequireMatchingState(app);RequireMatchingState(queueState);
        if(options.Spec.Queue!=options.Spec.Security && await TableAsync(shared,"platform_bootstrap.queue_state",ct))
            throw new InvalidOperationException("The security target contains unrelated queue ownership data.");
        if(app?.State=="Complete" && (!await TableAsync(application,"public.\"__EFMigrationsHistory\"",ct) || !await TableAsync(application,"public.\"SubscriptionPlans\"",ct)))
            throw new InvalidOperationException("The completed SaaS database lost its migration or plan tables; restore it explicitly.");
        if(hasBinding && (app==null || queueState==null))
            throw new InvalidOperationException("An owned database lost its bootstrap marker; restore the original databases explicitly.");
        if((app?.State=="Complete" || queueState?.State=="Complete") && !hasBinding)
            throw new InvalidOperationException("The completed bootstrap lost an ownership marker; restore the original databases explicitly.");
        if(queueState?.State=="Complete" && !await TableAsync(queueDb,"platform_provisioning.jobs",ct))
            throw new InvalidOperationException("The owned queue lost its jobs table; restore it explicitly.");
        if(queueState==null)await RequireUnusedSharedDatabaseAsync(queueDb,ct);
        if(!hasBinding)
        {
            await RequireUnusedSharedDatabaseAsync(shared,ct);
            if(options.Spec.Queue!=options.Spec.Security)
            {
                await RequireUnusedSharedDatabaseAsync(queueDb,ct);
            }
            if(app==null && await HasUserRelationsAsync(application,[],ct))
                throw new InvalidOperationException("Refusing to initialize an unowned nonempty SaaS database.");
        }
        else
        {
            if(!await TableAsync(shared,"platform_security.tenants",ct) || !await TableAsync(shared,"platform_security.aliases",ct))
                throw new InvalidOperationException("The owned security store lost its tenant schema; restore it explicitly.");
            if(!await ScalarAsync<bool>(shared,"SELECT EXISTS(SELECT 1 FROM platform_security.secrets WHERE scope='system' AND name='deployment-probe')",ct))
                throw new InvalidOperationException("The owned security store lost its encryption probe; restore it explicitly.");
            await security.InitializeAsync(ct);
            var saved=await secrets.GetAsync("system",BindingName,ct);
            if(saved!=options.Spec.Fingerprint)throw new InvalidOperationException("The original bootstrap database targets or plan changed.");
            if(app==null && await HasUserRelationsAsync(application,[],ct))
                throw new InvalidOperationException("The original SaaS bootstrap marker is missing; restore it explicitly.");
        }
        // Reserve the app target before migrations so another deployment cannot adopt a partially initialized database.
        await ReserveAsync(application,ct);
        await ReserveAsync(queueDb,ct,queue:true);
        await security.InitializeAsync(ct);
        var binding=await secrets.GetOrCreateAsync("system",BindingName,()=>options.Spec.Fingerprint,ct);
        if(binding!=options.Spec.Fingerprint)throw new InvalidOperationException("Another bootstrap target owns the shared store.");
        await using(var queue=new PostgresProvisioningQueue(options.QueueConnection))await queue.InitializeAsync(ct);
        await ExecuteAsync(queueDb,"UPDATE platform_bootstrap.queue_state SET state='Complete' WHERE singleton=1 AND deployment_id=$1 AND spec_sha256=$2",ct,options.Spec.DeploymentId,options.Spec.Fingerprint);
        await using(var db=Context(options.SaasConnection))
        {
            await db.Database.MigrateAsync(ct);
            var plan=await db.SubscriptionPlans.SingleOrDefaultAsync(p=>p.Id==options.Spec.Plan.Id,ct);
            if(plan==null)
            {
                if(app?.State=="Complete")throw new InvalidOperationException("The completed bootstrap lost its original plan; restore or manage it explicitly.");
                if(await db.SubscriptionPlans.AnyAsync(p=>p.Code==options.Spec.Plan.Code,ct))throw new InvalidOperationException("The configured plan code already belongs to another plan.");
                db.SubscriptionPlans.Add(options.Spec.Plan.Create());await db.SaveChangesAsync(ct);
            }
            else if(!options.Spec.Plan.Matches(plan))throw new InvalidOperationException("The initial plan changed; manage that change explicitly instead of reseeding.");
        }
        await ExecuteAsync(application,"UPDATE platform_bootstrap.saas_state SET state='Complete' WHERE singleton=1 AND deployment_id=$1 AND spec_sha256=$2",ct,options.Spec.DeploymentId,options.Spec.Fingerprint);
        await VerifyAsync(ct);
    }
    public async Task VerifyAsync(CancellationToken ct=default)
    {
        if(await secrets.GetAsync("system",BindingName,ct)!=options.Spec.Fingerprint)throw new InvalidOperationException("Shared bootstrap binding mismatch.");
        await using var db=Context(options.SaasConnection);await RequireCurrentMigrationsAsync(db,ct);
        await using var app=new NpgsqlConnection(options.SaasConnection);await app.OpenAsync(ct);var state=await ReadStateAsync(app,ct);
        if(state==null || state.State!="Complete" || state.DeploymentId!=options.Spec.DeploymentId || state.SpecSha256!=options.Spec.Fingerprint || state.PlanId!=options.Spec.Plan.Id)
            throw new InvalidOperationException("The owned SaaS bootstrap is incomplete or belongs to another target.");
        var plan=await db.SubscriptionPlans.SingleOrDefaultAsync(p=>p.Id==options.Spec.Plan.Id,ct);
        if(plan==null || !options.Spec.Plan.Matches(plan))throw new InvalidOperationException("The configured initial plan no longer matches its bootstrap specification.");
        await using var queue=new NpgsqlConnection(options.QueueConnection);await queue.OpenAsync(ct);
        var queueState=await ReadStateAsync(queue,ct,queue:true);RequireMatchingState(queueState);
        if(queueState?.State!="Complete")throw new InvalidOperationException("The owned queue bootstrap is incomplete.");
        if(!await ScalarAsync<bool>(queue,"SELECT count(*)=3 FROM pg_catalog.pg_trigger WHERE tgrelid='platform_provisioning.jobs'::regclass AND tgname IN ('enforce_job_requirements_v1','enqueue_tenant_ready_v1','enforce_ios_release_v1') AND NOT tgisinternal AND tgenabled IN ('O','A')",ct) || (!await TableAsync(queue,"platform_provisioning.readiness_deliveries",ct) || !await TableAsync(queue,"platform_provisioning.ios_release_jobs",ct) || !await TableAsync(queue,"platform_provisioning.android_build_jobs",ct) || !await TableAsync(queue,"platform_provisioning.domain_requests",ct) || !await TableAsync(queue,"platform_provisioning.domain_zone_claims",ct) || !await TableAsync(queue,"platform_provisioning.domain_activation_jobs",ct) || !await TableAsync(queue,"platform_provisioning.mobile_identity_versions",ct) || !await TableAsync(queue,"platform_provisioning.mobile_package_owners",ct) || !await TableAsync(queue,"platform_provisioning.mobile_identity_source_repairs",ct) || !await TableAsync(queue,"platform_provisioning.mobile_brand_images",ct) || !await TableAsync(queue,"platform_provisioning.ios_build_jobs",ct)))
            throw new InvalidOperationException("The provisioning queue requires its current owner-applied protocol schema.");
    }
    public static async Task VerifyRuntimeAsync(ApplicationDbContext db,IConfiguration config,bool requireOwnership,CancellationToken ct=default)
    {
        await RequireCurrentMigrationsAsync(db,ct);
        if(requireOwnership)
        {
            var deployment=config["Provisioning:DeploymentId"];
            await using var connection=new NpgsqlConnection(db.Database.GetConnectionString());await connection.OpenAsync(ct);
            var state=await ReadStateAsync(connection,ct);
            if(state==null || state.State!="Complete" || string.IsNullOrWhiteSpace(deployment) || state.DeploymentId!=deployment)
                throw new InvalidOperationException("Run the owner bootstrap for this deployment before starting SaaS.");
            if(config.GetValue<bool>("TenantOnboarding:Trial:Enabled") &&
                (!Guid.TryParse(config["TenantOnboarding:Trial:PlanId"],out var plan) || plan!=state.PlanId ||
                 !await db.SubscriptionPlans.AnyAsync(p=>p.Id==plan && p.IsActive && p.IsPublic && !p.IsDeleted && p.TrialDays>0,ct)))
                throw new InvalidOperationException("The configured public trial plan is not initialized.");
        }
    }
    private static async Task RequireCurrentMigrationsAsync(ApplicationDbContext db,CancellationToken ct)
    {
        if((await db.Database.GetPendingMigrationsAsync(ct)).Any())
            throw new InvalidOperationException("SaaS migrations are pending. Run the owner bootstrap before starting runtime instances.");
    }
    private static ApplicationDbContext Context(string connection)=>new(new DbContextOptionsBuilder<ApplicationDbContext>().UseNpgsql(connection).Options);
    private void RequireMatchingState(BootstrapState? state)
    {
        if(state!=null && (state.DeploymentId!=options.Spec.DeploymentId || state.SpecSha256!=options.Spec.Fingerprint || state.PlanId!=options.Spec.Plan.Id))
            throw new InvalidOperationException("The database already belongs to a different bootstrap target or plan.");
    }
    private async Task ReserveAsync(NpgsqlConnection app,CancellationToken ct,bool queue=false)
    {
        var table=queue?"queue_state":"saas_state";
        await using(var transaction=await app.BeginTransactionAsync(ct))
        {
            await using(var ddl=new NpgsqlCommand($$"""
                CREATE SCHEMA IF NOT EXISTS platform_bootstrap;
                CREATE TABLE IF NOT EXISTS platform_bootstrap.{{table}}(
                    singleton integer PRIMARY KEY CHECK(singleton=1),deployment_id text NOT NULL,plan_id uuid NOT NULL,
                    spec_sha256 text NOT NULL CHECK(spec_sha256 ~ '^[a-f0-9]{64}$'),state text NOT NULL CHECK(state IN ('Initializing','Complete')),
                    initialized_at timestamptz NOT NULL DEFAULT now());
                """,app,transaction))await ddl.ExecuteNonQueryAsync(ct);
            await using(var insert=new NpgsqlCommand($"INSERT INTO platform_bootstrap.{table}(singleton,deployment_id,plan_id,spec_sha256,state) VALUES(1,$1,$2,$3,'Initializing') ON CONFLICT DO NOTHING",app,transaction))
            {
                insert.Parameters.AddWithValue(options.Spec.DeploymentId);insert.Parameters.AddWithValue(options.Spec.Plan.Id);insert.Parameters.AddWithValue(options.Spec.Fingerprint);
                await insert.ExecuteNonQueryAsync(ct);
            }
            await transaction.CommitAsync(ct);
        }
        var state=await ReadStateAsync(app,ct,queue);
        if(state==null || state.DeploymentId!=options.Spec.DeploymentId || state.SpecSha256!=options.Spec.Fingerprint || state.PlanId!=options.Spec.Plan.Id)
            throw new InvalidOperationException("Another deployment owns the SaaS bootstrap reservation.");
    }
    private static async Task RequireUnusedSharedDatabaseAsync(NpgsqlConnection connection,CancellationToken ct)
    {
        if(await HasUserRelationsAsync(connection,["platform_security.secrets","platform_security.tenants","platform_security.aliases","platform_provisioning.jobs","platform_provisioning.readiness_deliveries","platform_provisioning.ios_release_jobs","platform_provisioning.android_build_jobs","platform_provisioning.schema_versions","platform_provisioning.domain_requests","platform_provisioning.domain_zone_claims","platform_provisioning.domain_activation_jobs","platform_provisioning.mobile_identity_versions","platform_provisioning.mobile_package_owners","platform_provisioning.mobile_identity_source_repairs","platform_provisioning.mobile_brand_images","platform_provisioning.ios_build_jobs","platform_bootstrap.queue_state"],ct))throw new InvalidOperationException("The shared bootstrap target contains unrelated application tables.");
        if(await TableAsync(connection,"platform_security.tenants",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_security.tenants)",ct))
            throw new InvalidOperationException("The unowned security store already contains tenants.");
        if(await TableAsync(connection,"platform_security.secrets",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_security.secrets WHERE NOT(scope='system' AND name='deployment-probe'))",ct))
            throw new InvalidOperationException("The unowned security store already contains secret data.");
        if(await TableAsync(connection,"platform_provisioning.readiness_deliveries",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_provisioning.readiness_deliveries)",ct))
            throw new InvalidOperationException("The unowned provisioning database already contains readiness deliveries.");
        if(await TableAsync(connection,"platform_provisioning.android_build_jobs",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_provisioning.android_build_jobs)",ct))
            throw new InvalidOperationException("The unowned provisioning database already contains Android builds.");
        if(await TableAsync(connection,"platform_provisioning.ios_release_jobs",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_provisioning.ios_release_jobs)",ct))
            throw new InvalidOperationException("The unowned provisioning database already contains iOS releases.");
        foreach(var table in new[]{"domain_requests","domain_zone_claims","domain_activation_jobs","mobile_identity_versions", "mobile_package_owners", "mobile_identity_source_repairs","mobile_brand_images","ios_build_jobs"})
            if(await TableAsync(connection,"platform_provisioning."+table,ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_provisioning."+table+")",ct))
                throw new InvalidOperationException("The unowned provisioning database already contains domain ownership or migration data.");
        if(await TableAsync(connection,"platform_provisioning.jobs",ct) && await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM platform_provisioning.jobs)",ct))
            throw new InvalidOperationException("The unowned provisioning database already contains jobs.");
    }
    private static async Task<bool> HasUserRelationsAsync(NpgsqlConnection connection,string[] ignored,CancellationToken ct)=>
        await ScalarAsync<bool>(connection,"SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace WHERE c.relkind IN ('r','p','v','m','f') AND n.nspname NOT LIKE 'pg_%' AND n.nspname<>'information_schema' AND NOT((n.nspname||'.'||c.relname)=ANY($1)))",ct,(object)ignored);
    private static Task<bool> TableAsync(NpgsqlConnection connection,string table,CancellationToken ct)=>ScalarAsync<bool>(connection,"SELECT pg_catalog.to_regclass($1) IS NOT NULL",ct,table);
    private static async Task<BootstrapLock> LockAsync(NpgsqlConnection connection,CancellationToken ct)
    {
        using var deadline=CancellationTokenSource.CreateLinkedTokenSource(ct);deadline.CancelAfter(TimeSpan.FromSeconds(30));
        try{while(!await ScalarAsync<bool>(connection,"SELECT pg_catalog.pg_try_advisory_lock($1)",deadline.Token,LockId))await Task.Delay(250,deadline.Token);return new(connection);}
        catch(OperationCanceledException)when(!ct.IsCancellationRequested){throw new TimeoutException("Another owner bootstrap is still initializing this target.");}
    }
    private sealed class BootstrapLock(NpgsqlConnection connection) : IAsyncDisposable
    {
        public async ValueTask DisposeAsync()
        {
            if(connection.State!=System.Data.ConnectionState.Open)return;
            try{await ScalarAsync<bool>(connection,"SELECT pg_catalog.pg_advisory_unlock($1)",CancellationToken.None,LockId);}
            catch(NpgsqlException){await connection.CloseAsync();}
        }
    }
    private sealed record BootstrapState(string DeploymentId,Guid PlanId,string SpecSha256,string StateName)
    {public string State=>StateName;}
    private static async Task<BootstrapState?> ReadStateAsync(NpgsqlConnection connection,CancellationToken ct,bool queue=false)
    {
        var table=queue?"platform_bootstrap.queue_state":"platform_bootstrap.saas_state";
        if(!await TableAsync(connection,table,ct))return null;
        await using var command=new NpgsqlCommand($"SELECT deployment_id,plan_id,spec_sha256,state FROM {table} WHERE singleton=1",connection);
        await using var reader=await command.ExecuteReaderAsync(ct);return await reader.ReadAsync(ct)?new(reader.GetString(0),reader.GetGuid(1),reader.GetString(2),reader.GetString(3)):null;
    }
    private static async Task<T> ScalarAsync<T>(NpgsqlConnection connection,string sql,CancellationToken ct,params object[] values)
    {
        await using var command=new NpgsqlCommand(sql,connection);foreach(var value in values)command.Parameters.Add(new NpgsqlParameter{Value=value});
        return (T)(await command.ExecuteScalarAsync(ct)??throw new InvalidOperationException("Bootstrap metadata is missing."));
    }
    private static async Task ExecuteAsync(NpgsqlConnection connection,string sql,CancellationToken ct,params object[] values)
    {await using var command=new NpgsqlCommand(sql,connection);foreach(var value in values)command.Parameters.Add(new NpgsqlParameter{Value=value});await command.ExecuteNonQueryAsync(ct);}
}
