using Authentication.Keycloak.Infrastructure;
using Authentication.Keycloak.Models;
using Authentication.Keycloak.Services.AuthenticationServices;
using Authentication.Keycloak.Services.JwtValidationServices;
using Authentication.Keycloak.Services.RemoteUserManagement;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Business.Core.Utilities.Authentication;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Customers;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using MongoDB.Driver;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Security.Claims;
using System.Text.Json;

namespace Authentication.Keycloak.Areas.Admin.Controllers;

[Area("Admin")]
public class KeycloakAuthenticationController: BaseController
{
    private readonly IExternalAuthenticationService _externalAuthenticationService;
    private readonly IConfiguration _configuration;
    private readonly LogoutSessionManager _logoutSessions;
    private readonly IOptions<AuthConfiguration> _optionsAuthConfiguration;
    private readonly IOptions<OpenIdConnectOptions> _openIdConnectOptions;
    private readonly ILogger<KeycloakAuthenticationController> _logger;
    private readonly IAuthenticationHandlerProvider _authenticationHandlerProvider;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IGrandAuthenticationService _grandAuthenticationService;
    private readonly OpnIdConnectGrandAuthenticationService _openIdConnectGrandAuthenticationService;
    private readonly KeyCloakJwtValidationService _jwtValidationService;
    private readonly IUrlHelper _urlHelper;
    private readonly IRepository<ExternalAuthentication> _externalAuthenticationRepository;
    private readonly IKeycloakUserService _keycloakUserService;
    private readonly HttpClient _httpClient;

    public KeycloakAuthenticationController(
        IExternalAuthenticationService externalAuthenticationService,
        IConfiguration configuration,
        LogoutSessionManager logoutSessions,
        IOptions<AuthConfiguration> optionsAuthConfiguration,
        IOptions<OpenIdConnectOptions> openIdConnectOptions,
        ILogger<KeycloakAuthenticationController> logger,
        IAuthenticationHandlerProvider authenticationHandlerProvider,
        IHttpClientFactory httpClientFactory,
        IGrandAuthenticationService grandAuthenticationService,
        OpnIdConnectGrandAuthenticationService openIdConnectGrandAuthenticationService,
        KeyCloakJwtValidationService jwtValidationService,
        IUrlHelperFactory urlHelperFactory,
        IActionContextAccessor actionContextAccessor,
        IRepository<ExternalAuthentication> externalAuthenticationRepository,
        IKeycloakUserService keycloakUserService
        )
    {
        _externalAuthenticationService = externalAuthenticationService;
        _configuration = configuration;
        _logoutSessions = logoutSessions;
        _optionsAuthConfiguration = optionsAuthConfiguration;
        _openIdConnectOptions = openIdConnectOptions;
        _logger = logger;
        _authenticationHandlerProvider = authenticationHandlerProvider;
        _httpClientFactory = httpClientFactory;
        _grandAuthenticationService = grandAuthenticationService;
        _openIdConnectGrandAuthenticationService = openIdConnectGrandAuthenticationService;
        _jwtValidationService = jwtValidationService;
        _urlHelper = urlHelperFactory.GetUrlHelper(actionContextAccessor.ActionContext);
        _externalAuthenticationRepository = externalAuthenticationRepository;
        _keycloakUserService = keycloakUserService;
        _httpClient = httpClientFactory.CreateClient();
    }
    
    public IActionResult KeycloakLogin(string returnUrl)
    {
        if (string.IsNullOrEmpty(returnUrl) || !returnUrl.Contains("admin", StringComparison.InvariantCultureIgnoreCase))
        {
            returnUrl = Url.RouteUrl("AdminIndex");
        }
        var authenticationProperties = new AuthenticationProperties {
            RedirectUri = Url.RouteUrl("AzCallbackPath", new {returnurl=returnUrl}) 
            // Url.Action("KeycloakAuthentication", "KeycloakLoginCallback", new { returnurl=returnUrl,area="Admin" })
        };

        return Challenge(authenticationProperties, KeycloakAuthenticationDefaults.AuthenticationScheme);
    }   

    public async Task<IActionResult> KeycloakLoginCallback(string returnurl)
    {
        try
        {
            var accessToken =
                await HttpContext.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme, KeycloakAuthenticationDefaults.AccessTokenName);
            var refreshToken = await HttpContext.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme, KeycloakAuthenticationDefaults.RefreshTokenName);

            // Validate the token first
            if (string.IsNullOrEmpty(accessToken))
            {
                _logger.LogError("Access token is missing in KeycloakLoginCallback");
                return RedirectToRoute("Login");
            }

            // Validate token
            var validateToken = await _jwtValidationService.ValidateJwt(accessToken);
            if (validateToken == null)
            {
                _logger.LogError("Access token validation failed in KeycloakLoginCallback");
                return RedirectToRoute("Login");
            }

            var authenticateResult = await HttpContext.AuthenticateAsync(KeycloakAuthenticationDefaults.AuthenticationScheme);
            if (!authenticateResult.Succeeded || !authenticateResult.Principal.Claims.Any())
            {
                _logger.LogError("Authentication failed in KeycloakLoginCallback");
                return RedirectToRoute("Login");
            }

            // Extract email claim safely
            var email = authenticateResult.Principal.FindFirst(claim => claim.Type == JwtRegisteredClaimNames.Email)?.Value;
            var identifier = authenticateResult.Principal.FindFirst(claim => claim.Type == JwtRegisteredClaimNames.Sub)?.Value;

