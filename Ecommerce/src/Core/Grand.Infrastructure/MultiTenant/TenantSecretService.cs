using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Extensions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;

namespace Grand.Infrastructure.MultiTenant;

public interface ITenantSecretService
{
    Task<string> GetBackendSecretAsync(string tenantId = null);
    Task<string> GetFrontendSecretAsync(string tenantId = null);
}

public class TenantSecretService : ITenantSecretService
{
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IMemoryCache _memoryCache;
    private readonly IConfiguration _configuration;
    private readonly string _keyVaultUrl;
    private readonly SecretClient _client;
    private readonly TimeSpan _cacheTime = TimeSpan.FromMinutes(60);

    public TenantSecretService(
        IHttpContextAccessor httpContextAccessor,
        IMemoryCache memoryCache,
        IConfiguration configuration, SecretClient client)
    {
        _httpContextAccessor = httpContextAccessor;
        _memoryCache = memoryCache;
        _configuration = configuration;
        _client = client;
        _keyVaultUrl = _configuration.GetConnectionString("kvUri");

        if (string.IsNullOrEmpty(_keyVaultUrl) && !configuration.GetValue<bool>("LocalDemo:Enabled"))
        {
            throw new InvalidOperationException("Azure KeyVault URL is not configured");
        }
    }

    public async Task<string> GetBackendSecretAsync(string tenantId = null)
    {
        tenantId ??= _httpContextAccessor.HttpContext?.GetTenantId() ?? "default";
        var cacheKey = $"BackendAPI.Secret.{tenantId}";

        if (!_memoryCache.TryGetValue(cacheKey, out string secretKey))
        {
            secretKey = await GetSecretFromKeyVaultAsync($"BackendAPI-Secret-{tenantId}");
            
            // If tenant-specific secret is not found, fall back to default secret
            if (string.IsNullOrEmpty(secretKey))
            {
                var backendApiConfig = new TenantBackendAPIConfig();
                _configuration.GetSection("BackendAPI").Bind(backendApiConfig);
                secretKey = backendApiConfig.SecretKey;
            }

            _memoryCache.Set(cacheKey, secretKey, _cacheTime);
        }

        return secretKey;
    }

    public async Task<string> GetFrontendSecretAsync(string tenantId = null)
    {
        tenantId ??= _httpContextAccessor.HttpContext?.GetTenantId() ?? "default";
        var cacheKey = $"FrontendAPI.Secret.{tenantId}";

        if (!_memoryCache.TryGetValue(cacheKey, out string secretKey))
        {
            secretKey = await GetSecretFromKeyVaultAsync($"FrontendAPI-Secret-{tenantId}");
            
            // If tenant-specific secret is not found, fall back to default secret
            if (string.IsNullOrEmpty(secretKey))
            {
                var frontendApiConfig = new TenantFrontendAPIConfig();
                _configuration.GetSection("FrontendAPI").Bind(frontendApiConfig);
                secretKey = frontendApiConfig.SecretKey;
            }

            _memoryCache.Set(cacheKey, secretKey, _cacheTime);
        }

        return secretKey;
    }

    private async Task<string> GetSecretFromKeyVaultAsync(string secretName)
    {
        try
        {
            var response = await _client.GetSecretAsync(secretName);
            return response.Value.Value;
        }
        catch (Exception)
        {
            // If secret not found or access denied, return null to fallback to default
            return null;
        }
    }
}
//
// public class BackendAPIConfig
// {
//     public bool Enabled { get; set; }
//     public string SecretKey { get; set; }
//     public bool ValidateIssuer { get; set; }
//     public bool ValidateAudience { get; set; }
//     public bool ValidateLifetime { get; set; }
//     public int ExpiryInMinutes { get; set; }
//     public string ValidIssuer { get; set; }
//     public string ValidAudience { get; set; }
// }
//
// public class FrontendAPIConfig
// {
//     public const string AuthenticationScheme = "FrontEndScheme";
//     public bool Enabled { get; set; }
//     public string SecretKey { get; set; }
//     public bool ValidateIssuer { get; set; }
//     public bool ValidateAudience { get; set; }
//     public bool ValidateLifetime { get; set; }
//     public bool ValidateIssuerSigningKey { get; set; }
//     public int ExpiryInMinutes { get; set; }
//     public int RefreshTokenExpiryInMinutes { get; set; }
//     public string ValidIssuer { get; set; }
//     public string ValidAudience { get; set; }
// }