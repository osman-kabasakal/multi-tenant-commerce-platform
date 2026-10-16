using Grand.Infrastructure.Caching;
using Grand.Web.MultiTenant.Models;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json;

namespace Grand.Web.MultiTenant.Services;

public class KeycloakClientTokenValidation: IKeycloakClientTokenValidation
{
    private readonly IHttpClientFactory _clientFactory;
    private readonly IOptions<AuthConfiguration> _optionsAuthConfiguration;
    private readonly ILogger<KeycloakClientTokenValidation> _logger;
    private readonly ICacheBase _cache;
    private readonly HttpClient _httpClient;

    public KeycloakClientTokenValidation(
        IHttpClientFactory clientFactory,
        IOptions<AuthConfiguration> optionsAuthConfiguration,
        ILogger<KeycloakClientTokenValidation> logger,
        ICacheBase cache
        )
    {
        _clientFactory = clientFactory;
        _optionsAuthConfiguration = optionsAuthConfiguration;
        _logger = logger;
        _cache = cache;
        _httpClient= clientFactory.CreateClient("tenant-identity");
        
    }
    public async Task<ClaimsPrincipal?> ValidateJwt(string jwt,string audience, bool validateLifetime = true)
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
                });

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
                N = signingKey.N,
                E = signingKey.E,
                Crv = signingKey.Crv
            };

            // 5. Validasyon parametrelerini ayarla
            var validationParameters = new TokenValidationParameters {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = validateLifetime,
                ValidateIssuerSigningKey = true,
                ValidIssuer = _optionsAuthConfiguration.Value.IdentityProviderUrl,
                ValidAudience = audience??_optionsAuthConfiguration.Value.Audience,
                IssuerSigningKey = key,
                ValidAudiences = [ audience ?? _optionsAuthConfiguration.Value.Audience ],
                ValidAlgorithms = new[] { "ES384", "RS256" }, // Explicitly allow the supported asymmetric signing algorithms.
                ClockSkew = TimeSpan.FromMinutes(5),
                RequireExpirationTime = true,
                RequireAudience = true
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
                ".well-known/openid-configuration")));
    }
}