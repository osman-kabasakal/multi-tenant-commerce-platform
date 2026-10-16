using Platform.Hosting;
using Platform.Security;
using Azure.Extensions.AspNetCore.Configuration.Secrets;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Grand.Business.Tenants.Services.TenantServiceProvider;
using Grand.Data;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.MultiTenant;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.Extensions;
using Grand.Web.ExternalSettings.TenantToken;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;
using StackExchange.Redis;
using System.Reflection;

namespace Grand.Web.ExternalSettings.Extensions;

public static class ServiceDefaults
{
    public static IHostApplicationBuilder AddServiceDefaults(this IHostApplicationBuilder builder, string dbConnectionConnectionString=null)
    {
        builder.ConfigureSharedConfiguration(dbConnectionConnectionString);
        
        builder.ConfigureOpenTelemetry();

        builder.AddDefaultHealthChecks();

        builder.Services.AddServiceDiscovery();

        builder.Services.ConfigureHttpClientDefaults(http =>
        {
            // Turn on resilience by default
            http.AddStandardResilienceHandler();

            // Turn on service discovery by default
            http.AddServiceDiscovery();
        });
        
        
        //add configuration
        builder.Configuration.AddAppSettingsJsonFile([$"appsettings={builder.Environment.EnvironmentName}"]);
        builder.Services.AddTrustedProxy(builder.Configuration);
        
        var configValues = new Dictionary<string, string>
        {
            {"TenantServiceScopeConfig:IsBackgroundScope", "false"},
        };
        builder.Configuration.AddInMemoryCollection(configValues);
        builder.Services.Configure<TenantServiceScopeConfig>(builder.Configuration.GetSection("TenantServiceScopeConfig"));

        builder.Services.AddSingleton<ITenantIdentityAccessor, TenantIdentityAccessor>();

        var config = new RedisConfig();
        builder.Configuration.GetSection("Redis").Bind(config);
        builder.Services.AddSingleton<IDatabase>((_)=> ConnectionMultiplexer.Connect(config.RedisPubSubConnectionString).GetDatabase());
        builder.Services.AddScoped<ITenantTokenHandler,TenantTokenHandler>();
        
        // Add tenant-specific data protection
        builder.Services.AddTenantAwareDataProtection(builder.Configuration);
        
        return builder;
    }

