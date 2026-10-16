using Microsoft.AspNetCore.Http;
using Yarp.ReverseProxy.Forwarder;

namespace Platform.Gateway;

public sealed class TenantTransformer(TenantRoute route, string? token) : HttpTransformer
{
    public override async ValueTask TransformRequestAsync(HttpContext context, HttpRequestMessage request, string destinationPrefix, CancellationToken ct)
    {
        await base.TransformRequestAsync(context, request, destinationPrefix, ct);
        foreach (var name in request.Headers.Select(h => h.Key).Where(UntrustedHeader).ToArray()) request.Headers.Remove(name);
        request.Headers.Host = context.Request.Host.Value;
        request.Headers.TryAddWithoutValidation("X-Forwarded-Proto", context.Request.Scheme);
        if (context.Connection.RemoteIpAddress != null) request.Headers.TryAddWithoutValidation("X-Forwarded-For", context.Connection.RemoteIpAddress.ToString());
        if (!route.Admin) request.Headers.Add("x-store-token", token);
        var query = QueryString.Create(context.Request.Query.Where(p => !p.Key.Equals("store_token", StringComparison.OrdinalIgnoreCase)));
        request.RequestUri = RequestUtilities.MakeDestinationAddress(destinationPrefix, context.Request.Path, query);
    }
    public override async ValueTask<bool> TransformResponseAsync(HttpContext context, HttpResponseMessage? response, CancellationToken ct)
    {
        var forward = await base.TransformResponseAsync(context, response, ct);
        foreach (var name in context.Response.Headers.Keys.Where(n => n.Equals("x-store-token", StringComparison.OrdinalIgnoreCase) || n.Equals("Authorization", StringComparison.OrdinalIgnoreCase)).ToArray())
            context.Response.Headers.Remove(name);
        return forward;
    }
    private static bool UntrustedHeader(string name) => name.Equals("Forwarded", StringComparison.OrdinalIgnoreCase) ||
        name.StartsWith("X-Forwarded-", StringComparison.OrdinalIgnoreCase) || name.StartsWith("X-Original-", StringComparison.OrdinalIgnoreCase) ||
        name.Equals("x-store-token", StringComparison.OrdinalIgnoreCase) || name.Equals("X-Platform-Tenant", StringComparison.OrdinalIgnoreCase) ||
        name.StartsWith("X-ARR-", StringComparison.OrdinalIgnoreCase) || name.Equals("X-AppService-Proto", StringComparison.OrdinalIgnoreCase);
}
