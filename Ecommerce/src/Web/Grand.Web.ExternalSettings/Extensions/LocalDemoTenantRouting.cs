using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Security;

namespace Grand.Web.ExternalSettings.Extensions;

/// <summary>Routes published local tenants; ordinary authenticated admin access remains required.</summary>
public static class LocalDemoTenantRouting
{
    public static void UseLocalDemoTenantRouting(this WebApplication app)
    {
        if (!app.Configuration.GetValue<bool>("LocalDemo:Enabled")) return;
        var directory=app.Configuration["LocalDemo:TenantDirectory"] ?? throw new InvalidOperationException("Demo tenant directory is required.");
        var routes=Path.Combine(Path.GetDirectoryName(directory)!,"routes");
        app.Use(async (context,next)=> {
            var host=context.Request.Host.Host;
            var slug=host is "localhost" or "127.0.0.1"?"demo-a":host.EndsWith(".localhost",StringComparison.OrdinalIgnoreCase)?host[..^10].ToLowerInvariant():"";
            if (!Regex.IsMatch(slug,"^[a-z][a-z0-9-]{1,38}[a-z0-9]$")) {context.Response.StatusCode=400;return;}
            var path=Path.Combine(routes,slug+".json");
            if (slug is "demo-a" or "demo-b") path=Path.Combine(directory,slug+".json");
            if (!File.Exists(path)) {context.Response.StatusCode=400;return;}
            using var route=JsonDocument.Parse(await File.ReadAllTextAsync(path,context.RequestAborted));
            context.Items["StoreId"]=route.RootElement.GetProperty("storeId").GetString()!;
            context.Items["StoreMongoConnectionString"]=await context.RequestServices.GetRequiredService<ITenantSecrets>().GetAsync(slug,TenantSecretNames.DatabaseConnection,context.RequestAborted);
            await next();
        });
    }
}
