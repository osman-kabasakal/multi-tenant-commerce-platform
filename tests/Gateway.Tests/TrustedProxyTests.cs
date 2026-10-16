using System.Net;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Hosting;

namespace Gateway.Tests;

[TestClass]
public sealed class TrustedProxyTests
{
    [DataTestMethod]
    [DataRow("10.0.0.9",true)][DataRow("10.0.1.9",false)]
    public async Task OnlyConfiguredPeersCanChangeClientAddressAndPublicScheme(string peer,bool trusted)
    {
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{["Proxy:Enabled"]="true",["Proxy:KnownNetworks:0"]="10.0.0.0/24"}).Build();
        var services=new ServiceCollection();services.AddLogging();services.AddTrustedProxy(config);using var provider=services.BuildServiceProvider();
        var app=new ApplicationBuilder(provider);app.UseTrustedProxy(config);app.Run(context=>Task.CompletedTask);
        var context=new DefaultHttpContext{RequestServices=provider};context.Connection.RemoteIpAddress=IPAddress.Parse(peer);context.Request.Scheme="http";context.Request.Host=new HostString("alpha-shop.shops.example.test");
        context.Request.Headers["X-Forwarded-For"]="203.0.113.42";context.Request.Headers["X-Forwarded-Proto"]="https";context.Request.Headers["X-Forwarded-Host"]="attacker.test";
        await app.Build()(context);Assert.AreEqual(trusted?"https":"http",context.Request.Scheme);Assert.AreEqual(trusted?"203.0.113.42":peer,context.Connection.RemoteIpAddress!.ToString());Assert.AreEqual("alpha-shop.shops.example.test",context.Request.Host.Value);
    }
    [TestMethod]
    public async Task RepeatedPipelineRegistrationCannotConsumeBeyondTheConfiguredForwardLimit()
    {
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{["Proxy:Enabled"]="true",["Proxy:KnownNetworks:0"]="10.0.0.0/24",["Proxy:ForwardLimit"]="1"}).Build();
        var services=new ServiceCollection();services.AddLogging();services.AddTrustedProxy(config);using var provider=services.BuildServiceProvider();var app=new ApplicationBuilder(provider);app.UseTrustedProxy(config);app.UseTrustedProxy(config);app.Run(_=>Task.CompletedTask);
        var context=new DefaultHttpContext{RequestServices=provider};context.Connection.RemoteIpAddress=IPAddress.Parse("10.0.0.9");context.Request.Scheme="http";context.Request.Headers["X-Forwarded-For"]="203.0.113.42, 10.0.0.8";context.Request.Headers["X-Forwarded-Proto"]="https, https";
        await app.Build()(context);Assert.AreEqual("10.0.0.8",context.Connection.RemoteIpAddress!.ToString());Assert.AreEqual("203.0.113.42",context.Request.Headers["X-Forwarded-For"].ToString());
    }
    [DataTestMethod]
    [DataRow("Proxy:KnownNetworks:0","0.0.0.0/0")][DataRow("Proxy:KnownNetworks:0","::/0")][DataRow("Proxy:KnownProxies:0","proxy.example.test")][DataRow("Proxy:ForwardLimit","0")]
    public void UnboundedOrImplicitProxyTrustIsRefused(string name,string value)
    {var values=new Dictionary<string,string?>{["Proxy:Enabled"]="true",[name]=value};var config=new ConfigurationBuilder().AddInMemoryCollection(values).Build();Assert.ThrowsException<InvalidOperationException>(()=>new ServiceCollection().AddTrustedProxy(config));}
}
