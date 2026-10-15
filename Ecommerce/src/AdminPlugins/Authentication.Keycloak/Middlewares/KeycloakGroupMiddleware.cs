using Platform.Security;
using Authentication.Keycloak.Services.JwtValidationServices;
using Authentication.Keycloak.Services.RemoteUserManagement;
using Grand.Business.Core.Events.Customers;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Data;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Authentication.Keycloak.Middlewares;

public class KeycloakGroupMiddleware
{
    private readonly RequestDelegate _next;

    public KeycloakGroupMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(
        HttpContext _,
        IHttpContextAccessor contextAccessor,
        ILogger<KeycloakGroupMiddleware> logger,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        IKeycloakUserService keycloakUserService,
        LinkGenerator linkGenerator,
        KeycloakSettings keycloakSettings,
        ITenantEncryptionService encryptionService)
    {
        var context = contextAccessor.HttpContext;
        if (context == null)
        {
            return;
        }

        var path = context.Request.Path.Value?.ToLower();
        var token = await context.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,
            KeycloakAuthenticationDefaults.AccessTokenName);

        try
        {
            if (!string.IsNullOrEmpty(token))
            {
                if (await HandleUserTokenAsync(context, token, keyCloakJwtValidationService, keycloakUserService))
                {
                    
                    await _next(context);
                    return;
                }
                else
                {
                    await LogoutFromKeycloak(keyCloakJwtValidationService, keycloakSettings, token, context);
                }
            }
            else if (context.Request.Headers.TryGetValue("x-store-token", out var storeToken))
            {
                if (await HandleStoreTokenAsync(context, storeToken.ToString(), keyCloakJwtValidationService, encryptionService))
                {
                    await _next(context);
                    return;
                }
                else
                {
                    await LogoutFromKeycloak(keyCloakJwtValidationService, keycloakSettings, token, context);
                }
            }
            else if (path != null && path.StartsWith("/odata"))
            {
                LogUnauthorizedRequest(logger, path, context, "x-store-token header is required");
                await RespondWithUnauthorized(context, "x-store-token header is required");
                return;
            }

            if (ShouldRedirectToLogin(path))
            {
                LogUnauthorizedRequest(logger, path, context, "Redirecting to login");
                await RedirectToLogin(context, path, linkGenerator,keyCloakJwtValidationService,keycloakSettings);
                return;
            }

            await _next(context);
        }
        catch (Exception e)
        {
            if (!IsStaticFileRequest(path))
            {
                LogError(logger, e, path, context);
                RedirectToLogout(context, linkGenerator);
            }
            
        }
    }

    private static async Task LogoutFromKeycloak(KeyCloakJwtValidationService keyCloakJwtValidationService,
        KeycloakSettings keycloakSettings, string token, HttpContext context)
    {
        try
        {
            var principal = await keyCloakJwtValidationService.ValidateJwt(token, false);
            if (principal != null)
            {
                var keycloakId = principal.FindFirst("sub")?.Value;
                var keycloakSid = principal.FindFirst("sid")?.Value;
                if (!string.IsNullOrEmpty(keycloakId) && !string.IsNullOrEmpty(keycloakSid))
                {
                    await context.RequestServices.GetRequiredService<IKeycloakService>().GetKeycloakClientAsync()
                        .DeleteUserSessionAsync(keycloakSettings.Realm, keycloakSid);
                }
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
        }
    }

    private async Task<bool> HandleUserTokenAsync(
        HttpContext context, 
        string token,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        IKeycloakUserService keycloakUserService)
    {
        var principal = await keyCloakJwtValidationService.ValidateJwt(token,false);
        if (principal == null) return false;

        var groupClaim = principal.FindFirst("group");
        if (groupClaim == null) return false;

        var groupDetail = await keycloakUserService.GetGroupByPathAsync($"{groupClaim.Value}");
        if (groupDetail?.Attributes == null) return false;

        foreach (var attribute in groupDetail.Attributes)
        {
            context.Items.Add(attribute.Key, attribute.Value.First());
        }
        // var authenticateResult = await context.AuthenticateAsync(KeycloakAuthenticationDefaults.AuthenticationScheme);
        // if (!authenticateResult.Succeeded || !authenticateResult.Principal.Claims.Any())
        // {
        //     return false;
        // }
        // var path = context.Request.Path.Value?.ToLower();
        
        // if(!(context.User?.Identity?.IsAuthenticated ?? false) && ShouldRedirectToLogin(path) && !IsStaticFileRequest(path))
        // {   
        //     
        //     var email = authenticateResult.Principal.FindFirst(claim => claim.Type == JwtRegisteredClaimNames.Email)?.Value;
        //     var identifier = authenticateResult.Principal.FindFirst(claim => claim.Type == JwtRegisteredClaimNames.Sub)?.Value;
        //
        //     // Validate required claims
        //     if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(identifier))
        //     {
        //         return false;
        //     }
        //     
        //     var authenticationParameters = new ExternalAuthParam {
        //         ProviderSystemName = KeycloakAuthenticationDefaults.ProviderSystemName,
        //         AccessToken = token, // Reuse the token we already validated
        //         Email = email,
        //         Identifier = identifier,
        //         Name = authenticateResult.Principal.FindFirst(claim => claim.Type == "name")?.Value,
        //         Claims = authenticateResult.Principal.Claims.ToList()
        //     };
        //     var _groupService = context.RequestServices.GetRequiredService<IGroupService>();
        //     var _externalAuthenticationService =
        //         context.RequestServices.GetRequiredService<IExternalAuthenticationService>();
        //     var associatedUser = await _externalAuthenticationService.GetCustomer(authenticationParameters); 
        //     var refreshToken = await context.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme, KeycloakAuthenticationDefaults.RefreshTokenName);
        //     // var _workContext = context.RequestServices.GetRequiredService<IWorkContextSetter>();
        //     // await _workContext.SetCurrentCustomer(associatedUser);
        //     await SetExternalAuthenticationUserField(context,authenticationParameters,refreshToken!,associatedUser);
        //     await LoginUser(context, associatedUser);
        // }
        

        return true;
    }
    
    private bool IsStaticFileRequest(PathString path)
    {
        // Statik dosya uzantıları
        string[] staticFileExtensions = new[] 
        { 
            ".css", ".map", ".js",".png", ".jpg", ".jpeg", 
            ".gif", ".svg", ".ico", ".webp"
        };

        // Path'in uzantısını al
        string fileExtension = Path.GetExtension(path.Value);

        // Uzantı statik dosya uzantıları listesinde mi?
        return staticFileExtensions.Contains(fileExtension);
    }
    
    private async Task LoginUser(HttpContext context,Customer user)
    {
        // var _mediator = context.RequestServices.GetRequiredService<IMediator>();
        //raise event       
        // await _mediator.Publish(new CustomerLoggedInEvent(user));
        
        var _authenticationService = context.RequestServices.GetRequiredService<IGrandAuthenticationService>();

        //authenticate
        await _authenticationService.SignIn(user, false);
    }
    
    private async Task SetExternalAuthenticationUserField(
        HttpContext context,
        ExternalAuthParam parameters, string refreshToken,
        Customer associatedUser)
    {
        var _externalAuthenticationRepository =
            context.RequestServices.GetRequiredService<IRepository<ExternalAuthentication>>();
        // var _workContext = context.RequestServices.GetRequiredService<IWorkContext>();
        if(!context.Items.TryGetValue("StoreId", out var storeId) || storeId == null)
        {
            return;
        }
        var externalRecordById= await _externalAuthenticationRepository.GetOneAsync(x => x.CustomerId == associatedUser.Id);
        externalRecordById.OAuthAccessToken = parameters.AccessToken;
        await _externalAuthenticationRepository.UpdateField(externalRecordById.Id, x => x.OAuthAccessToken,
            parameters.AccessToken);
        if (externalRecordById.UserFields.Any(x=>x.Key==KeycloakAuthenticationDefaults.RefreshTokenName && storeId!.ToString()==x.StoreId))
        {
            await _externalAuthenticationRepository.UpdateToSet(externalRecordById.Id,
                x => x.UserFields,
                x => x.Key == KeycloakAuthenticationDefaults.RefreshTokenName &&
                     storeId.ToString() == x.StoreId,
                new UserField() {
                    Key = KeycloakAuthenticationDefaults.RefreshTokenName,
                    Value = refreshToken,
                    StoreId = storeId.ToString()
                });
            
        }
        else
        {
            await _externalAuthenticationRepository.AddToSet(externalRecordById.Id,
                x => x.UserFields,
                new UserField() {
                    Key = KeycloakAuthenticationDefaults.RefreshTokenName,
                    Value = refreshToken,
                    StoreId =storeId.ToString()
                });
        }
    }

    private async Task<bool> HandleStoreTokenAsync(
        HttpContext context, 
        string storeToken,
        KeyCloakJwtValidationService keyCloakJwtValidationService,
        ITenantEncryptionService encryptionService)
    {
        var clientPrinciple = await keyCloakJwtValidationService.ValidateJwt(storeToken, true);
        if (clientPrinciple == null) return false;

        var storeIdClaims = clientPrinciple.FindFirst("store_id")?.Value;
        var subDomainClaims = clientPrinciple.FindFirst("sub_domainname")?.Value;

        if (string.IsNullOrEmpty(storeIdClaims) || string.IsNullOrEmpty(subDomainClaims)) 
            return false;

        var storeId = await encryptionService.DecryptAsync(storeIdClaims, subDomainClaims);
        if (storeId == null) return false;
        
        context.Items["StoreId"] = storeId;
        
        var mongoConnectionClaim = clientPrinciple.FindFirst("db_connection")?.Value;
        if (!string.IsNullOrEmpty(mongoConnectionClaim)) 
        {
            var mongoConnection = await encryptionService.DecryptAsync(mongoConnectionClaim, subDomainClaims);
            context.Items["StoreMongoConnectionString"] = mongoConnection;
        }
        
        return true;
    }

    private bool ShouldRedirectToLogin(string path)
    {
        if (string.IsNullOrEmpty(path)) return false;

        return !path.StartsWith("/super-admin") &&
               !path.Contains("Logout", StringComparison.InvariantCultureIgnoreCase) &&
               !path.StartsWith("/signin-oidc") && !IsStaticFileRequest(path);
    }

    private async Task RedirectToLogin(HttpContext context, string path, LinkGenerator linkGenerator,
        KeyCloakJwtValidationService keyCloakJwtValidationService, KeycloakSettings keycloakSettings)
    {
        var token = await context.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,
            KeycloakAuthenticationDefaults.AccessTokenName);

        // Check if we're coming from the login page to avoid redirect loops
        var isFromLogin = context.Request.Headers.Referer.Any(s =>
            (s ?? "").Contains("/login", StringComparison.InvariantCultureIgnoreCase) ||
            (s ?? "").Contains("signin-oidc", StringComparison.InvariantCultureIgnoreCase));

        // If we detect a potential redirect loop, display error page instead of redirecting back to login
        if (isFromLogin)
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            context.Response.ContentType = "text/html";
            await context.Response.WriteAsync(@"
<!DOCTYPE html>
<html>
<head>
    <title>Authentication Error</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; text-align: center; }
        .error-container { max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { display: inline-block; background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class='error-container'>
        <h1>Authentication Error</h1>
        <p>There was a problem authenticating your session. This might be due to:</p>
        <ul style='text-align: left;'>
            <li>Your user account may not have the correct permissions</li>
            <li>Your session may have expired</li>
            <li>There may be a configuration issue with your tenant</li>
        </ul>
        <p>Please try signing out and signing in again.</p>
        <a href='" + linkGenerator.GetPathByRouteValues(context, "SuperAdminLogout") + @"' class='btn'>Sign Out</a>
    </div>
</body>
</html>");
            return;
        }

        // Only attempt to remove user sessions if we have a valid token
        // if (!string.IsNullOrEmpty(token))
        // {
        //     try
        //     {
        //         var principal = await keyCloakJwtValidationService.ValidateJwt(token, false);
        //         if (principal != null)
        //         {
        //             var keycloakId = principal.FindFirst("sub")?.Value;
        //             if (!string.IsNullOrEmpty(keycloakId))
        //             {
        //                 await context.RequestServices.GetRequiredService<IKeycloakService>().GetKeycloakClientAsync()
        //                     .RemoveUserSessionsAsync(keycloakSettings.Realm, keycloakId);
        //             }
        //         }
        //     }
        //     catch (Exception e)
        //     {
        //         Console.WriteLine(e);
        //     }
        // }

        var redirectAction = linkGenerator.GetPathByRouteValues(
            context, "SuperAdminLogin", new { returnUrl = path });

        context.Response.Redirect(redirectAction, permanent: false);
    }

    private void RedirectToLogout(HttpContext context, LinkGenerator linkGenerator)
    {
        context.Response.Redirect(
            linkGenerator.GetPathByRouteValues(context, "SuperAdminLogout"),
            false
        );
    }

    private async Task RespondWithUnauthorized(HttpContext context, string errorMessage)
    {
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { error = errorMessage });
    }

    private void LogUnauthorizedRequest(ILogger logger, string path, HttpContext context, string message)
    {
        logger.LogWarning("Authentication request rejected: {Reason}; trace: {TraceId}", message, context.TraceIdentifier);
    }

    private void LogError(ILogger logger, Exception e, string path, HttpContext context)
    {
        logger.LogError("Authentication failure: {ExceptionType}; trace: {TraceId}", e.GetType().Name, context.TraceIdentifier);
    }
}
