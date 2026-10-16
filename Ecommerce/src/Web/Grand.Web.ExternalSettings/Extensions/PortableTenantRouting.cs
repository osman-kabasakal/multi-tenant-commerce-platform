using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Security;

namespace Grand.Web.ExternalSettings.Extensions;

/// <summary>Owned production admin host routing; ordinary admin authentication is still required.</summary>
public static class PortableTenantRouting
{
    public static void UsePortableTenantRouting(this WebApplication app)
    {
        var provider=app.Configuration["TenantRouting:Provider"];
        if (string.IsNullOrWhiteSpace(provider)) return;
        if (provider!="Directory" || app.Configuration.GetValue<bool>("LocalDemo:Enabled") || app.Configuration["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure"))
            throw new InvalidOperationException("Portable admin routing requires an explicit Directory provider and deployment encryption.");
        var directory=app.Configuration["TenantRouting:RouteDirectory"];
        var parents=app.Configuration.GetSection("TenantRouting:AdminParentDomains").Get<string[]>()??[];
        if (string.IsNullOrWhiteSpace(directory) || !Path.IsPathFullyQualified(directory) || !Directory.Exists(directory) || parents.Length==0 ||
            parents.Any(p=>Uri.CheckHostName(p)!=UriHostNameType.Dns || p.Contains('*') || !p.Contains('.')))
            throw new InvalidOperationException("Configure the shared private route directory and exact admin parent domains.");
        app.Use(async(context,next)=> {
            var host=context.Request.Host.Host.ToLowerInvariant();
            var parent=parents.OrderByDescending(p=>p.Length).FirstOrDefault(p=>host.EndsWith("."+p,StringComparison.OrdinalIgnoreCase));
            var slug=parent==null?"":host[..^(parent.Length+1)];
            if (!Regex.IsMatch(slug,"^[a-z][a-z0-9-]{1,38}[a-z0-9]$")) {context.Response.StatusCode=400;return;}
            var path=Path.Combine(directory,slug+".json");
            if (!File.Exists(path)) {context.Response.StatusCode=404;return;}
            try
            {
                using var route=JsonDocument.Parse(await File.ReadAllTextAsync(path,context.RequestAborted));var value=route.RootElement;
                var tenant=value.GetProperty("tenantId").GetString()!;var store=value.GetProperty("storeId").GetString()!;
                var admin=new Uri(value.GetProperty("adminUrl").GetString()!);
                if (value.GetProperty("version").GetInt32()!=1 || !Guid.TryParseExact(tenant,"N",out var id) || id==Guid.Empty || value.GetProperty("profile").GetString()!="Portable" ||
                    value.GetProperty("slug").GetString()!=slug || admin.Scheme!="https" || !admin.Host.Equals(host,StringComparison.OrdinalIgnoreCase) ||
                    admin.Port!=(context.Request.Host.Port??443)) {context.Response.StatusCode=400;return;}
                var secrets=context.RequestServices.GetRequiredService<ITenantSecrets>();
                if (await secrets.ResolveAsync(slug,context.RequestAborted)!=tenant || await secrets.ResolveAsync(store,context.RequestAborted)!=tenant)
                {context.Response.StatusCode=400;return;}
                context.Items["StoreId"]=store;
                context.Items["StoreMongoConnectionString"]=await secrets.GetAsync(tenant,TenantSecretNames.DatabaseConnection,context.RequestAborted);
                context.Response.Headers["X-Platform-Tenant"]=tenant;
            }
            catch(OperationCanceledException)when(context.RequestAborted.IsCancellationRequested){throw;}
            catch {context.Response.StatusCode=503;return;}
            await next();
        });
    }
}
