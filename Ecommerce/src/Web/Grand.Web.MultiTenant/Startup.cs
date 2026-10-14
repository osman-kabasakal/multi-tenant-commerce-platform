using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Constants.Hangfire;
using Grand.Business.Tenants.Extensions;
using Grand.Business.Tenants.Services.Hangfire;
using Grand.Infrastructure;
using Grand.Web.MultiTenant.Filters;
// using Grand.Web.MultiTenant.Middlewares;
using Grand.Web.MultiTenant.MiddleWares;
using Grand.Web.MultiTenant.Services;
using Hangfire;
using Hangfire.Mongo;
using Hangfire.Mongo.Migration.Strategies;
using Hangfire.Mongo.Migration.Strategies.Backup;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using System;
using System.Threading;
using System.Threading.Tasks;
using static Grand.Web.MultiTenant.Filters.ProductCacheRelationFilterAttribute;

namespace Grand.Web.MultiTenant;

/// <summary>
/// Uygulama başlangıç konfigürasyonu
/// </summary>
public class Startup : IStartupApplication
{
    public int Priority => 501;

    public bool BeforeConfigure => true;

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        // application.UseMiddleware<ReleatedCacheKeysMiddleware>();
        
        // WebSocket desteğini etkinleştir
        // application.UseWebSockets(new Microsoft.AspNetCore.Builder.WebSocketOptions
        // {
        //     KeepAliveInterval = TimeSpan.FromMinutes(2),
        //     AllowedOrigins = { "*" } // Güvenlik gereksinimlerine göre ayarlanabilir
        // });
// WebSocket servisleri için middleware
        // application.UseMiddleware<WebSocketServiceMiddleware>();
        
        // Eski middleware'i kaldırıp yeni Redis tabanlı middleware'i ekle
        application.UseMiddleware<RedisCacheTrackingMiddleware>();
        
        // Uygulama kapatılırken bekleyen cache işlemlerinin temiz kapatılması
        var appLifetime = application.ApplicationServices.GetRequiredService<IHostApplicationLifetime>();
        var logger = application.ApplicationServices.GetRequiredService<ILogger<Startup>>();
        
        appLifetime.ApplicationStopping.Register(async () => 
        {
            logger.LogInformation("Application stopping: waiting for pending cache tasks to complete");
            
            try 
            {
                // Bekleyen cache işlemlerinin tamamlanmasını bekle (max 5 saniye)
                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
                await ProductCacheRelationFilter.WaitForPendingTasksAsync(cts.Token);
            }
            catch (Exception ex) 
            {
                logger.LogWarning(ex, "Error waiting for pending cache tasks during shutdown");
            }
        });
    }

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Global MVC filtresi olarak ProductCacheRelationFilter'ı ekle
        services.Configure<MvcOptions>(options =>
        {
            options.Filters.Add<ProductCacheRelationFilterAttribute>();
        });

        services.AddScoped<PublicRouteService>();

        // services.AddScopedServiceProvider<IMongoDatabase>();
        //
        //
        // GlobalJobFilters.Filters.Add(new AutomaticRetryAttribute {
        //     Attempts = 3,
        //     OnAttemptsExceeded = AttemptsExceededAction.Delete
        // });
        //
        // GlobalJobFilters.Filters.Add(new MultitenantBackgroundTaskFilter(services.BuildServiceProvider().GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()));
        //
        // services.AddHangfire(config =>
        // {
        //     var mongoUrlBuilder = new MongoUrlBuilder(configuration["Database:ConnectionString"]);
        //     var mongoClient = new MongoClient(mongoUrlBuilder.ToMongoUrl());
        //     
        //     config.SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
        //         .UseSimpleAssemblyNameTypeSerializer()
        //         .UseRecommendedSerializerSettings()
        //         .UseMongoStorage(mongoClient, mongoUrlBuilder.DatabaseName, new MongoStorageOptions {
        //             MigrationOptions = new MongoMigrationOptions {
        //                 MigrationStrategy = new MigrateMongoMigrationStrategy(),
        //                 BackupStrategy = new CollectionMongoBackupStrategy()
        //             },
        //             Prefix = "frontend.hangfire",
        //             CheckConnection = true
        //         });
        // });
        //
        // services.AddHangfireServer(options =>
        // {
        //     options.Queues = new[] { HangfireConstants.FrontendQueue,HangfireConstants.SendMessageQueue,HangfireConstants.AddCorrelationCacheKeyQueue };
        //     options.WorkerCount = Environment.ProcessorCount * 2;
        //     options.StopTimeout = TimeSpan.FromMinutes(180);
        //     options.ServerTimeout = TimeSpan.FromMinutes(180);
        //     options.ShutdownTimeout = TimeSpan.FromMinutes(180);
        //     options.ServerName = $"TenantManager-{Environment.MachineName}";
        // });
    }
}
