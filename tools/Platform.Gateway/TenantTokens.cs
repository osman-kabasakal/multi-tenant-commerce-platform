using System.Collections.Concurrent;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Caching.Memory;
using Platform.Security;

namespace Platform.Gateway;

public sealed class TenantTokens(GatewayOptions options, ITenantSecrets secrets, IHttpClientFactory clients) : IDisposable
{
    private readonly MemoryCache cache = new(new MemoryCacheOptions { SizeLimit = options.TokenCacheEntries });
    private readonly ConcurrentDictionary<string, Lazy<Task<string>>> pending = new();

    public async Task<string> GetAsync(TenantRoute route, CancellationToken ct)
    {
        var key = route.TenantId + ":" + route.Slug;
        if (cache.TryGetValue<string>(key, out var saved)) return saved!;
        var fetch = pending.GetOrAdd(key, _ => new Lazy<Task<string>>(() => FetchAsync(route, key), LazyThreadSafetyMode.ExecutionAndPublication));
        try { return await fetch.Value.WaitAsync(ct); }
        finally
        {
            // A cancelled caller must not remove another caller's active token request.
            if (fetch.IsValueCreated && fetch.Value.IsCompleted) pending.TryRemove(new KeyValuePair<string, Lazy<Task<string>>>(key, fetch));
        }
    }

    private async Task<string> FetchAsync(TenantRoute route, string key)
    {
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(20));
        var secret = await secrets.GetAsync(route.TenantId, TenantSecretNames.KeycloakClient, timeout.Token);
        using var client = clients.CreateClient("gateway-identity");
        using var response = await client.PostAsync(options.IdentityAuthority.TrimEnd('/') + "/realms/" + Uri.EscapeDataString(options.IdentityRealm) + "/protocol/openid-connect/token",
            new FormUrlEncodedContent(new Dictionary<string, string> { ["grant_type"] = "client_credentials", ["client_id"] = route.Slug, ["client_secret"] = secret }), timeout.Token);
        if (!response.IsSuccessStatusCode) throw new InvalidOperationException("The tenant identity request failed.");
        using var payload = JsonDocument.Parse(await response.Content.ReadAsStringAsync(timeout.Token));
        var token = payload.RootElement.GetProperty("access_token").GetString()!;
        var lifetime = payload.RootElement.GetProperty("expires_in").GetInt32();
        if (token.Length > 32768 || !Regex.IsMatch(token, "^[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+$") || lifetime is < 1 or > 86400 ||
            !payload.RootElement.GetProperty("token_type").GetString()!.Equals("Bearer", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Invalid tenant identity response.");
        if (lifetime > 10) cache.Set(key, token, new MemoryCacheEntryOptions { AbsoluteExpirationRelativeToNow = TimeSpan.FromSeconds(Math.Min(lifetime - 5, options.TokenCacheSeconds)), Size = 1 });
        return token;
    }
    public void Dispose() => cache.Dispose();
}
