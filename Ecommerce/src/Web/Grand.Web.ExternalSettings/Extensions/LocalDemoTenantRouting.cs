using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace Grand.Web.ExternalSettings.Extensions;

/// <summary>Fixed hostname-to-database routing for the local admin demo; normal admin authentication remains active.</summary>
public static class LocalDemoTenantRouting
{
    public static void UseLocalDemoTenantRouting(this WebApplication app)
    {
        if (!app.Configuration.GetValue<bool>("LocalDemo:Enabled")) return;
        var directory = app.Configuration["LocalDemo:TenantDirectory"]
            ?? throw new InvalidOperationException("Demo tenant directory is required.");
        var tenants = new Dictionary<string, (string StoreId, string Connection)>(StringComparer.OrdinalIgnoreCase);
        foreach (var slug in new[] { "demo-a", "demo-b" })
        {
            using var data = JsonDocument.Parse(File.ReadAllText(Path.Combine(directory, slug + ".json")));
            var root = data.RootElement;
            tenants[slug + ".localhost"] = (root.GetProperty("storeId").GetString()!, root.GetProperty("connectionString").GetString()!);
        }
        tenants["localhost"] = tenants["demo-a.localhost"];
        tenants["127.0.0.1"] = tenants["demo-a.localhost"];
        app.Use(async (context, next) =>
        {
            if (!tenants.TryGetValue(context.Request.Host.Host, out var tenant))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                return;
            }
            context.Items["StoreId"] = tenant.StoreId;
            context.Items["StoreMongoConnectionString"] = tenant.Connection;
            await next();
        });
    }
}
