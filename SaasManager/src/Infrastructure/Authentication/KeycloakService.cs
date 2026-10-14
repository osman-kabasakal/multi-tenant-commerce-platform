using System.Net.Http.Json;
using Core.Models.Configs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SaasManager.Application.Common.Interfaces.Keycloak;
using SaasManager.Application.Common.Models.Authantication.Keycloak;

namespace SaasManager.Infrastructure.Authentication;

public class KeycloakService: IKeycloakService
{
    private readonly HttpClient _httpClient;
    private readonly AuthConfiguration _configuration;
    private readonly ILogger<KeycloakService> _logger;

    public KeycloakService(
        HttpClient httpClient,
        IOptions<AuthConfiguration> configuration,
        ILogger<KeycloakService> logger)
    {
        _httpClient = httpClient;
        _configuration = configuration.Value;
        _logger = logger;
    }

    public async Task<TokenResponse> RefreshTokenAsync(string refreshToken)
    {
        var tokenEndpoint = $"{_configuration.IdentityProviderUrl}/protocol/openid-connect/token";
        
        var content = new FormUrlEncodedContent(new Dictionary<string, string>
        {
            ["grant_type"] = "refresh_token",
            ["client_id"] = _configuration.ClientId,
            ["client_secret"] = _configuration.ClientSecret,
            ["refresh_token"] = refreshToken
        });

        var response = await _httpClient.PostAsync(tokenEndpoint, content);
        if (!response.IsSuccessStatusCode)
        {
            throw new KeycloakException("Token refresh failed");
        }

        var result = await response.Content.ReadFromJsonAsync<TokenResponse>();
        return result ?? throw new KeycloakException("Invalid token response");
    }

    public async Task<bool> ValidateTokenAsync(string token)
    {
        var introspectionEndpoint = $"{_configuration.IdentityProviderUrl}/protocol/openid-connect/token/introspect";
        
        var content = new FormUrlEncodedContent(new Dictionary<string, string>
        {
            ["token"] = token,
            ["client_id"] = _configuration.ClientId,
            ["client_secret"] = _configuration.ClientSecret
        });

        var response = await _httpClient.PostAsync(introspectionEndpoint, content);
        if (!response.IsSuccessStatusCode)
        {
            return false;
        }

        var result = await response.Content.ReadFromJsonAsync<TokenIntrospectionResponse>();
        return result?.Active ?? false;
    }

    public async Task RevokeTokenAsync(string token)
    {
        var revokeEndpoint = $"{_configuration.IdentityProviderUrl}/protocol/openid-connect/revoke";
        
        var content = new FormUrlEncodedContent(new Dictionary<string, string>
        {
            ["token"] = token,
            ["client_id"] = _configuration.ClientId,
            ["client_secret"] = _configuration.ClientSecret
        });

        await _httpClient.PostAsync(revokeEndpoint, content);
    }
}
