using System.Security.Cryptography;
using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Npgsql;
using SaasManager.Domain.Entities.Billing;

namespace SaasManager.Infrastructure.Data;

public sealed record BootstrapTrialPlan(Guid Id,string Name,string Code,decimal Price,int TrialDays,int MaxProducts,int MaxUsers,int MaxMonthlyOrders,string[] Features)
{
    public void Validate()
    {
        if(Id==Guid.Empty || string.IsNullOrWhiteSpace(Name) || Name.Length>50 || Name.Any(char.IsControl) ||
            !Regex.IsMatch(Code??"","^[A-Z][A-Z0-9_]{2,19}$") || Price is <0 or >100000000 || decimal.Round(Price,2)!=Price || TrialDays is <1 or >365 ||
            new[]{MaxProducts,MaxUsers,MaxMonthlyOrders}.Any(n=>n!= -1 && n<1) || Features==null || Features.Length>30 ||
            Features.Any(f=>string.IsNullOrWhiteSpace(f) || f.Length>200 || f.Any(char.IsControl)))
            throw new InvalidOperationException("Configure the initial public trial plan explicitly.");
    }
    public SubscriptionPlan Create()=>new(Name,Code,Price,MaxProducts,MaxUsers,MaxMonthlyOrders,false,false,
        JsonDocument.Parse(JsonSerializer.Serialize(Features)),TrialDays,"Operator-configured initial trial plan",0,true,0,1,3){Id=Id};
    public bool Matches(SubscriptionPlan plan)=>plan.Id==Id && plan.Name==Name && plan.Code==Code && plan.Price==Price &&
        plan.TrialDays==TrialDays && plan.MaxProducts==MaxProducts && plan.MaxUsers==MaxUsers && plan.MaxMonthlyOrders==MaxMonthlyOrders &&
        plan.IsActive && !plan.IsDeleted && plan.IsPublic && !plan.HasPos && !plan.HasCourier && plan.SetupFee==0 && plan.MaxCouriers==0 && plan.MaxLocations==1 &&
        plan.Features.RootElement.ValueKind==JsonValueKind.Array && plan.Features.RootElement.EnumerateArray().Select(x=>x.GetString()).SequenceEqual(Features);
}

public sealed record BootstrapDatabaseTarget(string Host,int Port,string Database)
{
    public static BootstrapDatabaseTarget Read(string value)
    {
        var connection=new NpgsqlConnectionStringBuilder(value);
        if(string.IsNullOrWhiteSpace(connection.Host) || string.IsNullOrWhiteSpace(connection.Database) ||
            connection.Database is "postgres" or "template0" or "template1" || !string.IsNullOrEmpty(connection.SearchPath))
            throw new InvalidOperationException("Use explicitly named application databases with their ordinary schemas.");
        return new(connection.Host.ToLowerInvariant(),connection.Port,connection.Database);
    }
}

public sealed record BootstrapDatabaseSpec(int Version,string DeploymentId,string EncryptionProvider,
    BootstrapDatabaseTarget Security,BootstrapDatabaseTarget Queue,BootstrapDatabaseTarget Saas,BootstrapTrialPlan Plan)
{
    [JsonIgnore] public string Fingerprint=>Convert.ToHexString(SHA256.HashData(JsonSerializer.SerializeToUtf8Bytes(this))).ToLowerInvariant();
}

public sealed record PortableBootstrapOptions(string SecurityConnection,string QueueConnection,string SaasConnection,BootstrapDatabaseSpec Spec)
{
    public static PortableBootstrapOptions Read(IConfiguration config,bool initialize)
    {
        var deployment=config["Bootstrap:DeploymentId"]??"";
        if(config.GetValue<bool>("LocalDemo:Enabled") || config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") ||
            !Regex.IsMatch(deployment,"^[a-z][a-z0-9-]{2,39}$") || initialize && !config.GetValue<bool>("Bootstrap:AllowSchemaChanges"))
            throw new InvalidOperationException("Portable bootstrap requires explicit deployment identity, production encryption and owner-authorized schema changes.");
        foreach(var id in new[]{config["Provisioning:DeploymentId"],config["Provisioning:Portable:DeploymentId"]}.Where(x=>!string.IsNullOrEmpty(x)))
            if(id!=deployment)throw new InvalidOperationException("Bootstrap and runtime deployment identities must match.");
        var plan=config.GetSection("Bootstrap:TrialPlan").Get<BootstrapTrialPlan>()??throw new InvalidOperationException("Select an initial trial plan explicitly.");plan.Validate();
        plan=plan with{Price=decimal.Parse(plan.Price.ToString("F2",CultureInfo.InvariantCulture),CultureInfo.InvariantCulture)};
        if(config.GetValue<bool>("TenantOnboarding:Trial:Enabled") && (!Guid.TryParse(config["TenantOnboarding:Trial:PlanId"],out var selected) || selected!=plan.Id))
            throw new InvalidOperationException("Runtime trial enrollment must select the bootstrapped plan.");
        var security=config["PlatformSecurity:ConnectionString"]??throw new InvalidOperationException("Configure the security database.");
        var queue=config["Provisioning:ConnectionString"]??security;
        var saas=config.GetConnectionString("SaasManagerDb")??throw new InvalidOperationException("Configure the SaaS database.");
        var spec=new BootstrapDatabaseSpec(1,deployment,config["PlatformSecurity:Provider"]!,BootstrapDatabaseTarget.Read(security),BootstrapDatabaseTarget.Read(queue),BootstrapDatabaseTarget.Read(saas),plan);
        if(spec.Saas.Database==spec.Security.Database || spec.Saas.Database==spec.Queue.Database)
            throw new InvalidOperationException("Keep the SaaS database separate from the named shared security/queue databases.");
        return new(security,queue,saas,spec);
    }
}
