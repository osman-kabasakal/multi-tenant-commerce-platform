using System.Security.Claims;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Net.Http.Headers;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Web.Infrastructure;

namespace Portable.Services.Tests;

[TestClass]
public sealed class PortalAntiforgeryTests
{
    [TestMethod]
    public async Task AngularRequestTokenAndPrivateCookieValidateTogether()
    {
        using var services=Services();var antiforgery=services.GetRequiredService<IAntiforgery>();
        var issued=Context(services,"owner");PortalAntiforgery.Issue(issued,antiforgery);
        var cookies=SetCookieHeaderValue.ParseList(issued.Response.Headers.SetCookie.Select(value=>value!).ToArray());
        var secret=cookies.Single(c=>c.Name=="platform-antiforgery");
        var token=cookies.Single(c=>c.Name==PortalAntiforgery.RequestTokenName);
        Assert.IsTrue(secret.HttpOnly&&secret.Secure);Assert.IsFalse(token.HttpOnly);Assert.IsTrue(token.Secure);
        Assert.AreNotEqual(secret.Value.ToString(),token.Value.ToString());
        var request=Context(services,"owner");request.Request.Headers.Cookie=secret.Name+"="+secret.Value;
        request.Request.Headers[PortalAntiforgery.RequestTokenName]=token.Value.ToString();
        await antiforgery.ValidateRequestAsync(request);
    }

    [DataTestMethod]
    [DataRow("missing")]
    [DataRow("old-header")]
    [DataRow("cookie-as-header")]
    [DataRow("other-user")]
    public async Task InvalidUploadTokensAreRejected(string scenario)
    {
        using var services=Services();var antiforgery=services.GetRequiredService<IAntiforgery>();
        var issued=Context(services,"owner");PortalAntiforgery.Issue(issued,antiforgery);
        var cookies=SetCookieHeaderValue.ParseList(issued.Response.Headers.SetCookie.Select(value=>value!).ToArray());
        var secret=cookies.Single(c=>c.Name=="platform-antiforgery");var token=cookies.Single(c=>c.Name==PortalAntiforgery.RequestTokenName);
        var request=Context(services,scenario=="other-user"?"different-owner":"owner");
        request.Request.Headers.Cookie=secret.Name+"="+secret.Value;
        if(scenario!="missing") request.Request.Headers[scenario=="old-header"?"RequestVerificationToken":PortalAntiforgery.RequestTokenName]=(scenario=="cookie-as-header"?secret:token).Value.ToString();
        await Assert.ThrowsExceptionAsync<AntiforgeryValidationException>(()=>antiforgery.ValidateRequestAsync(request));
    }

    private static ServiceProvider Services()
    {
        var services=new ServiceCollection();services.AddLogging();services.AddDataProtection().UseEphemeralDataProtectionProvider();
        services.AddAntiforgery(options=>PortalAntiforgery.Configure(options,false));return services.BuildServiceProvider();
    }
    private static DefaultHttpContext Context(IServiceProvider services,string subject)
    {
        var http=new DefaultHttpContext {RequestServices=services,User=new ClaimsPrincipal(new ClaimsIdentity(new[]{new Claim(ClaimTypes.NameIdentifier,subject)},"test"))};
        http.Request.Scheme="https";http.Request.Method="POST";return http;
    }
}
