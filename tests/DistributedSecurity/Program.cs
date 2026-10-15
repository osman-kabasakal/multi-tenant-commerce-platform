using System.Diagnostics;
using System.Reflection;
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;
using Platform.Security;

var configPath=Path.GetFullPath(args[0]);
var configuration=new ConfigurationBuilder().AddJsonFile(configPath,false).Build();
using var provider=new ServiceCollection().AddPlatformSecurity(configuration,"Development").BuildServiceProvider();
var tenants=provider.GetRequiredService<ITenantSecrets>();
var store=provider.GetRequiredService<ISecretStore>();
var encryption=provider.GetRequiredService<ITenantEncryptionService>();
const string tenant="business-a", alias="shop-a", value="synthetic-database-credential";
void Check(bool ok,string message) { if(!ok) throw new Exception(message); Console.WriteLine("PASS "+message); }
async Task Reject<T>(Func<Task> action,string message) where T:Exception
{
    try { await action(); } catch(T) { Console.WriteLine("PASS "+message); return; }
    throw new Exception("Expected rejection: "+message);
}
if(args.Length>1 && args[1]=="reader")
{
    Check(await tenants.GetAsync("store-a",TenantSecretNames.DatabaseConnection)==value,"independent commerce process reads SaaS secret by store alias");
    var cipher=await store.GetAsync("system","worker-cipher");
    Check(await encryption.DecryptAsync(cipher,alias)==value,"independent process decrypts worker ciphertext");
    await Reject<UnauthorizedAccessException>(()=>tenants.SetAsync(alias,TenantSecretNames.DatabaseConnection,"bad"),"reader cannot overwrite secrets");
    await Reject<KeyNotFoundException>(()=>tenants.GetAsync("shop-b",TenantSecretNames.DatabaseConnection),"tenant B cannot read tenant A secret");
    return;
}
if(args.Length>1 && args[1]=="worker")
{
    await tenants.BindAliasAsync(alias,"store-a");
    Check(await tenants.GetAsync(tenant,TenantSecretNames.DatabaseConnection)==value,"independent TenantManager process reads registration secret");
    await store.SetAsync("system","worker-cipher",await encryption.EncryptAsync(value,alias));
    return;
}
await tenants.ProvisionAsync(tenant,alias);
await tenants.ProvisionAsync("business-b","shop-b");
await tenants.SetAsync(tenant,TenantSecretNames.DatabaseConnection,value);
var key=await tenants.GetAsync(tenant,TenantSecretNames.FrontendApi);
await Task.WhenAll(Enumerable.Range(0,24).Select(async _=> {
    using var independent=new ServiceCollection().AddPlatformSecurity(configuration,"Development").BuildServiceProvider();
    var service=independent.GetRequiredService<ITenantSecrets>();
    await service.ProvisionAsync(tenant,alias);
    if(await service.GetAsync(alias,TenantSecretNames.FrontendApi)!=key) throw new Exception("Secret changed on concurrent retry.");
}));
Check(true,"24 concurrent independent providers preserve one tenant secret");
await Reject<InvalidOperationException>(()=>tenants.ProvisionAsync("business-b",alias),"alias cannot be reassigned to another business");
await Reject<KeyNotFoundException>(()=>tenants.GetAsync("missing-tenant",TenantSecretNames.FrontendApi),"missing tenant does not use a default key");
await Reject<KeyNotFoundException>(()=>tenants.GetAsync(alias,"missing-secret"),"reads never manufacture missing secrets");
await Child(configPath,"worker");
var readerPath=configPath+".reader.json";
var readerConfig=JsonSerializer.Deserialize<Dictionary<string,JsonElement>>(File.ReadAllText(configPath))!;
var security=JsonSerializer.Deserialize<Dictionary<string,object>>(readerConfig["PlatformSecurity"].GetRawText())!;
security["ReadOnly"]=true; security["InitializeSchema"]=false;
readerConfig["PlatformSecurity"]=JsonSerializer.SerializeToElement(security);
await File.WriteAllTextAsync(readerPath,JsonSerializer.Serialize(readerConfig));
if(!OperatingSystem.IsWindows())File.SetUnixFileMode(readerPath,UnixFileMode.UserRead|UnixFileMode.UserWrite);
try { await Child(readerPath,"reader"); } finally {File.Delete(readerPath);}
using(var source=NpgsqlDataSource.Create(configuration["PlatformSecurity:ConnectionString"]!))
{
    await using var command=source.CreateCommand("SELECT ciphertext FROM platform_security.secrets");
    await using var reader=await command.ExecuteReaderAsync();
    while(await reader.ReadAsync())
    {
        var raw=reader.GetString(0);
        if(raw.Contains(value)||raw.Contains(key))throw new Exception("Plaintext secret in database.");
    }
}
Check(true,"database rows contain ciphertext only");
using(var mismatch=new PostgresSecretStore(configuration["PlatformSecurity:ConnectionString"]!,
    new LocalEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)))))
    await Reject<AuthenticationTagMismatchException>(()=>mismatch.InitializeAsync(),"another replica with a different master key fails before serving traffic");
var original=await tenants.GetAsync(alias,TenantSecretNames.FrontendApi);
await tenants.SetAsync(alias,TenantSecretNames.FrontendApi,"updated-synthetic-key");
Check(await tenants.GetAsync("store-a",TenantSecretNames.FrontendApi)=="updated-synthetic-key","secret update is immediately visible without stale cache");
await tenants.SetAsync(alias,TenantSecretNames.FrontendApi,original);
Console.WriteLine("Distributed secret integration passed.");

static async Task Child(string config,string role)
{
    var info=new ProcessStartInfo("dotnet") {UseShellExecute=false};
    info.ArgumentList.Add(Assembly.GetExecutingAssembly().Location); info.ArgumentList.Add(config); info.ArgumentList.Add(role);
    using var child=Process.Start(info)!;
    await child.WaitForExitAsync();
    if(child.ExitCode!=0)throw new Exception("Independent process failed: "+role);
}
