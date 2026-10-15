using SaasManager.Application.Common.Models.IdentityManagement;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Core.Models.Configs;
using Core.Models.Responses;
using Core.Utilities;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Keycloak;
using SaasManager.Application.Common.Models.Authantication;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Domain.Enums;

namespace SaasManager.Web.Endpoints;

public class AuthEnpoints : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var groupApp = app.MapGroup(this, "Auth")
            .AllowAnonymous()
            .MapGet(Login, "login");
        // .MapGet(GetSessionInfo,"sessionInfo");

        groupApp.MapGet("sessionInfo", GetSessionInfo)
            .RequireAuthorization();

        groupApp.MapGet("logout", Logout)
            .RequireAuthorization();

        groupApp.MapGet("refresh", RefreshToken)
            .RequireAuthorization();
    }

    public Task<Results<ChallengeHttpResult, RedirectHttpResult>> Login(
        LinkGenerator linkGenerator,
        IHttpContextAccessor contextAccessor,
        IKeycloakService keycloakService,
        [FromQuery] string returnUrl = "/")
    {
        if (contextAccessor.HttpContext!.User.Identity?.IsAuthenticated == true)
        {
            return Task.FromResult<Results<ChallengeHttpResult, RedirectHttpResult>>(TypedResults.Redirect(returnUrl));
        }

        var internalRedirectUrl = linkGenerator.GetPathByAction(contextAccessor.HttpContext, "Callback", "RemoteAuth",
            new { returnUrl = returnUrl });

        return Task.FromResult<Results<ChallengeHttpResult, RedirectHttpResult>>(
            TypedResults.Challenge(new AuthenticationProperties
                {
                    RedirectUri = returnUrl,
                    // IsPersistent = true,
                    // AllowRefresh = true,
                    // ExpiresUtc = DateTimeOffset.UtcNow.AddHours(24),
                    // Items =
                    // {
                    //     { "returnUrl", returnUrl },
                    //     { "scheme", OpenIdConnectDefaults.AuthenticationScheme }
                    // }
                },
                [OpenIdConnectDefaults.AuthenticationScheme]));
    }


    public async Task<Results<Ok<ServiceResponse<SessionInfoResponseModel>>, UnauthorizedHttpResult>> GetSessionInfo(
        ISender sender,
        IHttpContextAccessor contextAccessor,
        IKeycloakService keycloakService,
        IWorkContext workContext,
        IApplicationDbContext dbContext
    )
    {
        if (!(contextAccessor.HttpContext!.User.Identity?.IsAuthenticated ?? false))
        {
            return await Task
                .FromResult<Results<Ok<ServiceResponse<SessionInfoResponseModel>>, UnauthorizedHttpResult>>(
                    TypedResults.Unauthorized());
        }

        var user = contextAccessor.HttpContext!.User;
        var config=contextAccessor.HttpContext.RequestServices.GetRequiredService<IConfiguration>();
        var localTrial=config.GetValue<bool>("LocalDemo:Enabled") && config.GetValue<bool>("LocalDemo:SelfService");
        // Local trials use the explicit enrollment flow, without invoking the paid registration pipeline.
        var registrationStep = localTrial
            ? ServiceResponse<RegistrationStepResponse>.Success(new RegistrationStepResponse {
                IsCompleted=workContext.GuestRegistration?.ConvertedBusinessId.HasValue==true,
                ValidationUrl="/local-onboarding.html"
            })
            : await sender.Send(new RegistrationCommand());
        var business =
            await dbContext.Businesses.FirstOrDefaultAsync(x =>
                x.Id == workContext.GuestRegistration!.ConvertedBusinessId);
        return await Task.FromResult<Results<Ok<ServiceResponse<SessionInfoResponseModel>>, UnauthorizedHttpResult>>(
            TypedResults.Ok(ServiceResponse<SessionInfoResponseModel>.Success(new SessionInfoResponseModel
            {
                User = new UserInfo
                {
                    Id = workContext.GuestId!.Value.ToString(),
                    Email = workContext.UserEmail!,
                    Name = workContext.GuestRegistration!.Fullname,
                    BusinessId = workContext.GuestRegistration.ConvertedBusinessId?.ToString(),
                    Type = UserType.BusinessOwner.ToDisplayString(),
                    IsSetupCompleted = business != null && (business.Status==BusinessStatus.Active || business.Status==BusinessStatus.Trial)
                },
                Roles = user.Claims
                    .Where(c => c.Type == "roles")
                    .Select(c => c.Value).ToList(),
                BusinessId = workContext.GuestRegistration.ConvertedBusinessId?.ToString(),
                RegistrationStep = registrationStep.Data
            })));
    }


    public async Task<SignOutHttpResult> Logout(IHttpContextAccessor contextAccessor,
        IKeycloakService keycloakService, IOptions<AuthConfiguration> configuration)
    {
        var accessToken = await contextAccessor.HttpContext!.GetTokenAsync(CookieAuthenticationDefaults.AuthenticationScheme,"access_token");
        var tokenValidation = await keycloakService.ValidateTokenAsync(accessToken!);
        var idToken =
            await contextAccessor.HttpContext!.GetTokenAsync(CookieAuthenticationDefaults.AuthenticationScheme,
                "id_token");
        var authResponse = await contextAccessor.HttpContext!.AuthenticateAsync();
        var tokens=authResponse.Properties!.GetTokens();
        authResponse.Properties!.Items.Add("id_token_hint", idToken);
        var logoutUrl = $"{configuration.Value.IdentityProviderUrl}/protocol/openid-connect/logout";
        return TypedResults.SignOut(authResponse.Properties,
            [OpenIdConnectDefaults.AuthenticationScheme, CookieAuthenticationDefaults.AuthenticationScheme]);
    }


    public async Task<Results<UnauthorizedHttpResult, Ok<ServiceResponse<RefreshTokenResponseModel>>>> RefreshToken(
        IHttpContextAccessor contextAccessor, IKeycloakService keycloakService)
    {
        if (contextAccessor.HttpContext != null)
        {
            var refreshToken = await contextAccessor.HttpContext.GetTokenAsync("refresh_token");
            if (string.IsNullOrEmpty(refreshToken))
            {
                return TypedResults.Unauthorized();
            }

            try
            {
                var tokens = await keycloakService.RefreshTokenAsync(refreshToken);

                var authInfo = await contextAccessor.HttpContext.AuthenticateAsync();
                var properties = authInfo.Properties;
                var tokenList = properties!.GetTokens().ToList();

                tokenList.RemoveAll(t => t.Name == "access_token" || t.Name == "refresh_token");
                tokenList.Add(new AuthenticationToken { Name = "access_token", Value = tokens.AccessToken });
                tokenList.Add(new AuthenticationToken { Name = "refresh_token", Value = tokens.RefreshToken });

                properties!.StoreTokens(tokenList);
                await contextAccessor.HttpContext.SignInAsync(authInfo.Principal!, properties);
                return TypedResults.Ok(ServiceResponse<RefreshTokenResponseModel>.Success(
                    new RefreshTokenResponseModel
                    {
                        RefreshToken = tokens.RefreshToken,
                        ExpiresIn = tokens.ExpiresIn,
                        RefreshExpiresIn = 0,
                        AccessToken = tokens.AccessToken!,
                    }));
            }
            catch
            {
                return TypedResults.Unauthorized();
            }
        }

        return TypedResults.Unauthorized();
    }
}
