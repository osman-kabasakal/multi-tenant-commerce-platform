using System.Collections.Concurrent;
using System.Net;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Platform.Gateway;
using Platform.Security;

namespace Gateway.Tests;

internal sealed class Fixture : IDisposable
{
    public string Root { get; } = Path.Combine(OperatingSystem.IsMacOS() ? "/private/tmp" : Path.GetTempPath(), "gateway-test-" + Guid.NewGuid().ToString("N"));
    public string Tenant { get; } = Guid.NewGuid().ToString("N");
    public MemorySecrets Secrets { get; } = new();
    public Dictionary<string, string?> Values { get; } = new() {
        ["LocalDemo:Enabled"]="false", ["PlatformSecurity:Provider"]="AesGcm", ["PlatformSecurity:ReadOnly"]="true", ["PlatformSecurity:InitializeSchema"]="false" };
    public Fixture() { Directory.CreateDirectory(Root); Secrets.Aliases["alpha-shop"]=Tenant; Secrets.Aliases["store-alpha"]=Tenant; Secrets.Values[(Tenant,TenantSecretNames.KeycloakClient)]="private-alpha-client"; }
    public GatewayOptions Options(string commerce="https://commerce.internal", bool http=false) => new() {
        Provider="Directory", RouteDirectory=Root, StoreBaseUrl="https://shops.example.test", AdminBaseUrl="https://manage.example.test",
        CommerceUpstream=commerce, AdminUpstream="https://admin.internal", AllowHttpUpstreams=http, IdentityAuthority="https://identity.example.test", IdentityRealm="commerce" };
    public IConfiguration Config()=>new ConfigurationBuilder().AddInMemoryCollection(Values).Build();
    public Task Route(string? tenant=null,string profile="Portable",string? storeUrl=null,string? adminUrl=null)=>File.WriteAllTextAsync(Path.Combine(Root,"alpha-shop.json"),JsonSerializer.Serialize(new {
        version=1,profile,tenantId=tenant??Tenant,slug="alpha-shop",storeId="store-alpha",storeUrl=storeUrl??"https://alpha-shop.shops.example.test/",adminUrl=adminUrl??"https://alpha-shop.manage.example.test/Admin" }));
    public TenantRoute TenantRoute()=>new(Tenant,"alpha-shop","store-alpha",false);
    public void Dispose()=>Directory.Delete(Root,true);
}
internal sealed class MemorySecrets : ITenantSecrets
{
    public ConcurrentDictionary<(string,string),string> Values {get;}=new();
    public Dictionary<string,string> Aliases {get;}=new();
    public int Writes;
    public Task ProvisionAsync(string tenant,string alias,CancellationToken ct=default){Interlocked.Increment(ref Writes);throw new InvalidOperationException("Read-only gateway");}
    public Task BindAliasAsync(string tenant,string alias,CancellationToken ct=default){Interlocked.Increment(ref Writes);throw new InvalidOperationException("Read-only gateway");}
    public Task<string> ResolveAsync(string alias,CancellationToken ct=default)=>Task.FromResult(Aliases[alias]);
    public Task<string> GetAsync(string tenant,string name,CancellationToken ct=default)=>Task.FromResult(Values[(tenant,name)]);
    public Task SetAsync(string tenant,string name,string value,CancellationToken ct=default){Interlocked.Increment(ref Writes);throw new InvalidOperationException("Read-only gateway");}
    public Task<string> GetOrCreateAsync(string tenant,string name,Func<string> create,CancellationToken ct=default){Interlocked.Increment(ref Writes);throw new InvalidOperationException("Read-only gateway");}
}
internal sealed class Factory(Func<HttpRequestMessage,CancellationToken,Task<HttpResponseMessage>> send) : IHttpClientFactory
{
    public HttpClient CreateClient(string name)=>new(new Handler(send));
    private sealed class Handler(Func<HttpRequestMessage,CancellationToken,Task<HttpResponseMessage>> send):HttpMessageHandler
    {protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)=>send(request,ct);}
    public static HttpResponseMessage Json(object value,HttpStatusCode status=HttpStatusCode.OK)=>new(status){Content=new StringContent(JsonSerializer.Serialize(value),Encoding.UTF8,"application/json")};
}
