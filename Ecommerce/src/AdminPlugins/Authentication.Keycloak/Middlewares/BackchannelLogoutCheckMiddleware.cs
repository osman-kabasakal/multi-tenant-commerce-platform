using Authentication.Keycloak.Infrastructure;
using Authentication.Keycloak.Models;
using Authentication.Keycloak.Services.AuthenticationServices;
using Authentication.Keycloak.Services.JwtValidationServices;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Data;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.SharedKernel;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Net.Http;
using System.Net.Http.Json;

namespace Authentication.Keycloak.Middlewares;

public class BackchannelLogoutCheckMiddleware
{
    private readonly RequestDelegate _next;
    private readonly HttpClient _httpClient;

    public BackchannelLogoutCheckMiddleware(RequestDelegate next, IHttpClientFactory httpClientFactory)
    {
        _next = next;
        _httpClient = httpClientFactory.CreateClient();
    }

    public async Task InvokeAsync(
        HttpContext context,
        IWorkContext workContext,
        ILogger<BackchannelLogoutCheckMiddleware> logger,
        IRepository<ExternalAuthentication> externalAuthenticationRepository,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        LogoutSessionManager logoutSessionManager,
        IUrlHelperFactory urlHelperFactory,
        LinkGenerator linkGenerator,
        IOptions<AuthConfiguration> optionsAuthConfiguration,
        ICacheBase cache)
    {
        if (context?.Request == null) return;

        // Only process authenticated users
        if (!(context.User?.Identity?.IsAuthenticated ?? false))
        {
            await _next(context);
            return;
        }

        try
        {
            var customer = workContext.CurrentCustomer;
            var externalAuthInfo = await externalAuthenticationRepository.GetOneAsync(x => x.CustomerId == customer.Id);
            
            if (externalAuthInfo == null)
            {
                // User doesn't have external authentication info, continue pipeline
                await _next(context);
                return;
            }

            // Handle logout requests separately
            if (ShouldRedirectToLogout(context, linkGenerator))
            {
                context.Response.Redirect(
                    linkGenerator.GetPathByRouteValues(context, "SuperAdminLogout"),
                    false
                );
                return;
            }

            // Validate token and session status
            if (!await ValidateUserSessionAsync(
                context,
                externalAuthInfo,
                keyCloakJwtValidationService,
                logoutSessionManager,
                cache,
                logger,
                linkGenerator))
            {
                return; // Validation failed, response has been handled
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Unexpected error in BackchannelLogoutCheckMiddleware");
            await SignoutAndRedirectAsync(context, linkGenerator);
            return;
        }

        await _next(context);
    }

    private bool ShouldRedirectToLogout(HttpContext context, LinkGenerator linkGenerator)
    {
        var requestUrl = context.Request.GetUri().GetLeftPart(UriPartial.Path);
        var logoutUrl = linkGenerator.GetPathByAction(context, controller: "Home", action: "Logout", values: new { area = "Admin" });
        return requestUrl.EndsWith(logoutUrl, StringComparison.InvariantCultureIgnoreCase);
    }

    private async Task<bool> ValidateUserSessionAsync(
        HttpContext context,
        ExternalAuthentication externalAuthInfo,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        LogoutSessionManager logoutSessionManager,
        ICacheBase cache,
        ILogger logger,
        LinkGenerator linkGenerator)
    {
        externalAuthInfo.OAuthAccessToken = await context.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,
            KeycloakAuthenticationDefaults.AccessTokenName);
        
        // Check if token exists
        if (string.IsNullOrEmpty(externalAuthInfo.OAuthAccessToken))
        {
            logger.LogWarning("User session invalid: Missing OAuth access token");
            await SignoutAndRedirectAsync(context, linkGenerator);
            return false;
        }

        try
        {
            // Validate JWT token
            var principal = await keyCloakJwtValidationService.ValidateJwt(externalAuthInfo.OAuthAccessToken, false);
            if (principal == null)
            {
                logger.LogCritical("Invalid JWT token for user {UserId} with provider {Provider}",
                    externalAuthInfo.CustomerId, externalAuthInfo.ProviderSystemName);
                throw new GrandException("Authentication validation failed");
            }

            // Check if session has been logged out
            var sub = principal.FindFirst("sub")?.Value;
            // Fix the typo in claim name - "sib" to "sid"
            var sid = principal.FindFirst("sid")?.Value;

            // Ensure both sub and sid are present before proceeding
            if (string.IsNullOrEmpty(sub) || string.IsNullOrEmpty(sid))
            {
                logger.LogWarning("Missing required claims (sub or sid) in JWT token");
                await SignoutAndRedirectAsync(context, linkGenerator);
                return false;
            }

            if (await logoutSessionManager.IsLoggedOutAsync(sub, sid))
            {
                logger.LogInformation("User session {SessionId} for user {UserId} has been logged out", sid, sub);
                await SignoutAndRedirectAsync(context, linkGenerator);
                await cache.RemoveAsync(sub + sid);
                return false;
            }

            return true;
        }
        catch (SecurityTokenExpiredException ex)
        {
            logger.LogInformation("JWT token expired. Attempting token refresh. Error: {Error}", ex.Message);
            // return await HandleTokenRefreshAsync(
            //     context,
            //     externalAuthInfo,
            //     keyCloakJwtValidationService,
            //     linkGenerator,
            //     logger,
            //     ex);
            await SignoutAndRedirectAsync(context, linkGenerator);
            return false;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error validating JWT token");
            await SignoutAndRedirectAsync(context, linkGenerator);
            return false;
        }
    }

