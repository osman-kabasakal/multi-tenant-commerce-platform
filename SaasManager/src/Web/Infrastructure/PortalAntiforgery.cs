using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Http;

namespace SaasManager.Web.Infrastructure;

public static class PortalAntiforgery
{
    public const string RequestTokenName="X-XSRF-TOKEN";
    public static void Configure(AntiforgeryOptions options,bool local)
    {
        options.HeaderName=RequestTokenName;
        options.Cookie=new CookieBuilder {
            Name="platform-antiforgery",HttpOnly=true,
            SecurePolicy=local?CookieSecurePolicy.SameAsRequest:CookieSecurePolicy.Always
        };
    }
    public static void Issue(HttpContext http,IAntiforgery antiforgery)
    {
        var tokens=antiforgery.GetAndStoreTokens(http);
        // Angular reads only the request token; the separate private cookie stays HttpOnly.
        http.Response.Cookies.Append(RequestTokenName,tokens.RequestToken!,new CookieOptions {
            HttpOnly=false,Secure=http.Request.IsHttps,SameSite=SameSiteMode.Strict,Path="/"
        });
    }
}
