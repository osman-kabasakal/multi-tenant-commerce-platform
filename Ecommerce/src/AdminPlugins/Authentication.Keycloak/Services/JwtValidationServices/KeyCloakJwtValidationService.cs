using Authentication.Keycloak.Infrastructure;
using Authentication.Keycloak.Models;
using Grand.Infrastructure.Caching;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json;

namespace Authentication.Keycloak.Services.JwtValidationServices;

public class KeyCloakJwtValidationService
{
    private readonly ILogger<KeyCloakJwtValidationService> _logger;
    private readonly IOptions<AuthConfiguration> _optionsAuthConfiguration;
    private readonly ICacheBase _cache;
    private readonly HttpClient _httpClient;

    public KeyCloakJwtValidationService(
        ILogger<KeyCloakJwtValidationService> logger,
        IHttpClientFactory clientFactory,
        IOptions<AuthConfiguration> optionsAuthConfiguration,
        ICacheBase cache
    )
    {
        _logger = logger;
        _optionsAuthConfiguration = optionsAuthConfiguration;
        _cache = cache;
        _httpClient = clientFactory.CreateClient();
    }


    public async Task<ClaimsPrincipal?> ValidateJwt(string jwt, bool validateLifetime = true)
    {
        try
        {
            // 1. JWKS endpoint'inden public key'leri al
            var disco = await GetDiscoveryDocumentAsync();
            var keysResponse = await _cache.GetAsync<OpenIdJkwsKeysModel>(
                "keycloak.jwks.keys",
                async () =>
                {
                    var response = await _httpClient.GetAsync(disco.JwksUri);
                    response.EnsureSuccessStatusCode();
                    return await response.Content.ReadFromJsonAsync<OpenIdJkwsKeysModel>();
                }, 120);

            if (keysResponse?.Keys == null || !keysResponse.Keys.Any())
            {
                throw new SecurityTokenValidationException("No signing keys found");
            }

            // 2. JWT'den kid (Key ID) değerini çıkar
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(jwt);
            var kid = jwtToken.Header.Kid;

            // 3. JWKS'den eşleşen key'i bul
            var signingKey = keysResponse.Keys
                .FirstOrDefault(k => k.Kid == kid);

            if (signingKey == null)
            {
                throw new SecurityTokenValidationException($"No matching key found for kid: {kid}");
            }

            // 4. ECDsa için key parametrelerini hazırla
            var key = new JsonWebKey {
                Kty = signingKey.Kty,
                Kid = signingKey.Kid,
                Use = signingKey.Use,
                Alg = signingKey.Alg,
                X = signingKey.X,
                Y = signingKey.Y,
                Crv = signingKey.Crv
            };

            // 5. Validasyon parametrelerini ayarla
            var validationParameters = new TokenValidationParameters {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = validateLifetime,
                ValidateIssuerSigningKey = true,
                ValidIssuer = _optionsAuthConfiguration.Value.IdentityProviderUrl,
                ValidAudience = _optionsAuthConfiguration.Value.Audience,
                ValidAudiences = [
                    "centraladminapp"
                ],
                IssuerSigningKey = key,
                ValidAlgorithms = new[] { "ES384" }, // Sadece ES384'e izin ver
                ClockSkew = TimeSpan.FromMinutes(5),
                RequireExpirationTime = true,
                RequireAudience = true,
                NameClaimType = JwtRegisteredClaimNames.Name,
                RoleClaimType = "role",
            };

            handler.InboundClaimTypeMap.Clear();

            // 6. Token'ı validate et
            var principal = handler.ValidateToken(jwt, validationParameters, out var validatedToken);

            // 7. Token türünü kontrol et
            if (!(validatedToken is JwtSecurityToken))
            {
                throw new SecurityTokenValidationException("Invalid JWT token");
            }

            return principal;
        }
        catch (Exception ex) when (
            ex is SecurityTokenExpiredException ||
            ex is SecurityTokenInvalidSignatureException ||
            ex is SecurityTokenValidationException)
        {
            // Loglama yap
            _logger.LogWarning(ex, "Token validation failed");
            return null;
        }
    }

    public async Task<OpenIdDiscoveryModel?> GetDiscoveryDocumentAsync()
    {
        return await _cache.GetAsync("keycloack.discovery", async () =>
            await _httpClient.GetFromJsonAsync<OpenIdDiscoveryModel>(Path.Combine(
                _optionsAuthConfiguration.Value.IdentityProviderUrl,
                ".well-known/openid-configuration")), 120);
    }

    public async Task<bool> RemoteValidationTokenAsync(string token)
    {
        var introspectionEndpoint =
            $"{_optionsAuthConfiguration.Value.IdentityProviderUrl}/protocol/openid-connect/token/introspect";

        var content = new FormUrlEncodedContent(new Dictionary<string, string> {
            ["token"] = token,
            ["client_id"] = _optionsAuthConfiguration.Value.ClientId,
            ["client_secret"] = _optionsAuthConfiguration.Value.ClientSecret
        });

        var response = await _httpClient.PostAsync(introspectionEndpoint, content);
        if (!response.IsSuccessStatusCode)
        {
            return false;
        }

        var result = await response.Content.ReadFromJsonAsync<TokenIntrospectionResponse>();
        return result?.Active ?? false;
    }
}