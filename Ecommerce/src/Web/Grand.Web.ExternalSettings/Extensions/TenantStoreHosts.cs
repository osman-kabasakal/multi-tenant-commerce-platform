using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Hosting;
using Platform.Security;

namespace Grand.Web.ExternalSettings.Extensions;

/// <summary>Resolve a custom storefront from worker-owned metadata, never from a client header.</summary>
public static class TenantStoreHosts
{
    public static async Task<TenantCustomHostRoute?> CustomAsync(HttpContext context)
    {
        var config = context.RequestServices.GetRequiredService<IConfiguration>();
        if (!config.GetValue<bool>("TenantRouting:CustomDomainsEnabled")) return null;
        var directory = config["TenantRouting:RouteDirectory"];
        if (config["TenantRouting:Provider"] != "Directory" || string.IsNullOrWhiteSpace(directory) || !Path.IsPathFullyQualified(directory))
            throw new InvalidOperationException("Configure the shared storefront route directory.");
        var route = await TenantCustomHostRoutes.FindAsync(directory, context.Request.Host.Host.ToLowerInvariant(), context.RequestAborted);
        if (route == null) return null;
        if (!context.Request.IsHttps || (context.Request.Host.Port ?? 443) != 443 || route.Role != "store")
            throw new InvalidOperationException("The custom hostname is not an HTTPS storefront.");
        var secrets = context.RequestServices.GetRequiredService<ITenantSecrets>();
        if (await secrets.ResolveAsync(route.Slug, context.RequestAborted) != route.TenantId ||
            await secrets.ResolveAsync(route.StoreId, context.RequestAborted) != route.TenantId)
            throw new InvalidOperationException("The custom storefront belongs to a different tenant.");
        return route;
    }
}
