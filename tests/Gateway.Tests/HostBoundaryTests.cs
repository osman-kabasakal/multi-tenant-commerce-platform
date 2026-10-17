using System.Net;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;

namespace Gateway.Tests;

[TestClass]
public sealed class HostBoundaryTests
{
    [DataTestMethod]
    [DataRow("/Admin")]
    [DataRow("/admin/")]
    [DataRow("/ADMIN/Product/List")]
    [DataRow("/Admin/Product/List?keep=one")]
    public async Task StoreAdminPathsStopBeforeTokenAcquisitionAndUpstream(string path)
    {
        using var f=new Fixture();await f.Route();
        var builder=WebApplication.CreateBuilder();builder.Logging.ClearProviders();
        builder.Services.AddSingleton(new TenantRoutes(f.Options(),f.Secrets));
        // Tokens and forwarder are deliberately absent: a forbidden route must never resolve either.
        await using var app=builder.Build();
        var context=new DefaultHttpContext{RequestServices=app.Services};
        context.Request.Scheme="https";context.Request.Host=new HostString("alpha-shop.shops.example.test");
        var uri=new Uri("https://alpha-shop.shops.example.test"+path);context.Request.Path=uri.AbsolutePath;context.Request.QueryString=new QueryString(uri.Query);
        await GatewayApp.Forwarder(f.Options(),app.Logger)(context);
        Assert.AreEqual(StatusCodes.Status404NotFound,context.Response.StatusCode);
        Assert.IsFalse(context.Response.Headers.ContainsKey("Location"));Assert.AreEqual(0,f.Secrets.Writes);
    }

    [DataTestMethod]
    [DataRow("alpha-shop.manage.example.test","/Admin/Product/List")]
    [DataRow("alpha-shop.manage.example.test","/_content/Grand.SharedUIResources/administration/build/css/custom.css")]
    [DataRow("alpha-shop.shops.example.test","/administrator-guide")]
    public async Task ManageRoutesRemainReachableAndStoreLookalikesAreNotBlocked(string host,string path)
    {
        using var f=new Fixture();await f.Route();
        var upstreamBuilder=WebApplication.CreateBuilder();upstreamBuilder.Logging.ClearProviders();upstreamBuilder.WebHost.UseUrls("http://127.0.0.1:0");
        await using var upstream=upstreamBuilder.Build();var calls=0;upstream.Run(async context=>{Interlocked.Increment(ref calls);context.Response.ContentType=path.EndsWith(".css")?"text/css":"text/plain";await context.Response.WriteAsync("actual-upstream");});await upstream.StartAsync();
        var options=new GatewayOptions{RouteDirectory=f.Root,StoreBaseUrl="https://shops.example.test",AdminBaseUrl="https://manage.example.test",CommerceUpstream=upstream.Urls.Single(),AdminUpstream=upstream.Urls.Single()};
        var builder=WebApplication.CreateBuilder();builder.Logging.ClearProviders();builder.WebHost.UseUrls("http://127.0.0.1:0");
        builder.Services.AddSingleton(new TenantRoutes(options,f.Secrets));builder.Services.AddHttpForwarder();
        builder.Services.AddSingleton(new TenantTokens(options,f.Secrets,new Factory((_,_)=>throw new InvalidOperationException("Identity intentionally unavailable for the neighboring store path"))));
        builder.Services.AddSingleton(new HttpMessageInvoker(new SocketsHttpHandler{AllowAutoRedirect=false,UseProxy=false,UseCookies=false}));
        await using var gateway=builder.Build();gateway.Use((context,next)=>{context.Request.Scheme="https";return next(context);});
        gateway.Run(GatewayApp.Forwarder(options,gateway.Logger));await gateway.StartAsync();
        using var client=new HttpClient();using var request=new HttpRequestMessage(HttpMethod.Get,gateway.Urls.Single()+path);request.Headers.Host=host;
        using var response=await client.SendAsync(request);
        if(host.Contains(".manage.")){Assert.AreEqual(HttpStatusCode.OK,response.StatusCode);Assert.AreEqual("actual-upstream",await response.Content.ReadAsStringAsync());Assert.AreEqual(1,calls);}
        else { // A neighboring route reaches token acquisition instead of being mistaken for /Admin.
            Assert.AreEqual(HttpStatusCode.ServiceUnavailable,response.StatusCode);
        }
    }
}
