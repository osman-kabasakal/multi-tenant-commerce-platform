using System.Net;
using System.Net.Http.Headers;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;
using Yarp.ReverseProxy.Forwarder;

namespace Gateway.Tests;

[TestClass]
public sealed class ForwardingTests
{
    [TestMethod]
    public async Task RealForwardingPreservesUploadsCustomerBearerCookiesAndRangesWithoutTrustingCallerTokens()
    {
        var bytes=Encoding.UTF8.GetBytes(new string('x',65536));
        await using var upstream=App();
        upstream.MapPost("/echo",async(HttpContext context)=>{
            using var body=new StreamReader(context.Request.Body);var content=await body.ReadToEndAsync();
            context.Response.Headers.Append("Set-Cookie","session=owned; Path=/; Secure; HttpOnly; SameSite=Lax");context.Response.Headers["x-store-token"]="must-not-leak";context.Response.Headers["Authorization"]="must-not-leak";
            return Results.Json(new{host=context.Request.Host.Value,token=context.Request.Headers["x-store-token"].ToString(),auth=context.Request.Headers.Authorization.ToString(),forwarded=context.Request.Headers["Forwarded"].ToString(),proto=context.Request.Headers["X-Forwarded-Proto"].ToString(),ip=context.Request.Headers["X-Forwarded-For"].ToString(),tenant=context.Request.Headers["X-Platform-Tenant"].ToString(),query=context.Request.QueryString.Value,content});});
        upstream.MapGet("/file",()=>Results.File(bytes,"application/octet-stream",enableRangeProcessing:true));
        await upstream.StartAsync();
        await using var gateway=Proxy(upstream.Urls.Single(),false);await gateway.StartAsync();using var client=new HttpClient();
        using var request=new HttpRequestMessage(HttpMethod.Post,gateway.Urls.Single()+"/echo?keep=one&store_token=forged&keep=two");
        request.Headers.Host="alpha-shop.shops.example.test";request.Headers.Authorization=new AuthenticationHeaderValue("Bearer","customer-token");request.Headers.Add("x-store-token","forged");request.Headers.Add("Forwarded","host=attacker.test");request.Headers.Add("X-Forwarded-Proto","ftp");request.Headers.Add("X-Forwarded-For","203.0.113.99");request.Headers.Add("X-Platform-Tenant","foreign");request.Content=new StringContent("actual-upload-body");
        using var response=await client.SendAsync(request);Assert.AreEqual(HttpStatusCode.OK,response.StatusCode);using var result=JsonDocument.Parse(await response.Content.ReadAsStringAsync());var value=result.RootElement;
        Assert.AreEqual("alpha-shop.shops.example.test",value.GetProperty("host").GetString());Assert.AreEqual("owned.payload.signature",value.GetProperty("token").GetString());Assert.AreEqual("Bearer customer-token",value.GetProperty("auth").GetString());Assert.AreEqual("",value.GetProperty("forwarded").GetString());Assert.AreEqual("https",value.GetProperty("proto").GetString());Assert.AreEqual("127.0.0.1",value.GetProperty("ip").GetString());Assert.AreEqual("",value.GetProperty("tenant").GetString());Assert.AreEqual("?keep=one&keep=two",value.GetProperty("query").GetString());Assert.AreEqual("actual-upload-body",value.GetProperty("content").GetString());
        Assert.IsFalse(response.Headers.Contains("x-store-token"));Assert.IsFalse(response.Headers.Contains("Authorization"));StringAssert.Contains(response.Headers.GetValues("Set-Cookie").Single(),"Secure; HttpOnly");
        using var range=new HttpRequestMessage(HttpMethod.Get,gateway.Urls.Single()+"/file");range.Headers.Range=new RangeHeaderValue(10,99);using var ranged=await client.SendAsync(range);Assert.AreEqual(HttpStatusCode.PartialContent,ranged.StatusCode);Assert.AreEqual(90,(await ranged.Content.ReadAsByteArrayAsync()).Length);Assert.AreEqual("bytes 10-99/65536",ranged.Content.Headers.ContentRange!.ToString());
    }
    [TestMethod]
    public async Task AdminForwardingStripsCommerceTokenAndSupportsWebSockets()
    {
        await using var upstream=App();upstream.UseWebSockets();upstream.Map("/socket",async context=>{
            Assert.IsFalse(context.Request.Headers.ContainsKey("x-store-token"));using var socket=await context.WebSockets.AcceptWebSocketAsync();var bytes=new byte[128];var read=await socket.ReceiveAsync(bytes,default);await socket.SendAsync(bytes.AsMemory(0,read.Count),WebSocketMessageType.Text,true,default);});
        await upstream.StartAsync();await using var gateway=Proxy(upstream.Urls.Single(),true);await gateway.StartAsync();using var client=new ClientWebSocket();client.Options.SetRequestHeader("x-store-token","forged");
        await client.ConnectAsync(new Uri(gateway.Urls.Single().Replace("http://","ws://")+"/socket?store_token=forged"),default);await client.SendAsync(Encoding.UTF8.GetBytes("tenant-websocket"),WebSocketMessageType.Text,true,default);var buffer=new byte[128];var response=await client.ReceiveAsync(buffer,default);Assert.AreEqual("tenant-websocket",Encoding.UTF8.GetString(buffer,0,response.Count));client.Abort();
    }
    private static WebApplication App(){var builder=WebApplication.CreateBuilder(new WebApplicationOptions{EnvironmentName="Production",Args=[]});builder.Logging.ClearProviders();builder.WebHost.UseUrls("http://127.0.0.1:0");return builder.Build();}
    private static WebApplication Proxy(string upstream,bool admin)
    {
        var builder=WebApplication.CreateBuilder(new WebApplicationOptions{EnvironmentName="Production",Args=[]});builder.Logging.ClearProviders();builder.WebHost.UseUrls("http://127.0.0.1:0");builder.Services.AddHttpForwarder();var app=builder.Build();var invoker=new HttpMessageInvoker(new SocketsHttpHandler{AllowAutoRedirect=false,UseProxy=false,UseCookies=false});app.Lifetime.ApplicationStopped.Register(invoker.Dispose);
        app.Run(async context=>{
            // The transport fixture models TLS termination; production GatewayApp requires real HTTPS or configured trusted proxy processing.
            context.Request.Scheme="https";
            var error=await app.Services.GetRequiredService<IHttpForwarder>().SendAsync(context,upstream,invoker,new ForwarderRequestConfig{ActivityTimeout=TimeSpan.FromSeconds(15)},new TenantTransformer(new(Guid.NewGuid().ToString("N"),"alpha-shop","store-alpha",admin),admin?null:"owned.payload.signature"));
            if(error!=ForwarderError.None&&!context.Response.HasStarted)context.Response.StatusCode=502;});return app;
    }
}
