using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Platform.Provisioning;
using Microsoft.Extensions.DependencyInjection;
using Platform.Security;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;

internal static class EnrollmentDatabaseFixture
{
    public static async Task RunAsync(string mode,string path)
    {
        var config=new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(path)).Build();
        var id=config["Fixture:TenantId"]!;
        var connection=new NpgsqlConnectionStringBuilder(config.GetConnectionString("SaasManagerDb"));
        if(!Guid.TryParseExact(id,"N",out var parsed) || parsed.ToString("N")!=id || connection.Database!="portable_saas_test_"+id ||
            connection.Host is not ("127.0.0.1" or "localhost") || connection.Port!=15439 || mode is not ("init" or "verify"))
            throw new InvalidOperationException("Use only a uniquely owned local Production-enrollment fixture database.");
        await using var db=new ApplicationDbContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseNpgsql(connection.ConnectionString).Options);
        var planId=Guid.Parse(config["Fixture:TrialPlanId"]!);
        if(mode=="init")
        {
            var options=PortableBootstrapOptions.Read(config,true);
            var shared=new NpgsqlConnectionStringBuilder(options.SecurityConnection);
            var role="portable_saas_runtime_"+id;var password=config["Fixture:SaasRuntimePassword"]??"";
            if(shared.Database!="portable_worker_test_"+id || shared.Host is not ("127.0.0.1" or "localhost") || shared.Port!=15439 || !Regex.IsMatch(password,"^[a-f0-9]{64}$"))
                throw new InvalidOperationException("Use only the current fixture's owned shared database and runtime identity.");
            using var services=new ServiceCollection().AddPlatformSecurity(config,"Production").BuildServiceProvider();
            var bootstrap=new PortableDatabaseBootstrap(options,services.GetRequiredService<ISecretStore>(),services.GetRequiredService<PostgresSecretStore>());
            await bootstrap.InitializeAsync();await bootstrap.VerifyAsync();
            if(await db.Businesses.AnyAsync() || await db.GuestRegistrations.AnyAsync() || await db.SubscriptionPlans.CountAsync()!=1)throw new InvalidOperationException("Refusing to reuse existing fixture data.");
            await using(var owner=new NpgsqlConnection(connection.ConnectionString))
            {
                await owner.OpenAsync();
                await using var permissions=new NpgsqlCommand($"""
                    CREATE ROLE {role} LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD '{password}';
                    COMMENT ON ROLE {role} IS 'portable-saas-fixture:{id}';
                    REVOKE CREATE ON SCHEMA public FROM PUBLIC;
                    GRANT USAGE ON SCHEMA public,platform_bootstrap TO {role};
                    GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO {role};
                    REVOKE INSERT,UPDATE,DELETE ON public."__EFMigrationsHistory" FROM {role};
                    GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA public TO {role};
                    GRANT SELECT ON platform_bootstrap.saas_state TO {role};
                    """,owner);await permissions.ExecuteNonQueryAsync();
            }
            await using(var owner=new NpgsqlConnection(options.SecurityConnection))
            {
                await owner.OpenAsync();
                await using var permissions=new NpgsqlCommand($"""
                    REVOKE CREATE ON SCHEMA public FROM PUBLIC;
                    GRANT USAGE ON SCHEMA platform_security,platform_provisioning,platform_bootstrap TO {role};
                    GRANT SELECT,INSERT,UPDATE ON platform_security.secrets,platform_security.tenants,platform_security.aliases TO {role};
                    GRANT SELECT,INSERT,UPDATE ON platform_provisioning.jobs TO {role};
                    GRANT USAGE ON SEQUENCE platform_provisioning.jobs_id_seq TO {role};
                    GRANT SELECT ON platform_bootstrap.queue_state TO {role};
                    """,owner);await permissions.ExecuteNonQueryAsync();
            }
            var runtimeConnection=new NpgsqlConnectionStringBuilder(connection.ConnectionString){Username=role,Password=password};
            await using(var runtime=new NpgsqlConnection(runtimeConnection.ConnectionString))
            {
                await runtime.OpenAsync();await using var permissions=new NpgsqlCommand("SELECT NOT rolsuper AND NOT rolcreatedb AND NOT rolcreaterole AND NOT has_database_privilege(current_user,current_database(),'CREATE') AND NOT has_schema_privilege(current_user,'public','CREATE') FROM pg_catalog.pg_roles WHERE rolname=current_user",runtime);
                if(await permissions.ExecuteScalarAsync() is not true)throw new InvalidOperationException("Runtime must have no schema/admin privileges.");
            }
            Console.WriteLine("PASS: Fresh Production enrollment uses the real owned database bootstrap, migrations and explicit trial plan");
            Console.WriteLine("PASS: The actual HTTPS SaaS host uses a distinct runtime login without schema or administrator privileges");return;
        }
        static void Check(bool condition,string message){Console.WriteLine((condition?"PASS: ":"FAIL: ")+message);if(!condition)throw new InvalidOperationException(message);}
        var tenants=config.GetSection("Fixture:EnrollmentTenants").Get<string[]>()??[];
        if(tenants.Length!=2 || tenants.Any(t=>!Guid.TryParseExact(t,"N",out _)) || !tenants.Contains(id))throw new InvalidOperationException("Require exactly the two synthetic enrollment owners.");
        var ids=tenants.Select(Guid.Parse).ToArray();var businesses=await db.Businesses.ToListAsync();
        Check(businesses.Count==2 && businesses.All(b=>ids.Contains(b.Id) && b.Status==BusinessStatus.Trial),"Actual SaaS HTTP enrollment persists two distinct ready trial businesses");
        var guests=await db.GuestRegistrations.ToListAsync();
        Check(guests.Count==2 && guests.All(g=>g.IsEmailVerified && g.IsConverted) && guests.Select(g=>g.KeycloakUserId).Distinct().Count()==2,"Each enrolled business belongs to its own verified real identity subject");
        var subscriptions=await db.BusinessSubscriptions.ToListAsync();
        Check(subscriptions.Count==2 && subscriptions.All(s=>s.PlanId==planId && s.IsTrial && s.Amount==0 && s.IsActive && s.EndDate>s.StartDate),"Enrollment/replay creates one configured zero-charge trial per business");
        Check(await db.Payments.CountAsync()==0 && await db.PaymentMethods.CountAsync()==0 && await db.PaymentProviders.CountAsync()==0,"The trial path creates no payment, card or implicit payment provider");
        var metadata=await db.DatabaseConfigs.ToListAsync();
        Check(metadata.Count==2 && metadata.All(d=>d.IsMigrated && d.EncryptedPassword.StartsWith("tenant-secret:",StringComparison.Ordinal)),"Durable completion stores shared secret references instead of copying database passwords into SaaS");
        var apps=await db.BusinessApps.ToListAsync();
        Check(apps.Count==2 && apps.All(a=>a.StoreUrl.StartsWith("https://",StringComparison.Ordinal) && a.PackageName=="com.example.tenant"+a.BusinessId.ToString("N")),"Each customer app receives its own package identity and verified HTTPS tenant URL");
        await using(var deliveryDb=new NpgsqlConnection(config["PlatformSecurity:ConnectionString"]))
        {
            await deliveryDb.OpenAsync();
            await using var deliveries=new NpgsqlCommand("SELECT count(*) FROM platform_provisioning.readiness_deliveries WHERE tenant_id=ANY($1) AND deployment_id=$2 AND state='Pending'",deliveryDb);
            deliveries.Parameters.AddWithValue(tenants);deliveries.Parameters.AddWithValue(config["Provisioning:Portable:DeploymentId"]!);
            Check(await deliveries.ExecuteScalarAsync() is 2L,"Both actual Production tenants atomically enqueue exactly one readiness delivery after full worker completion");
        }
        await using var queue=new PostgresProvisioningQueue(config["PlatformSecurity:ConnectionString"]!);
        foreach(var tenant in tenants)
        {
            var job=await queue.GetAsync(tenant);
            Check(job?.State=="Succeeded" && job.Request.DeploymentId==config["Provisioning:Portable:DeploymentId"],"The real SaaS-produced job completes only on its configured Production deployment");
        }
    }
}
