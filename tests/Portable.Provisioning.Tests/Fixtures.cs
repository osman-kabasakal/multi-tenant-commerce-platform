using System.Net;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

internal sealed class Fixture:IDisposable
{
    public string Root {get;}=Path.Combine(OperatingSystem.IsMacOS()?"/private/tmp":Path.GetTempPath(),"portable-onboarding-"+Guid.NewGuid().ToString("N"));
    public Dictionary<string,string?> Values {get;}=[];
    public Fixture()
    {
        Directory.CreateDirectory(Path.Combine(Root,"installer/wwwroot"));File.WriteAllText(Path.Combine(Root,"installer/installer.dll"),"");File.WriteAllText(Path.Combine(Root,"installer/wwwroot/logo.png"),"");
        File.WriteAllText(Path.Combine(Root,"commerce.json"),"{\"PlatformConfiguration\":{\"Provider\":\"Environment\"},\"PlatformSecurity\":{\"Provider\":\"AesGcm\"},\"LocalDemo\":{\"Enabled\":false}}");
        foreach(var pair in new Dictionary<string,string> {
            ["DeploymentId"]="contract-deployment",["MongoAdminConnection"]="mongodb://administrator:contract@127.0.0.1:27028/admin?authSource=admin",
            ["InstallerPath"]=Path.Combine(Root,"installer/installer.dll"),["CommerceConfigPath"]=Path.Combine(Root,"commerce.json"),
            ["StoreBaseUrl"]="https://shops.example.test",["AdminBaseUrl"]="https://manage.example.test",["KeycloakAuthority"]="https://identity.example.test",
            ["KeycloakRealm"]="commerce",["KeycloakAdminRealm"]="commerce",["KeycloakAdminClientId"]="provisioner",["KeycloakAdminClientSecret"]="contract-only" }) Values["Provisioning:Portable:"+pair.Key]=pair.Value;
        foreach(var name in new[]{"WorkingDirectory","TenantDirectory","RouteDirectory","MobileDirectory","NotificationDirectory"}) Values["Provisioning:Portable:"+name]=Path.Combine(Root,name);
        Values["PlatformSecurity:Provider"]="AesGcm";Values["LocalDemo:Enabled"]="false";Values["Provisioning:Google:Provider"]="Disabled";
        Values["Provisioning:Domains:Provider"]="Wildcard";Values["Provisioning:Domains:WildcardConfigured"]="true";
    }
    public IConfiguration Config()=>new ConfigurationBuilder().AddInMemoryCollection(Values).Build();
    public PortableOnboardingOptions Options(){var options=Config().GetSection("Provisioning:Portable").Get<PortableOnboardingOptions>()!;options.Validate("Production",Config());return options;}
    public TenantDomainOptions Domains()=>new(){Provider="Wildcard",WildcardConfigured=true};
    public static TenantProvisioningRequest Request()=>new(Guid.NewGuid().ToString("N"),"contract-shop","Contract Store","owner@example.test","Contract","Owner","Street","000","owner@example.test","test.example.contract","test.example.contract");
    public static Dictionary<string,ProvisioningStepResult> Completed(TenantProvisioningRequest request)=>new(){["store"]=new("GrandNode",new Dictionary<string,string>{{"storeId","store-owned"}}),["tenant-plugins"]=new("GrandNode",new Dictionary<string,string>{{"storeId","store-owned"},{"profileVersion","1"},{"task","tenant-plugins"}}),["tenant-migrations"]=new("GrandNode",new Dictionary<string,string>{{"storeId","store-owned"},{"profileVersion","1"},{"task","tenant-migrations"}}),["tenant-settings"]=new("GrandNode",new Dictionary<string,string>{{"storeId","store-owned"},{"profileVersion","1"},{"task","tenant-settings"}}),["identity"]=new("Keycloak",new Dictionary<string,string>{{"clientId",request.Slug}}),["domains"]=new("Wildcard",new Dictionary<string,string>{{"storeHost",request.Slug+".shops.example.test"},{"adminHost",request.Slug+".manage.example.test"}})};
    public void Dispose(){if(Directory.Exists(Root))Directory.Delete(Root,true);}
}
internal sealed class MemorySecrets:ITenantSecrets
{
    public Dictionary<(string,string),string> Values=[];public Dictionary<string,string> Aliases=[];public int Creates;
    public Task ProvisionAsync(string tenant,string alias,CancellationToken ct=default)=>Task.CompletedTask;
    public Task BindAliasAsync(string tenant,string alias,CancellationToken ct=default)=>Task.CompletedTask;
    public Task<string> ResolveAsync(string tenant,CancellationToken ct=default)=>Task.FromResult(Aliases.TryGetValue(tenant,out var canonical)?canonical:tenant);
    public Task<string> GetAsync(string tenant,string name,CancellationToken ct=default)=>Task.FromResult(Values[(tenant,name)]);
    public Task SetAsync(string tenant,string name,string value,CancellationToken ct=default){Values[(tenant,name)]=value;return Task.CompletedTask;}
    public Task<string> GetOrCreateAsync(string tenant,string name,Func<string> create,CancellationToken ct=default){if(!Values.ContainsKey((tenant,name))){Creates++;Values[(tenant,name)]=create();}return GetAsync(tenant,name,ct);}
}
internal sealed class Factory(Func<string,HttpRequestMessage,Task<HttpResponseMessage>> send):IHttpClientFactory
{
    public HttpClient CreateClient(string name)=>new(new Handler(request=>send(name,request)));
    private sealed class Handler(Func<HttpRequestMessage,Task<HttpResponseMessage>> send):HttpMessageHandler
    {protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)=>send(request);}
    public static HttpResponseMessage Json(object value,HttpStatusCode status=HttpStatusCode.OK)=>new(status){Content=new StringContent(JsonSerializer.Serialize(value),Encoding.UTF8,"application/json")};
}
