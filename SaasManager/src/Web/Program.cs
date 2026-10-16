using Platform.Security;
using Platform.Provisioning;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Core;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.AspNetCore.Server.Kestrel.Https;
using NSwag.AspNetCore;
using SaasManager.Application;
using SaasManager.Infrastructure;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.Utilities;
using SaasManager.Web;
using SaasManager.Web.Middlewares;

var builder = WebApplication.CreateBuilder(args);
var localConfigPath = builder.Configuration["PlatformConfiguration:ConfigPath"] ?? builder.Configuration["LocalDemo:ConfigPath"];
if (!string.IsNullOrWhiteSpace(localConfigPath)) builder.Configuration.AddJsonFile(localConfigPath, optional: false);
builder.Configuration.AddEnvironmentVariables();
var isLocalDemo = builder.Configuration.GetValue<bool>("LocalDemo:Enabled");
if (isLocalDemo && !builder.Environment.IsDevelopment())
    throw new InvalidOperationException("LocalDemo requires Development.");
bool isAzureWebApp = !string.IsNullOrEmpty(Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME"));
if (isAzureWebApp)
{
    builder.WebHost.UseKestrel(kestrelOpt =>
    {
        kestrelOpt.ListenAnyIP(5001);
    });
}

// Add services to the container.
builder.AddKeyVaultIfConfigured();
builder.Services.AddPlatformSecurity(builder.Configuration, builder.Environment.EnvironmentName);
builder.Services.AddPlatformProvisioning(builder.Configuration);
builder.ConfigureSettings();
builder.RegisterAuthentication();
builder.ConfigureServices();
builder.AddApplicationServices();
builder.AddInfrastructureServices();
builder.AddWebServices();

if (isAzureWebApp)
{
    builder.Services.Configure<ForwardedHeadersOptions>(options =>
    {
        options.ForwardedHeaders =
            ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
    });
}

var app = builder.Build();
if (isAzureWebApp)
{
    app.UseForwardedHeaders();
}
app.UseExceptionHandler(new ExceptionHandlerOptions {
    ExceptionHandler = context => Results.Problem(statusCode: StatusCodes.Status500InternalServerError,
        title: "The request could not be completed.").ExecuteAsync(context)
});
if (!app.Environment.IsDevelopment())
{
    app.UseHsts();
}

// Security middleware'ler sıralı olmalı
if (!isLocalDemo) app.UseHttpsRedirection();

// TLS versiyonu kontrolü için custom middleware
app.Use(async (context, next) =>
{
    if (isAzureWebApp)
    {
        var tlsVersion = context.Request.Headers["X-Forwarded-TlsVersion"].ToString();
        if (!string.IsNullOrEmpty(tlsVersion) && Version.Parse(tlsVersion) < Version.Parse("1.2"))
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsync("TLS 1.2 or higher is required.");
            return;
        }
        
        if (context.Request.Headers.TryGetValue("X-Forwarded-Proto", out var forwardedProto))
        {
            context.Request.Scheme = forwardedProto.ToString();
        }

        if (context.Request.Scheme != "https")
        {
            context.Response.Redirect($"https://{context.Request.Host}{context.Request.PathBase}{context.Request.Path}{context.Request.QueryString}");
            return;
        }
    }
    else if(app.Environment.IsDevelopment() && !isLocalDemo)
    {
        context.Request.Scheme = "https";
    }
        
    await next();
});
app.UseStaticFiles();
if (isLocalDemo)
{
    // This first demo exposes the existing management UI with fixed sample tenants.
    // Cloud provisioning, billing and store publishing require the later cloud profile.
    app.Use(async (context, next) =>
    {
        var path = context.Request.Path;
        var readOnlyMethod = HttpMethods.IsGet(context.Request.Method) || HttpMethods.IsHead(context.Request.Method);
        var allowedDemoEndpoint = path.StartsWithSegments("/api/Auth") ||
            path.StartsWithSegments("/api/SubscriptionPlans") ||
            path.Equals("/api") || path.Equals("/api/specification.json") ||
            path.Value?.StartsWith("/api/swagger-ui", StringComparison.OrdinalIgnoreCase) == true;
        var localOnboarding = app.Configuration.GetValue<bool>("LocalDemo:SelfService") &&
            (path.StartsWithSegments("/api/LocalBusinesses") || path.StartsWithSegments("/api/Provisioning"));
        var localFiles = app.Configuration.GetValue<bool>("LocalDemo:AssetsEnabled") &&
            (path.Equals("/api/uploads/app-asset") || path.Equals("/api/uploads/app-asset/file") || path.Equals("/api/app-builds/download") || path.Equals("/api/app-builds/get-vm"));
        if (path.StartsWithSegments("/api") && !localOnboarding && !localFiles && (!readOnlyMethod || !allowedDemoEndpoint))
        {
            context.Response.StatusCode = StatusCodes.Status409Conflict;
            await context.Response.WriteAsJsonAsync(new { message = "Local demo uses pre-seeded tenants. Cloud provisioning and billing are disabled." });
            return;
        }
        await next();
    });
}
app.UseCors();

// Authentication middleware'ler doğru sırada olmalı
app.UseAuthentication();
app.UseAuthorization();
app.UseMiddleware<AuthenticationMiddleware>(); // Custom middleware

app.UseAntiforgery();
app.UseHealthChecks("/health");

// Middleware yapılandırması
app.UseOpenApi(settings => settings.Path = "/api/specification.json");

app.UseSwaggerUi(settings =>
{
    settings.Path = "/api";
    settings.DocumentPath = "/api/specification.json";

    // OAuth2 Client yapılandırması
    settings.OAuth2Client = new OAuth2ClientSettings
    {
        ClientId = app.Configuration["AuthConfiguration:ClientId"],
        UsePkceWithAuthorizationCodeGrant = true,

        // Keycloak'ta tanımlı scope'lar
        Scopes =
        {
            "openid",
            "profile",
            "email",
            "roles",
            "offline_access"
        },

        // Keycloak realm ayarı
        Realm = app.Configuration["AuthConfiguration:Realm"] ?? "master",
    };

    // Cookie ve güvenlik ayarları
    settings.WithCredentials = true;

    // Callback paths - Keycloak path'leri ile uyumlu
    settings.ServerUrl = $"{app.Configuration["ApplicationUrl"]}";
});

app.MapControllerRoute(
    name: "default",
    pattern: "{controller}/{action=Index}/{id?}");

app.MapRazorPages();

app.MapFallbackToFile("/index.html");

app.MapEndpoints();

// Development özellikleri
await app.InitialiseDatabaseAsync();

app.Run();

public partial class Program
{
}