    public static IHostApplicationBuilder ConfigureSharedConfiguration(this IHostApplicationBuilder builder, string dbConnectionConnectionString=null)
    {
        var deploymentConfig = builder.Configuration["PlatformConfiguration:ConfigPath"];
        if (!string.IsNullOrWhiteSpace(deploymentConfig)) builder.Configuration.AddJsonFile(deploymentConfig,optional:false);
        var localConfig = builder.Configuration["LocalDemo:ConfigPath"];
        if (!string.IsNullOrEmpty(localConfig)) builder.Configuration.AddJsonFile(localConfig, optional: false);
        builder.Configuration.AddEnvironmentVariables();
        if (builder.Configuration.GetValue<bool>("LocalDemo:Enabled"))
        {
            if (!builder.Environment.IsDevelopment())
                throw new InvalidOperationException("LocalDemo is allowed only in Development.");
            var template = Path.Combine(AppContext.BaseDirectory, CommonPath.AppData, "appsettingstemplate.json");
            builder.Configuration.AddJsonFile(template, optional: false);
            builder.Configuration.AddJsonFile(localConfig, optional: false);
            builder.Configuration.AddEnvironmentVariables();
            if (dbConnectionConnectionString != null)
                builder.Configuration["Database:ConnectionString"] = dbConnectionConnectionString;
            Directory.CreateDirectory(Path.Combine(CommonPath.BaseDirectory, CommonPath.AppData));
            // The legacy loader expects this file; demo configuration remains in the ignored .local directory.
            File.WriteAllText(Path.Combine(CommonPath.BaseDirectory, CommonPath.AppData, "appsettings.json"), "{}");
            builder.Services.AddPlatformSecurity(builder.Configuration, builder.Environment.EnvironmentName);
            using var bootstrap = builder.Services.BuildServiceProvider();
            var store = bootstrap.GetRequiredService<ISecretStore>();
            if (!builder.Configuration.GetValue<bool>("PlatformSecurity:ReadOnly"))
                foreach (var item in builder.Configuration.GetSection("PlatformSecurity:BootstrapSecrets").GetChildren())
                    store.GetOrCreateAsync("system", item.Key, () => item.Value!).GetAwaiter().GetResult();
            return builder;
        }
        var configurationProvider = builder.Configuration["PlatformConfiguration:Provider"]
            ?? (string.IsNullOrWhiteSpace(builder.Configuration.GetConnectionString("kvUri")) ? "Environment" : "AzureKeyVault");
        if (configurationProvider == "Environment")
        {
            var supplied = builder.Configuration.AsEnumerable().Where(x => x.Value != null).ToArray();
            builder.Configuration.AddJsonFile(Path.Combine(AppContext.BaseDirectory, CommonPath.AppData, "appsettingstemplate.json"), optional: false);
            builder.Configuration.AddInMemoryCollection(supplied);
            var configPath = builder.Configuration["PlatformConfiguration:ConfigPath"];
            if (!string.IsNullOrWhiteSpace(configPath)) builder.Configuration.AddJsonFile(configPath, optional: false);
            builder.Configuration.AddEnvironmentVariables();
            if (dbConnectionConnectionString != null) builder.Configuration["Database:ConnectionString"] = dbConnectionConnectionString;
            foreach (var required in new[] { "Database:ConnectionString", "Redis:RedisPubSubConnectionString", "Redis:PersistKeysToRedisUrl" })
                if (string.IsNullOrWhiteSpace(builder.Configuration[required]) || builder.Configuration[required]!.Contains('~'))
                    throw new InvalidOperationException($"Configure {required} for the portable deployment.");
            Directory.CreateDirectory(Path.Combine(CommonPath.BaseDirectory, CommonPath.AppData));
            // Required by the legacy loader; no credentials are written into this compatibility file.
            File.WriteAllText(Path.Combine(CommonPath.BaseDirectory, CommonPath.AppData, "appsettings.json"), "{}");
            builder.Services.AddPlatformSecurity(builder.Configuration, builder.Environment.EnvironmentName);
            using var bootstrap = builder.Services.BuildServiceProvider();
            var store = bootstrap.GetRequiredService<ISecretStore>();
            if (!builder.Configuration.GetValue<bool>("PlatformSecurity:ReadOnly"))
                foreach (var item in builder.Configuration.GetSection("PlatformSecurity:BootstrapSecrets").GetChildren())
                    store.GetOrCreateAsync("system", item.Key, () => item.Value!).GetAwaiter().GetResult();
            return builder;
        }
        if (configurationProvider != "AzureKeyVault") throw new InvalidOperationException("Unknown PlatformConfiguration provider.");
        var client = new SecretClient(new Uri(builder.Configuration.GetConnectionString("kvUri")), new DefaultAzureCredential(new DefaultAzureCredentialOptions() {
            AdditionallyAllowedTenants = {
                "*"
            }
        }) {
            
        });

        builder.Services.AddSingleton(client);

        var appSettingTemplatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
            CommonPath.AppData, "appsettingstemplate.json");

        var appSettingPath = Path.Combine(CommonPath.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
            CommonPath.AppData, "appsettings.json");

        var appSettingsString = File.ReadAllText(appSettingTemplatePath);
        appSettingsString = appSettingsString
            .Replace("~mongoconnectionstring~", dbConnectionConnectionString??client.GetSecret("applicationdb").Value.Value)
            .Replace("~redisconnectionstring~", client.GetSecret("redispublisher").Value.Value)
            .Replace("~rediskeyconnectionstring~", client.GetSecret("redispublisher").Value.Value);
        
        builder.Configuration.AddUserSecrets(Assembly.GetExecutingAssembly());
        
        builder.Configuration.AddAzureKeyVault(client, new KeyVaultSecretManager());
        
        File.WriteAllText(appSettingPath,appSettingsString);

        var envSettingsTemplatePath = Path.Combine(
            AppDomain.CurrentDomain.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
            CommonPath.AppData, $"appsettingstemplate.{builder.Environment.EnvironmentName}.json");

