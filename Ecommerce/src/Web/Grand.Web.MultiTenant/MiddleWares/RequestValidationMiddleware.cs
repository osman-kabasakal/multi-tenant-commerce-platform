using Platform.Security;
using Grand.Web.ExternalSettings.Extensions;
using Grand.Web.ExternalSettings.TenantToken;
using Grand.Web.MultiTenant.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Net;

namespace Grand.Web.MultiTenant.MiddleWares;

public class RequestValidationMiddleware
{
    private readonly RequestDelegate _next;

    public RequestValidationMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context,
        IKeycloakClientTokenValidation clientTokenValidation,
        ITenantEncryptionService encryptionService,
        PublicRouteService publicRouteService
        )
    {
        var path = context.Request.Path.Value?.ToLower();
        var token = string.Empty;
        if (path!=null && (path.StartsWith("/.well-known/apple-app-site-association") ||
                           path.StartsWith("/.well-known/assetlinks.json") ||
                           publicRouteService.IsPublicPath(path))
            )
        {
            await _next(context);
            return;
        }

        if (context.Request.Query.TryGetValue("store_token", out var storeToken))
        {
            var tokenHandler = context.RequestServices.GetRequiredService<ITenantTokenHandler>();
            token = await tokenHandler.ValidateAndGetTenant(WebUtility.UrlDecode(storeToken));
            if (token == null)
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "store_token query parameter is not valid" });
                return;
            }
        }

        if (string.IsNullOrEmpty(token))
        {
            // 1. x-store-token kontrolü
            if (!context.Request.Headers.TryGetValue("x-store-token", out var headerToken))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is required" });
                return;
            }

            token = headerToken.ToString();
        }


        // 2. Accept header kontrolü
        // var acceptHeader = context.Request.Headers.Accept.ToString();
        // if (!acceptHeader.Contains(MediaTypeNames.Application.Json))
        // {
        //     context.Response.StatusCode = StatusCodes.Status400BadRequest;
        //     await context.Response.WriteAsJsonAsync(new { error = "Only JSON content type is accepted" });
        //     return;
        // }

        // 3. Admin area kontrolü
        if (path != null && path.Contains("/admin"))
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsJsonAsync(new { error = "Admin area access is not allowed" });
            return;
        }

        try
        {
            var custom = await TenantStoreHosts.CustomAsync(context);
            var requestSubDomain = custom?.Slug ?? context.Request.Host.Host.Split('.')[0];
            var clientPrinciple = await clientTokenValidation.ValidateJwt(token, requestSubDomain, true);
            var subDomainClaim = clientPrinciple?.FindFirst("sub_domainname")?.Value;
            if (clientPrinciple == null || string.IsNullOrEmpty(subDomainClaim) || !subDomainClaim.Equals(requestSubDomain, StringComparison.OrdinalIgnoreCase))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is not valid for this request" });
                return;
            }
            var storeIdClaims = clientPrinciple.FindFirst("store_id")?.Value ?? throw new InvalidOperationException("Missing encrypted store claim.");
            var storeId = await encryptionService.DecryptAsync(storeIdClaims, subDomainClaim);
            if (custom != null && storeId != custom.StoreId)
                throw new InvalidOperationException("The tenant token does not match the custom storefront.");
            context.Items["StoreId"] = storeId;
            var mongoConnectionClaim = clientPrinciple.FindFirst("db_connection")?.Value ?? throw new InvalidOperationException("Missing encrypted database claim.");
            var mongoConnection = await encryptionService.DecryptAsync(mongoConnectionClaim, subDomainClaim);
            context.Items["StoreMongoConnectionString"] = mongoConnection;
        }
        catch (Exception)
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsJsonAsync(new { error = "x-store-token header is not valid for this request" });
            return;
        }

        await _next(context);
    }
}