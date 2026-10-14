using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using DotLiquid;
using Grand.Business.Marketing.Extensions;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Extensions;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);


bool isAzureWebApp = !string.IsNullOrEmpty(Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME"));
bool isLocalDocker=!string.IsNullOrEmpty(Environment.GetEnvironmentVariable("LOCAL_DOCKER_ID"));

CommonPath.WebHostEnvironment = builder.Environment.WebRootPath;
CommonPath.BaseDirectory = builder.Environment.ContentRootPath;

builder.AddServiceDefaults();

builder.Host.UseDefaultServiceProvider((_, options) =>
{
    options.ValidateScopes = false;
    options.ValidateOnBuild = false;
});


//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();

// Redis Cache ve FCM servisleri
builder.Services.AddRedisCache(builder.Configuration);
// builder.Services.AddRedisFCMServices();
// builder.Services.AddRedisCacheEventHandlers();

//build app
var app = builder.Build();

var pathBase = Environment.GetEnvironmentVariable("PATH_BASE");
if (!string.IsNullOrEmpty(pathBase))
{
    app.UsePathBase(pathBase);
}
app.Use(async (context, next) =>
{
    if (isLocalDocker)
    {
        context.Request.Headers.Append("X-AppService-Proto","https");
        context.Request.Headers.Append("X-ARR-LOG-ID","820bcb9f-177e-40c5-bcb5-e2496a204002");
        context.Request.Headers.Append("X-ARR-SSL","2048|256|CN=Microsoft Azure RSA TLS Issuing CA 03, O=Microsoft Corporation, C=US|CN=*.azurewebsites.net, O=Microsoft Corporation, L=Redmond, S=WA, C=US");
        context.Request.Headers.Append("X-Client-IP","176.41.50.101");
        context.Request.Headers.Append("X-Client-Port","22576");
        context.Request.Headers.Append("X-Forwarded-For","176.41.50.101:22576");
        context.Request.Headers.Append("X-Forwarded-Proto","https");
        context.Request.Headers.Append("X-Forwarded-TlsVersion","1.3");
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

// app.UseMiddleware<CorrelationIdMiddleware>();
// app.UseMiddleware<RedisCacheTrackingMiddleware>();

app.UseLocalDemoTenantRouting();
app.MapDefaultEndpoints();
// app.Services.GetRequiredService<RedisCacheCoordinator>().SubscribeToRedisChannel();
//request pipeline
StartupBase.ConfigureRequestPipeline(app, builder.Environment);

//run app
app.Run();