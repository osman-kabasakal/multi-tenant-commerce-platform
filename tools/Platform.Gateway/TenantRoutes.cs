using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using Platform.Security;
using Platform.Hosting;

namespace Platform.Gateway;

public sealed record TenantRoute(string TenantId, string Slug, string StoreId, bool Admin);

public sealed class TenantRoutes(GatewayOptions options, ITenantSecrets secrets)
{
    public async Task<TenantRoute?> ResolveAsync(HostString requested, CancellationToken ct)
    {
        if (options.CustomDomainsEnabled)
        {
            var custom = await ResolveCustomAsync(requested,ct);
            if (custom != null) return custom;
        }
        var host = requested.Host.ToLowerInvariant(); var store = new Uri(options.StoreBaseUrl); var admin = new Uri(options.AdminBaseUrl);
        var isAdmin = host.EndsWith("." + admin.Host, StringComparison.OrdinalIgnoreCase);
        var parent = isAdmin ? admin : store;
        if (!host.EndsWith("." + parent.Host, StringComparison.OrdinalIgnoreCase) || (requested.Port ?? 443) != parent.Port) return null;
        var slug = host[..^(parent.Host.Length + 1)];
        if (!Regex.IsMatch(slug, "^[a-z][a-z0-9-]{1,38}[a-z0-9]$")) return null;
        var path = Path.Combine(options.RouteDirectory, slug + ".json");
        if (!File.Exists(path)) return null;
        var info = new FileInfo(path);
        if (info.LinkTarget != null || info.Length > 65536) throw new InvalidOperationException("A route must be a bounded regular metadata file.");
        using var route = JsonDocument.Parse(await File.ReadAllTextAsync(path, ct)); var value = route.RootElement;
        var tenant = value.GetProperty("tenantId").GetString()!; var storeId = value.GetProperty("storeId").GetString()!;
        if (value.GetProperty("version").GetInt32() != 1 || value.GetProperty("profile").GetString() != "Portable" || value.GetProperty("slug").GetString() != slug ||
            !Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty || id.ToString("N") != tenant || string.IsNullOrWhiteSpace(storeId))
            throw new InvalidOperationException("Invalid tenant route metadata.");
        foreach (var pair in new[] { ("storeUrl", store, "/"), ("adminUrl", admin, "/Admin") })
        {
            var published = new Uri(value.GetProperty(pair.Item1).GetString()!);
            if (published.Scheme != "https" || published.Host != slug + "." + pair.Item2.Host || published.Port != pair.Item2.Port ||
                published.AbsolutePath != pair.Item3 || !string.IsNullOrEmpty(published.Query) || !string.IsNullOrEmpty(published.Fragment) || !string.IsNullOrEmpty(published.UserInfo))
                throw new InvalidOperationException("Tenant route origins do not match the deployment.");
        }
        if (await secrets.ResolveAsync(slug, ct) != tenant || await secrets.ResolveAsync(storeId, ct) != tenant)
            throw new InvalidOperationException("Tenant route ownership does not match the secret store.");
        return new(tenant, slug, storeId, isAdmin);
    }
    public async Task<TenantRoute?> ResolveCustomAsync(HostString requested,CancellationToken ct)
    {
        if(!options.CustomDomainsEnabled || (requested.Port??443)!=443)return null;
        var custom=await TenantCustomHostRoutes.FindAsync(options.RouteDirectory,requested.Host.ToLowerInvariant(),ct);
        if(custom==null)return null;
        if(await secrets.ResolveAsync(custom.Slug,ct)!=custom.TenantId || await secrets.ResolveAsync(custom.StoreId,ct)!=custom.TenantId)
            throw new InvalidOperationException("Custom route ownership does not match the tenant secret store.");
        return new(custom.TenantId,custom.Slug,custom.StoreId,custom.Role=="admin");
    }

}
