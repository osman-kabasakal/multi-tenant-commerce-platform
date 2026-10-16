using System.Net.Http;
using Grand.Business.Marketing.Extensions;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Extensions;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Grand.Web.MultiTenant.CacheHub;
using Grand.Web.MultiTenant.Extensions;
// using Grand.Web.MultiTenant.Middlewares;
using Grand.Web.MultiTenant.MiddleWares;
using Grand.Web.MultiTenant.Models;
using Grand.Web.MultiTenant.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding.Binders;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using ComplexTypeModelBinderProvider = Grand.Web.MultiTenant.ModelBinders.ComplexTypeModelBinderProvider;

var builder = WebApplication.CreateBuilder(args);

bool isAzureWebApp = !string.IsNullOrEmpty(Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME"));
bool isLocalDocker = !string.IsNullOrEmpty(Environment.GetEnvironmentVariable("LOCAL_DOCKER_ID"));

CommonPath.WebHostEnvironment = builder.Environment.WebRootPath;
CommonPath.BaseDirectory = builder.Environment.ContentRootPath;

builder.AddServiceDefaults();

builder.Host.UseDefaultServiceProvider((_, options) =>
{
    options.ValidateScopes = false;
    options.ValidateOnBuild = false;
});

builder.Services.Configure<AuthConfiguration>(builder.Configuration.GetSection("AuthConfiguration"));

//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();

// Redis Cache ve FCM servisleri
builder.Services.AddRedisCache(builder.Configuration);
// builder.Services.AddRedisFCMServices();
builder.Services.AddRedisCacheEventHandlers();


builder.Services.AddHttpClient("tenant-identity").ConfigurePrimaryHttpMessageHandler(() =>
    Platform.Security.PrivateCertificateAuthority.CreateHandler(builder.Configuration["AuthConfiguration:AuthorityRootCertificateFile"])
        ?? new SocketsHttpHandler {AllowAutoRedirect=false});
builder.Services.AddScoped<IKeycloakClientTokenValidation, KeycloakClientTokenValidation>();

builder.Services.Configure<MvcOptions>((opt) =>
{
    opt.ModelBinderProviders.Insert(0, new ComplexTypeModelBinderProvider(new ComplexObjectModelBinderProvider()));
});


//build app
var app = builder.Build();
// app.Services.GetRequiredService<RedisCacheCoordinator>().SubscribeToRedisChannel();
var pathBase = Environment.GetEnvironmentVariable("PATH_BASE");
if (!string.IsNullOrEmpty(pathBase))
{
    app.UsePathBase(pathBase);
}
app.Use(async (context, next) =>
{
    if (isLocalDocker)
    {
        context.Request.Headers.Append("X-AppService-Proto", "https");
        context.Request.Headers.Append("X-ARR-LOG-ID", "820bcb9f-177e-40c5-bcb5-e2496a204002");
        context.Request.Headers.Append("X-ARR-SSL", "2048|256|CN=Microsoft Azure RSA TLS Issuing CA 03, O=Microsoft Corporation, C=US|CN=*.azurewebsites.net, O=Microsoft Corporation, L=Redmond, S=WA, C=US");
        context.Request.Headers.Append("X-Client-IP", "176.41.50.101");
        context.Request.Headers.Append("X-Client-Port", "22576");
        context.Request.Headers.Append("X-Forwarded-For", "176.41.50.101:22576");
        context.Request.Headers.Append("X-Forwarded-Proto", "https");
        context.Request.Headers.Append("X-Forwarded-TlsVersion", "1.3");
        context.Request.Host = new HostString(Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME")!.TrimEnd('/'));
    }

    await next();
});

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
    await next();
});


app.UseMiddleware<RequestValidationMiddleware>();
app.UseMiddleware<DeepLinksMiddleWare>();
app.UseMiddleware<PublicPathMiddleware>();
app.UseMiddleware<FileStoreMiddleware>();
app.MapDefaultEndpoints();
if (app.Configuration.GetValue<bool>("Provisioning:ReadinessEndpoint"))
    app.MapGet("/_platform/ready", async (HttpContext context,
        Grand.Business.Core.Interfaces.Common.Stores.IStoreService stores,Platform.Security.ITenantSecrets secrets) =>
    {
        // RequestValidationMiddleware already verified the real tenant JWT and decrypted its database context.
        var storeId=context.Items["StoreId"] as string;
        if (string.IsNullOrEmpty(storeId)) return Results.StatusCode(400);
        try
        {
            var store=await stores.GetStoreById(storeId);
            var tenant=await secrets.ResolveAsync(context.Request.Host.Host.Split('.')[0],context.RequestAborted);
            if (store==null || store.Id!=storeId || await secrets.ResolveAsync(storeId,context.RequestAborted)!=tenant)
                return Results.StatusCode(503);
            context.Response.Headers.CacheControl="no-store";
            return Results.Json(new {tenantId=tenant,storeId=store.Id});
        }
        catch { return Results.StatusCode(503); }
    });

app.UseMiddleware<CorrelationIdMiddleware>();

//request pipeline
StartupBase.ConfigureRequestPipeline(app, builder.Environment);

//run app
app.Run();