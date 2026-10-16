using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Platform.Provisioning;
using SaasManager.Domain.Entities.Billing;
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
            await db.Database.MigrateAsync();
            if(await db.Businesses.AnyAsync() || await db.GuestRegistrations.AnyAsync() || await db.SubscriptionPlans.AnyAsync())throw new InvalidOperationException("Refusing to reuse existing fixture data.");
            db.SubscriptionPlans.Add(new SubscriptionPlan("Portable enrollment trial","PORTABLE_FIXTURE",299,100,3,1000,false,false,JsonDocument.Parse("{}"),14,"Synthetic configured trial",0,true,0,1,0){Id=planId});
            await db.SaveChangesAsync();Console.WriteLine("PASS: A fresh isolated SaaS database uses actual migrations and an explicit public trial plan");return;
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
        await using var queue=new PostgresProvisioningQueue(config["PlatformSecurity:ConnectionString"]!);
        foreach(var tenant in tenants)
        {
            var job=await queue.GetAsync(tenant);
            Check(job?.State=="Succeeded" && job.Request.DeploymentId==config["Provisioning:Portable:DeploymentId"],"The real SaaS-produced job completes only on its configured Production deployment");
        }
    }
}
