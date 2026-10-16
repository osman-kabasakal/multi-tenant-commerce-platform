using System.Text.Json;
using Grand.Web.ExternalSettings.Extensions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Security;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class AdminRoutingTests
{
    [TestMethod]
    public async Task OwnedHostSelectsOnlyItsSecretDatabaseAndStillRequiresAdminAuthentication()
    {
        using var f=new Fixture();var options=f.Options();var request=Fixture.Request();var secrets=new MemorySecrets();secrets.Aliases[request.Slug]=request.TenantId;secrets.Aliases["store-owned"]=request.TenantId;
        await secrets.SetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,"private-owned-connection");
        await WriteRoute(options.RouteDirectory,request.TenantId,request.Slug);
        await using var app=App(f,secrets);var calls=0;
        app.UsePortableTenantRouting();app.Run(context=>{calls++;Assert.AreEqual("store-owned",context.Items["StoreId"]);Assert.AreEqual("private-owned-connection",context.Items["StoreMongoConnectionString"]);context.Response.StatusCode=401;return Task.CompletedTask;});
        var context=Context(app,request.Slug+".manage.example.test");context.Request.Headers["X-Platform-Tenant"]="forged";
        await ((IApplicationBuilder)app).Build()(context);
        Assert.AreEqual(1,calls);Assert.AreEqual(401,context.Response.StatusCode);Assert.AreEqual(request.TenantId,context.Response.Headers["X-Platform-Tenant"].ToString());Assert.IsFalse(context.User.Identity?.IsAuthenticated==true);
    }
    [DataTestMethod]
    [DataRow("foreign-host")]
    [DataRow("unknown-tenant")]
    [DataRow("foreign-binding")]
    [DataRow("wrong-port")]
    public async Task InvalidHostOrOwnershipNeverReachesTheAdminPipeline(string scenario)
    {
        using var f=new Fixture();var options=f.Options();var request=Fixture.Request();var secrets=new MemorySecrets();secrets.Aliases[request.Slug]=request.TenantId;secrets.Aliases["store-owned"]=scenario=="foreign-binding"?"foreign":request.TenantId;
        await secrets.SetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,"private-owned-connection");await WriteRoute(options.RouteDirectory,request.TenantId,request.Slug);
        await using var app=App(f,secrets);var calls=0;app.UsePortableTenantRouting();app.Run(_=>{calls++;return Task.CompletedTask;});
        var host=scenario switch {"foreign-host"=>request.Slug+".foreign.test","unknown-tenant"=>"unknown-shop.manage.example.test","wrong-port"=>request.Slug+".manage.example.test:8443",_=>request.Slug+".manage.example.test"};
        var context=Context(app,host);await ((IApplicationBuilder)app).Build()(context);Assert.AreEqual(0,calls);Assert.IsTrue(context.Response.StatusCode is 400 or 404);
    }
    private static WebApplication App(Fixture f,MemorySecrets secrets)
    {
        var builder=WebApplication.CreateBuilder(new WebApplicationOptions{ContentRootPath=f.Root,EnvironmentName="Production",Args=[]});
        builder.Configuration.AddInMemoryCollection(new Dictionary<string,string?> { ["PlatformSecurity:Provider"]="AesGcm",["LocalDemo:Enabled"]="false",
            ["TenantRouting:Provider"]="Directory",["TenantRouting:RouteDirectory"]=Path.Combine(f.Root,"RouteDirectory"),["TenantRouting:AdminParentDomains:0"]="manage.example.test" });
        builder.Services.AddSingleton<ITenantSecrets>(secrets);return builder.Build();
    }
    private static DefaultHttpContext Context(WebApplication app,string host){var context=new DefaultHttpContext{RequestServices=app.Services};context.Request.Host=new HostString(host);return context;}
    private static Task WriteRoute(string directory,string tenant,string slug)=>File.WriteAllTextAsync(Path.Combine(directory,slug+".json"),JsonSerializer.Serialize(new{version=1,profile="Portable",tenantId=tenant,slug,storeId="store-owned",adminUrl="https://"+slug+".manage.example.test/Admin"}));
}