            // Validate required claims
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(identifier))
            {
                _logger.LogError("Required claims (email or sub) missing in KeycloakLoginCallback");
                return RedirectToRoute("Login");
            }

            var authenticationParameters = new ExternalAuthParam {
                ProviderSystemName = KeycloakAuthenticationDefaults.ProviderSystemName,
                AccessToken = accessToken, // Reuse the token we already validated
                Email = email,
                Identifier = identifier,
                Name = authenticateResult.Principal.FindFirst(claim => claim.Type == "name")?.Value,
                Claims = authenticateResult.Principal.Claims.ToList()
            };

            //authenticate Grand user
            return await _openIdConnectGrandAuthenticationService.Authenticate(authenticationParameters, refreshToken!, returnurl);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in KeycloakLoginCallback");
            return RedirectToRoute("Login");
        }
    }

    public async Task<IActionResult> OpenIdSignOut()
    {
        var idToken = await HttpContext.GetTokenAsync(KeycloakAuthenticationDefaults.AuthenticationScheme,"id_token");

        // SignOut işlemini yapılandır
        var properties = new AuthenticationProperties
        {
            // RedirectUri = "https://localhost:5011/Admin/Home/Logout"
        };

        // Keycloak'un logout endpoint'ini yapılandır
        // properties.Items.Add("client_id", _optionsAuthConfiguration.Value.ClientId);
        properties.Items.Add("id_token_hint", idToken);
         // Yönlendirme URI'sini keycloak yapılandırmasındaki post_logout_redirect_uris ile eşleştiğinden emin olun
        var absoluteUrl = $"{Request.Scheme}://{Request.Host}/super-admin/KeycloakLogout";
        properties.Items.Add("post_logout_redirect_uri", absoluteUrl);


        return SignOut(
            properties,
            KeycloakAuthenticationDefaults.AuthenticationScheme,
            GrandCookieAuthenticationDefaults.AuthenticationScheme,
            GrandCookieAuthenticationDefaults.ExternalAuthenticationScheme
        );
    }

    public async Task<IActionResult> KeycloakLogout(string logout_token)
    {
        _logger.LogInformation("BC Logout event from server: {logout_token}", logout_token);

        // MvcHybridBackChannelBackChannel Backchannel Logout from the server
        Response.Headers.CacheControl= StringValues.Concat(Response.Headers.CacheControl,new StringValues("no-cache, no-store"));
        Response.Headers.Pragma= StringValues.Concat(Response.Headers.Pragma,new StringValues("no-cache"));

        try
        {
            var user = await ValidateLogoutToken(logout_token);

            // these are the sub & sid to signout
            var sub = user.FindFirst("sub")?.Value;
            var sid = user.FindFirst("sid")?.Value;

            var externalAuthRecord =
                await _externalAuthenticationRepository.GetOneAsync(x => x.ExternalIdentifier == sub);
            
            if (externalAuthRecord != null)
            {
                await _externalAuthenticationRepository.UpdateField(externalAuthRecord.Id, x => x.OAuthAccessToken,
                    null);
            }
            await _logoutSessions.Add(sub, sid);

            //await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            try
            {
                await _grandAuthenticationService.SignOut();
            }
            catch (Exception e)
            {
                _logger.LogError("Grand sign out error during keycloak logout",e);
            }
            return Ok();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"{ex.Message}");
        }
        return BadRequest();
    }
    
    private async Task<ClaimsPrincipal> ValidateLogoutToken(string logoutToken)
    {
        if (string.IsNullOrEmpty(logoutToken))
        {
            _logger.LogError("Logout token is null or empty");
            throw new ArgumentException("Logout token cannot be null or empty", nameof(logoutToken));
        }

        try
        {
            var claims = await _jwtValidationService.ValidateJwt(logoutToken);

            if (claims == null)
            {
                _logger.LogError("JWT validation service returned null claims for logout token");
                throw new Exception("Invalid logout token - validation failed");
            }

            // Check for required claims
            if (claims.FindFirst("sub") == null || claims.FindFirst("sid") == null)
            {
                _logger.LogError("Logout token missing required claims (sub or sid)");
                throw new Exception("Invalid logout token - required claims missing");
            }

            // Nonce should not be present in logout tokens
            var nonce = claims.FindFirstValue("nonce");
            if (!string.IsNullOrWhiteSpace(nonce))
            {
                _logger.LogError("Logout token contains unexpected nonce value");
                throw new Exception("Invalid logout token - unexpected nonce present");
            }

            // Check for events claim
            var eventsJson = claims.FindFirst("events")?.Value;
            if (string.IsNullOrWhiteSpace(eventsJson))
            {
                _logger.LogError("Logout token missing events claim");
                throw new Exception("Invalid logout token - events claim missing");
            }

            try
            {
                var events = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(eventsJson);
                if (events == null)
                {
                    _logger.LogError("Failed to deserialize events JSON");
                    throw new Exception("Invalid logout token - events claim format invalid");
                }

                var logoutEvent = events.TryGetValue("http://schemas.openid.net/event/backchannel-logout", out var logoutTokenData);
                if (!logoutEvent)
                {
                    _logger.LogError("Logout token events claim does not contain backchannel-logout event");
                    throw new Exception("Invalid logout token - backchannel-logout event missing");
                }
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "Error deserializing events JSON");
                throw new Exception("Invalid logout token - events claim JSON invalid");
            }

            return claims;
        }
        catch (Exception ex) when (!(ex is ArgumentException))
        {
            _logger.LogError(ex, "Error validating logout token");
            throw new Exception($"Invalid logout token - {ex.Message}");
        }
    }
}