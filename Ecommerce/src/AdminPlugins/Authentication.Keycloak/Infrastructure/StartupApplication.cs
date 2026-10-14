using Authentication.Keycloak.MultitenantTasks;
using Authentication.Keycloak.Services.AuthenticationServices;
using Authentication.Keycloak.Services.JwtValidationServices;
using Authentication.Keycloak.Services.RemoteUserManagement;
using Authentication.Keycloak.Tasks;
using Azure.Security.KeyVault.Secrets;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Data;
using Grand.Infrastructure;
using Grand.Infrastructure.Plugins;
using Grand.Infrastructure.TypeSearch;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.View;
using Hangfire;
using Hangfire.Mongo;
using Hangfire.Mongo.Migration.Strategies;
using Hangfire.Mongo.Migration.Strategies.Backup;
using Hangfire.Storage.Monitoring;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Razor;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Net.Http.Headers;
using MongoDB.Driver;

namespace Authentication.Keycloak.Infrastructure;

public class StartupApplication : IStartupApplication
{
    public int Priority => 10;
    public bool BeforeConfigure => false;
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        ((ConfigurationManager)configuration).AddJsonFile(Path.Combine(CommonPath.PluginsPath,
            KeycloakAuthenticationDefaults.ProviderSystemName, "appsettings.keycloak.json"));
        var azureKeyVaultClient = services.BuildServiceProvider().GetRequiredService<SecretClient>();

        services.AddScoped<IWidgetProvider, SigninButtonWidgetProvider>();
        services.Configure<AuthConfiguration>(instance =>
        {
            configuration.GetSection("AuthConfiguration").Bind(instance);
            instance.ClientSecret = azureKeyVaultClient.GetSecret($"ClientSecret-{instance.ClientId}").Value.Value;
        });
        services.AddSingleton<LogoutSessionManager>();
        services.AddHttpClient();

        services.AddScoped<IAreaViewFactory, PluginViewFactory>();

        services.AddTransient<OpnIdConnectGrandAuthenticationService>();

        services.AddTransient<KeyCloakJwtValidationService>();

        services.Configure<RazorViewEngineOptions>(options =>
        {
            options.ViewLocationExpanders.Add(new PluginViewFactory());
        });

        var conf = new KeycloakSettings();
        configuration.GetSection("KeyCloakServiceClient").Bind(conf);
        conf.ClientSecret = azureKeyVaultClient.GetSecret($"ClientSecret-{conf.ClientId}").Value.Value;
        services.AddSingleton(conf);
        services.Configure<KeycloakSettings>(configuration.GetSection("KeyCloakServiceClient"));

        services.AddScoped<IKeycloakService, KeycloakService>();
        services.AddScoped<IKeycloakUserService, KeycloakUserService>();

        // services.AddScopedServiceProvider<IMongoDatabase>();

        var typeSearcher = new TypeSearcher();
        //ignore not installed plugins

        services.AddTransient<IScheduleTask, StaleCacheKeyCleanerTask>();
        
        

        if (configuration["MultitenantTask:Enabled"] == null 
        || bool.Parse(configuration["MultitenantTask:Enabled"]!.ToString()))
        {
            
            services.AddSingleton<IHostedService, PluginInstallerTaskService>(sp =>
                new PluginInstallerTaskService(sp));
            
            services.AddSingleton<IHostedService, MultitenantBackgroundTaskService>();

            GlobalJobFilters.Filters.Add(new AutomaticRetryAttribute {
                Attempts = 3,
                OnAttemptsExceeded = AttemptsExceededAction.Delete
            });

            GlobalJobFilters.Filters.Add(new MultitenantBackgroundTaskFilter(services.BuildServiceProvider().GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()));

            services.AddHangfire(config =>
            {
                var mongoUrlBuilder = new MongoUrlBuilder(configuration["Database:ConnectionString"]);
                var mongoClient = new MongoClient(mongoUrlBuilder.ToMongoUrl());
                var db = mongoClient.GetDatabase(mongoUrlBuilder.DatabaseName);
                var hangfirecollections = db.ListCollectionNames().ToList().Where((cn) => cn.StartsWith("hangfire.mongo"));
                foreach (var collection in hangfirecollections)
                {
                    db.DropCollection(collection);
                }
                config.SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
                    .UseSimpleAssemblyNameTypeSerializer()
                    .UseRecommendedSerializerSettings()
                    
                    .UseMongoStorage(mongoClient, mongoUrlBuilder.DatabaseName, new MongoStorageOptions {
                        MigrationOptions = new MongoMigrationOptions {
                            MigrationStrategy = new MigrateMongoMigrationStrategy(),
                            BackupStrategy = new CollectionMongoBackupStrategy()
                        },
                        Prefix = "hangfire.mongo",
                        CheckConnection = true
                    });
            });

            services.AddHangfireServer(options =>
            {
                options.Queues = new[] { "default", MultitenantBackgroundTaskService.TenantTaskQueue,KeycloakAuthenticationDefaults.TenantApplinkQueue,KeycloakAuthenticationDefaults.TenantMigrationQueue };
                options.WorkerCount = Environment.ProcessorCount * 2;
                options.StopTimeout = TimeSpan.FromMinutes(180);
                options.ServerTimeout = TimeSpan.FromMinutes(180);
                options.ShutdownTimeout = TimeSpan.FromMinutes(180);
                options.ServerName = $"TenantManager-{Environment.MachineName}";
            });
        }
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        application.UseStatusCodePages(async (context) =>
        {
            if (context.HttpContext.Response.StatusCode == 404)
            {
                string authHeader = context.HttpContext.Request.Headers[HeaderNames.Authorization];
                var apiRequest = authHeader != null &&
                                 authHeader.Split(' ')[0] == JwtBearerDefaults.AuthenticationScheme;

                var contentTypeProvider = new FileExtensionContentTypeProvider();
                var staticResource = contentTypeProvider.TryGetContentType(context.HttpContext.Request.Path, out _);

                if (!apiRequest && !staticResource)
                {
                    const string location = "/Admin";
                    context.HttpContext.Response.Redirect(context.HttpContext.Request.PathBase + location);
                }
            }
        });
    }
}

public class AuthConfiguration
{
    public string IdentityProviderUrl { get; set; } = string.Empty;
    public string Audience { get; set; } = string.Empty;
    public string ClientSecret { get; set; } = string.Empty;
    public string ClientId { get; set; } = String.Empty;
}