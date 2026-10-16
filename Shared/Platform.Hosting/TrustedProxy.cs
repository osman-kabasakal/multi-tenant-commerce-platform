using System.Net;
using System.Net.Sockets;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Platform.Hosting;

public static class TrustedProxy
{
    public static IServiceCollection AddTrustedProxy(this IServiceCollection services, IConfiguration config)
    {
        if (!config.GetValue<bool>("Proxy:Enabled")) return services;
        var proxies = config.GetSection("Proxy:KnownProxies").Get<string[]>() ?? [];
        var networks = config.GetSection("Proxy:KnownNetworks").Get<string[]>() ?? [];
        var limit = config.GetValue<int?>("Proxy:ForwardLimit") ?? 1;
        if (proxies.Length + networks.Length == 0 || limit is < 1 or > 10)
            throw new InvalidOperationException("Configure explicit trusted proxy addresses/networks and a bounded forward limit.");
        var addresses = proxies.Select(value => IPAddress.TryParse(value, out var address) ? address
            : throw new InvalidOperationException("Trusted proxy addresses must be literal IP addresses.")).ToArray();
        var ranges = networks.Select(value => {
            var parts = value.Split('/');
            if (parts.Length != 2 || !IPAddress.TryParse(parts[0], out var address) || !int.TryParse(parts[1], out var prefix) ||
                prefix < 1 || prefix > (address.AddressFamily == AddressFamily.InterNetwork ? 32 : 128))
                throw new InvalidOperationException("Use explicit bounded CIDR networks for trusted proxies.");
            return new Microsoft.AspNetCore.HttpOverrides.IPNetwork(address, prefix);
        }).ToArray();
        services.Configure<ForwardedHeadersOptions>(options => {
            options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
            options.ForwardLimit = limit;
            options.KnownProxies.Clear(); options.KnownNetworks.Clear();
            foreach (var address in addresses) options.KnownProxies.Add(address);
            foreach (var range in ranges) options.KnownNetworks.Add(range);
        });
        return services;
    }

    public static IApplicationBuilder UseTrustedProxy(this IApplicationBuilder app, IConfiguration config)
    {
        if (config.GetValue<bool>("Proxy:Enabled")) app.UseForwardedHeaders();
        return app;
    }
}
