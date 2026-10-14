using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json;
using Core.Models.Configs;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using SaasManager.Application.Common.Interfaces.Cache;
using SaasManager.Application.Common.Interfaces.Keycloak;
using SaasManager.Application.Common.Models.Authantication;

namespace SaasManager.Infrastructure.Keycloak;

public class KeyCloakJwtValidationService(
    IHttpClientFactory clientFactory,
    IOptions<AuthConfiguration> optionsAuthConfiguration,
    ICacheBase cache):IKeyCloakJwtValidationService
{
    private readonly HttpClient _httpClient = clientFactory.CreateClient();

    public async Task<ClaimsPrincipal?> ValidateJwt(string jwt, bool validateLifetime = true)
    {
        var disco = await GetDiscoveryDocumentAsync();

        var keysResponse = await cache.GetAsync("keycloak.jkws.keys",
            async () => await _httpClient.GetFromJsonAsync<OpenIdJkwsKeysModel>(disco!.JwksUri));

        // await Dis.GetDiscoveryDocumentAsync(
        //    _httpClient, _optionsAuthConfiguration.Value.IdentityProviderUrl);

        var keys = new List<SecurityKey>();

        foreach (var webKey in keysResponse!.Keys)
        {
            var key = JsonWebKey.Create(JsonSerializer.Serialize(webKey));
            keys.Add(key);
        }

        var parameters = new TokenValidationParameters {
            ValidIssuer = disco!.Issuer,
            ValidAudience = optionsAuthConfiguration.Value.Audience,
            IssuerSigningKeys = keys,
            NameClaimType = "name",
            RoleClaimType = "role",
            ClockSkew = TimeSpan.FromMinutes(0),
            ValidateIssuerSigningKey = true,
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = validateLifetime,
            RequireExpirationTime = true,
            RequireAudience = true,
        };

        var handler = new JwtSecurityTokenHandler();
        handler.InboundClaimTypeMap.Clear();

        var user = handler.ValidateToken(jwt, parameters, out var _securityToken);
        return user;
    }

    public async Task<OpenIdDiscoveryModel?> GetDiscoveryDocumentAsync()
    {
        return await cache.GetAsync("keycloack.discovery", async () =>
            await _httpClient.GetFromJsonAsync<OpenIdDiscoveryModel>(Path.Combine(
                optionsAuthConfiguration.Value.IdentityProviderUrl,
                ".well-known/openid-configuration")));
    }
}
