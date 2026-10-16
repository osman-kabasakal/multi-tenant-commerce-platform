using Platform.Hosting;
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
app.UseTrustedProxy(app.Configuration);

var pathBase = Environment.GetEnvironmentVariable("PATH_BASE");
if (!string.IsNullOrEmpty(pathBase))
{
    app.UsePathBase(pathBase);
}
// app.UseMiddleware<CorrelationIdMiddleware>();
// app.UseMiddleware<RedisCacheTrackingMiddleware>();

app.UseLocalDemoTenantRouting();
app.MapDefaultEndpoints();
// app.Services.GetRequiredService<RedisCacheCoordinator>().SubscribeToRedisChannel();
//request pipeline
StartupBase.ConfigureRequestPipeline(app, builder.Environment);

//run app
app.Run();