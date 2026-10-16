using Platform.Hosting;
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
app.UseTrustedProxy(app.Configuration);
// app.Services.GetRequiredService<RedisCacheCoordinator>().SubscribeToRedisChannel();
var pathBase = Environment.GetEnvironmentVariable("PATH_BASE");
if (!string.IsNullOrEmpty(pathBase))
{
    app.UsePathBase(pathBase);
}
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