        if (File.Exists(envSettingsTemplatePath))
        {
            var envSettingsString = File.ReadAllText(envSettingsTemplatePath);
            envSettingsString = envSettingsString
                .Replace("~mongoconnectionstring~", dbConnectionConnectionString??client.GetSecret("applicationdb").Value.Value)
                .Replace("~redisconnectionstring~", client.GetSecret("redispublisher").Value.Value)
                .Replace("~rediskeyconnectionstring~", client.GetSecret("redispublisher").Value.Value);
            
            if (!Directory.Exists(Path.Combine(
                    CommonPath.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
                    CommonPath.AppData,builder.Environment.EnvironmentName)))
            {
                Directory.CreateDirectory(Path.Combine(
                    CommonPath.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
                    CommonPath.AppData, builder.Environment.EnvironmentName));
            }
            
            File.WriteAllText(Path.Combine(
                CommonPath.BaseDirectory.Replace("wwwroot", "").Replace("//", "/"),
                CommonPath.AppData, builder.Environment.EnvironmentName,"appsettings.json"),envSettingsString);
            
            builder.Configuration["appsettings"]=builder.Environment.EnvironmentName;
        }

        builder.Services.AddPlatformSecurity(builder.Configuration, builder.Environment.EnvironmentName);
        return builder;
    }

    public static IHostApplicationBuilder ConfigureOpenTelemetry(this IHostApplicationBuilder builder)
    {
        builder.Logging.AddOpenTelemetry(logging =>
        {
            logging.IncludeFormattedMessage = true;
            logging.IncludeScopes = true;
        });

        builder.Services.AddOpenTelemetry()
            .WithMetrics(metrics =>
            {
                metrics.AddAspNetCoreInstrumentation()
                    .AddHttpClientInstrumentation()
                    .AddRuntimeInstrumentation();
            })
            .WithTracing(tracing =>
            {
                tracing.AddAspNetCoreInstrumentation()
                    // Uncomment the following line to enable gRPC instrumentation (requires the OpenTelemetry.Instrumentation.GrpcNetClient package)
                    //.AddGrpcClientInstrumentation()
                    .AddHttpClientInstrumentation();
            });

        builder.AddOpenTelemetryExporters();

        return builder;
    }

    private static IHostApplicationBuilder AddOpenTelemetryExporters(this IHostApplicationBuilder builder)
    {
        var useOtlpExporter = !string.IsNullOrWhiteSpace(builder.Configuration["OTEL_EXPORTER_OTLP_ENDPOINT"]);

        if (useOtlpExporter)
        {
            builder.Services.AddOpenTelemetry().UseOtlpExporter();
        }

        // Uncomment the following lines to enable the Azure Monitor exporter (requires the Azure.Monitor.OpenTelemetry.AspNetCore package)
        //if (!string.IsNullOrEmpty(builder.Configuration["APPLICATIONINSIGHTS_CONNECTION_STRING"]))
        //{
        //    builder.Services.AddOpenTelemetry()
        //       .UseAzureMonitor();
        //}

        return builder;
    }

    public static IHostApplicationBuilder AddDefaultHealthChecks(this IHostApplicationBuilder builder)
    {
        // var connection = DataSettingsManager.LoadSettings();
        builder.Services.AddHealthChecks()
            // Add a default liveness check to ensure app is responsive
            .AddCheck("self", () => HealthCheckResult.Healthy(), ["live"]);
            // .AddMongoDb(connection.ConnectionString,
            //     name: "mongodb-check",
            //     tags: new[] { "mongodb" });

        return builder;
    }

    public static WebApplication MapDefaultEndpoints(this WebApplication app)
    {
        // Adding health checks endpoints to applications in non-development environments has security implications.
        // See https://aka.ms/dotnet/aspire/healthchecks for details before enabling these endpoints in non-development environments.
        if (app.Environment.IsDevelopment())
        {
            // All health checks must pass for app to be considered ready to accept traffic after starting
            app.MapHealthChecks("/health");

            // Only health checks tagged with the "live" tag must pass for app to be considered alive
            app.MapHealthChecks("/alive", new HealthCheckOptions
            {
                Predicate = r => r.Tags.Contains("live")
            });
        }

        return app;
    }
}