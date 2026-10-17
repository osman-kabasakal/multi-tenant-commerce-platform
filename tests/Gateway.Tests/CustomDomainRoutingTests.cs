using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;
using Platform.Hosting;

namespace Gateway.Tests;

[TestClass]
public sealed class CustomDomainRoutingTests
{
    private static GatewayOptions Options(Fixture f,bool enabled=true)=>new(){Provider="Directory",RouteDirectory=f.Root,StoreBaseUrl="https://shops.example.test",AdminBaseUrl="https://manage.example.test",
        CommerceUpstream="https://commerce.internal",AdminUpstream="https://admin.internal",IdentityAuthority="https://identity.example.test",IdentityRealm="commerce",
        CustomDomainsEnabled=enabled,CertificatePermissionPeer="172.30.80.10"};
    private static async Task<TenantCustomHostRoute> Alias(Fixture f,string role="store")
    {
        var host=role=="admin"?"manage.customer.example.net":"customer.example.net";
        var value=new TenantCustomHostRoute(1,"Portable",f.Tenant,"alpha-shop","store-alpha",Guid.NewGuid(),host,role,
            "https://customer.example.net","https://manage.customer.example.net/Admin",true);
        await File.WriteAllTextAsync(TenantCustomHostRoutes.PathFor(f.Root,host),JsonSerializer.Serialize(value,new JsonSerializerOptions(JsonSerializerDefaults.Web)));return value;
    }
    [TestMethod]
    public async Task OwnedCustomStoreAndAdminKeepTheOriginalTenantAndLegacyAliases()
    {
        using var f=new Fixture();await f.Route();await Alias(f);await Alias(f,"admin");var options=Options(f);options.Validate(f.Config());
        var routes=new TenantRoutes(options,f.Secrets);
        var store=await routes.ResolveAsync(new HostString("customer.example.net"),default);
        var admin=await routes.ResolveAsync(new HostString("manage.customer.example.net"),default);
        var legacy=await routes.ResolveAsync(new HostString("alpha-shop.shops.example.test"),default);
        Assert.AreEqual(f.Tenant,store!.TenantId);Assert.IsFalse(store.Admin);Assert.IsTrue(admin!.Admin);Assert.AreEqual(legacy!.StoreId,store.StoreId);
        Assert.AreEqual(0,f.Secrets.Writes);
    }
    [DataTestMethod]
    [DataRow("foreign-tenant")][DataRow("foreign-host")][DataRow("certificate-disabled")][DataRow("symlink")][DataRow("oversize")]
    public async Task ACustomRouteCannotChangeItsHostTenantOrCertificatePermission(string change)
    {
        using var f=new Fixture();var alias=await Alias(f);var path=TenantCustomHostRoutes.PathFor(f.Root,alias.Host);
        if(change=="foreign-tenant")f.Secrets.Aliases["store-alpha"]=Guid.NewGuid().ToString("N");
        if(change=="foreign-host")alias=alias with{Host="other.example.net"};
        if(change=="certificate-disabled")alias=alias with{CertificateAllowed=false};
        await File.WriteAllTextAsync(path,JsonSerializer.Serialize(alias,new JsonSerializerOptions(JsonSerializerDefaults.Web)));
        if(change=="symlink"){var target=Path.Combine(f.Root,"target.json");File.Move(path,target);File.CreateSymbolicLink(path,target);}
        if(change=="oversize")await File.WriteAllTextAsync(path,new string(' ',16385));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new TenantRoutes(Options(f),f.Secrets).ResolveAsync(new HostString("customer.example.net"),default));
        Assert.AreEqual(0,f.Secrets.Writes);
    }
    [DataTestMethod]
    [DataRow("172.30.80.10","customer.example.net",true,204)]
    [DataRow("172.30.80.10","unknown.example.net",true,403)]
    [DataRow("192.0.2.10","customer.example.net",true,403)]
    [DataRow("172.30.80.11","customer.example.net",true,403)]
    [DataRow("172.30.80.10","customer.example.net:8443",true,403)]
    [DataRow("172.30.80.10","customer.example.net",false,403)]
    public async Task CertificatePermissionRequiresBothThePrivateEdgePeerAndAnOwnedCustomHost(string peer,string domain,bool enabled,int expected)
    {
        using var f=new Fixture();await Alias(f);var options=Options(f,enabled);
        using var services=new ServiceCollection().AddSingleton(new TenantRoutes(options,f.Secrets)).BuildServiceProvider();
        var http=new DefaultHttpContext{RequestServices=services};http.Request.Path="/_gateway/certificate-permission";
        http.Request.QueryString=new QueryString("?domain="+Uri.EscapeDataString(domain));http.Connection.RemoteIpAddress=IPAddress.Parse(peer);
        await GatewayApp.Forwarder(options,NullLogger.Instance)(http);Assert.AreEqual(expected,http.Response.StatusCode);Assert.AreEqual(0,f.Secrets.Writes);
    }
    [TestMethod]
    public async Task StorefrontAdminPathsStayUnavailableOnACustomStoreDomain()
    {
        using var f=new Fixture();await Alias(f);var options=Options(f);
        using var services=new ServiceCollection().AddSingleton(new TenantRoutes(options,f.Secrets)).BuildServiceProvider();
        var http=new DefaultHttpContext{RequestServices=services};http.Request.Scheme="https";http.Request.Host=new HostString("customer.example.net");http.Request.Path="/Admin/Product/List";
        await GatewayApp.Forwarder(options,NullLogger.Instance)(http);Assert.AreEqual(404,http.Response.StatusCode);Assert.AreEqual(0,f.Secrets.Writes);
    }
}