    private async Task<bool> HandleTokenRefreshAsync(
        HttpContext context,
        ExternalAuthentication externalAuthInfo,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        LinkGenerator linkGenerator,
        ILogger logger,
        Exception originalException)
    {
        try
        {
            var workContext = context.RequestServices.GetRequiredService<IWorkContext>();
            var externalAuthRepo = context.RequestServices.GetRequiredService<IRepository<ExternalAuthentication>>();
            var authConfig = context.RequestServices.GetRequiredService<IOptions<AuthConfiguration>>().Value;

            // Get refresh token for current store
            var refreshToken =  await context.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,
                KeycloakAuthenticationDefaults.RefreshTokenName);

            if (string.IsNullOrEmpty(refreshToken))
            {
                logger.LogWarning("No refresh token available for user {UserId}", externalAuthInfo.CustomerId);
                await SignoutAndRedirectAsync(context, linkGenerator);
                return false;
            }

            var discoveryDocument = await keyCloakJwtValidationService.GetDiscoveryDocumentAsync();
            var newToken = await GetNewTokenAsync(
                discoveryDocument.TokenEndpoint,
                refreshToken,
                authConfig.ClientId,
                authConfig.ClientSecret);

            if (newToken == null)
            {
                logger.LogWarning("Token refresh failed for user {UserId}", externalAuthInfo.CustomerId);
                await SignoutAndRedirectAsync(context, linkGenerator);
                return false;
            }

            // Update the access token
            await externalAuthRepo.UpdateManyAsync(
                x => x.Id == externalAuthInfo.Id,
                UpdateBuilder<ExternalAuthentication>.Create()
                    .Set(x => x.OAuthAccessToken, newToken.AccessToken)
            );

            // Update the refresh token
            await externalAuthRepo.UpdateToSet(
                externalAuthInfo.Id,
                x => x.UserFields,
                x => x.Key == KeycloakAuthenticationDefaults.RefreshTokenName &&
                     x.StoreId == workContext.CurrentStore.Id,
                new UserField
                {
                    Key = KeycloakAuthenticationDefaults.RefreshTokenName,
                    Value = newToken.RefreshToken,
                    StoreId = workContext.CurrentStore.Id
                }
            );

            logger.LogInformation("Successfully refreshed token for user {UserId}", externalAuthInfo.CustomerId);
            return true;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to refresh token. Original error: {OriginalError}", originalException.Message);
            await SignoutAndRedirectAsync(context, linkGenerator);
            return false;
        }
    }

    private static async Task SignoutAndRedirectAsync(HttpContext context, LinkGenerator linkGenerator)
    {
        // Expanded check for potential redirect loops
        var isFromLogout = context.Request.Headers.Referer.Any(s =>
            (s ?? "").Contains("logout", StringComparison.InvariantCultureIgnoreCase) ||
            (s ?? "").StartsWith(linkGenerator.GetPathByRouteValues(context, "SuperAdminLogout") ?? ""));

        // Also check if we're already on a logout page
        var currentPath = context.Request.Path.ToString().ToLowerInvariant();
        var isLogoutPage = currentPath.Contains("logout");

        if (isFromLogout || isLogoutPage)
        {
            context.Response.StatusCode = 200;
            context.Response.ContentType = "text/html";
            await context.Response.WriteAsync(@"
<!DOCTYPE html>
<html>
<head>
    <title>Session Terminated</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; text-align: center; }
        .message-container { max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { display: inline-block; background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-top: 20px; }
    </style>
    <meta http-equiv='refresh' content='3;url=" + linkGenerator.GetPathByRouteValues(context, "AdminIndex") + @"'>
</head>
<body>
    <div class='message-container'>
        <h1>Session Terminated</h1>
        <p>Your session has been signed out. You will be redirected to the home page in 3 seconds.</p>
        <a href='" + linkGenerator.GetPathByRouteValues(context, "AdminIndex") + @"' class='btn'>Go to Home Page</a>
    </div>
</body>
</html>");
            await context.Response.CompleteAsync();
            return;
        }

        // Sign out from both authentication schemes
        await context.SignOutAsync(GrandCookieAuthenticationDefaults.AuthenticationScheme);
        await context.SignOutAsync(GrandCookieAuthenticationDefaults.ExternalAuthenticationScheme);

        // Redirect to admin index
        context.Response.Redirect(linkGenerator.GetPathByRouteValues(context, "AdminIndex"));
    }

    private async Task<RefreshTokenResponseModel?> GetNewTokenAsync(
        string tokenEndpoint, 
        string refreshToken,
        string clientId, 
        string clientSecret)
    {
        var requestContent = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("grant_type", "refresh_token"),
            new KeyValuePair<string, string>("refresh_token", refreshToken),
            new KeyValuePair<string, string>("client_id", clientId),
            new KeyValuePair<string, string>("client_secret", clientSecret)
        });

        var response = await _httpClient.PostAsync(tokenEndpoint, requestContent);
        
        return response.IsSuccessStatusCode 
            ? await response.Content.ReadFromJsonAsync<RefreshTokenResponseModel>() 
            : null;
    }
}
