using Authentication.Keycloak.Domains;
using Authentication.Keycloak.Models;
using Authentication.Keycloak.Services.RemoteUserManagement;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Events;
using Grand.Data;
using Grand.Domain;
using Grand.Domain.Customers;
using Grand.Domain.Media;
using Grand.Domain.Stores;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Events;
using Grand.Infrastructure.Migrations;
using Grand.Infrastructure.MultiTenant;
using Grand.Infrastructure.Plugins;
using Grand.Infrastructure.TypeSearch;
using Hangfire;
using MassTransit.Mediator;
using Microsoft.AspNetCore.Mvc.ModelBinding.Metadata;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Net.Http.Headers;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using StackExchange.Redis;
using System;
using System.Reflection;
using System.Text.Json;

namespace Authentication.Keycloak.MultitenantTasks;

public class PluginInstallerTaskService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;

    private readonly ILogger<PluginInstallerTaskService> _logger;

    private IConnectionMultiplexer _redis;
    private ISubscriber _subscriber;
    private bool _isConnected;
    private readonly SemaphoreSlim _connectionLock = new SemaphoreSlim(1, 1);

    private readonly RedisConfiguration _config;

    // private readonly string _tenantMigrationQueue = "tenant_migrations";
    // private readonly string _tenantApplinkQueue = "tenant_applinks";

    private readonly string NEW_BUILD_SUB_NAME = "NEW_BUILD_COMPLETED";
    

    public PluginInstallerTaskService(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
        TenantBackgroundTasks.ServiceProvider = serviceProvider;
        _logger = serviceProvider.GetRequiredService<ILogger<PluginInstallerTaskService>>();
        var configuration = serviceProvider.GetRequiredService<IConfiguration>();

        var config = new RedisConfig();
        configuration.GetSection("Redis").Bind(config);
        _config = new RedisConfiguration {
            ConnectionString = config.RedisPubSubConnectionString,
            Channel = "COMPLETED_MIGRATION"
        };
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var keycloakClient = _serviceProvider.GetRequiredService<IKeycloakService>().GetKeycloakClientAsync();
        var keycloakSetting = _serviceProvider.GetRequiredService<KeycloakSettings>();
        var cacheBase = _serviceProvider.GetRequiredService<ICacheBase>();
        try
        {
            var groups = await cacheBase.GetAsync("groups", async () =>
            {
                //TODO: bu listeyi tenant managerdan çekmem lazım
                return await keycloakClient.GetGroupHierarchyAsync(keycloakSetting.Realm,
                    cancellationToken: stoppingToken);
            });
            var tenantDbs = groups
                .Where(x => x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                            x.Attributes["StoreMongoConnectionString"].Count() > 0).Select(x => new DataSettings() {
                    ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
                    DbProvider = DbProvider.MongoDB
                }).ToList();

            foreach (var tenantDb in tenantDbs)
            {
                BackgroundJob.Enqueue(KeycloakAuthenticationDefaults.TenantMigrationQueue, () => TenantBackgroundTasks.RunForTenant(tenantDb));
            }

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    if (!_isConnected)
                    {
                        await ConnectToRedisAsync(stoppingToken);
                    }

                    // İşlemler devam ediyor, bağlantı kontrolü için bekleme
                    await Task.Delay(_config.ReconnectInterval, stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Redis pub/sub service error occurred");
                    _isConnected = false;
                    await Task.Delay(1000, stoppingToken); // Hata durumunda kısa bekleme
                }
            }
        }
        catch (System.Exception ex)
        {
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
        }
    }

    private async Task ConnectToRedisAsync(CancellationToken stoppingToken)
    {
        try
        {
            await _connectionLock.WaitAsync(stoppingToken);

            if (_isConnected) // Double-check locking
                return;

            int retryCount = 0;
            while (!_isConnected && retryCount < _config.MaxRetryAttempts && !stoppingToken.IsCancellationRequested)
            {
                try
                {
                    if (_redis != null)
                    {
                        await _redis.CloseAsync();
                        await _redis.DisposeAsync();
                    }

                    _redis = await ConnectionMultiplexer.ConnectAsync(_config.ConnectionString);
                    _subscriber = _redis.GetSubscriber();

                    // Bağlantı durumu değişikliklerini dinle
                    _redis.ConnectionFailed += OnConnectionFailed;
                    _redis.ConnectionRestored += OnConnectionRestored;

                    // Kanala abone ol
                    await SubscribeToChannelAsync();

                    _isConnected = true;
                    _logger.LogInformation("Successfully connected to Redis");
                }
                catch (Exception ex)
                {
                    retryCount++;
                    _logger.LogError(ex,
                        $"Failed to connect to Redis. Attempt {retryCount} of {_config.MaxRetryAttempts}");

                    if (retryCount < _config.MaxRetryAttempts)
                        await Task.Delay(_config.ReconnectInterval, stoppingToken);
                }
            }
        }
        finally
        {
            _connectionLock.Release();
        }
    }

    private async Task SubscribeToChannelAsync()
    {
        await _subscriber.SubscribeAsync(RedisChannel.Literal(_config.Channel), (channel, message) =>
        {
            try
            {
                ProcessMessageAsync(message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing message from Redis channel");
            }
        });
        
        

        _logger.LogInformation($"Subscribed to channel: {_config.Channel}");

        await _subscriber.SubscribeAsync(RedisChannel.Literal(NEW_BUILD_SUB_NAME), async (channel, message) =>
        {
            try
            {
                _logger.LogInformation("Received message: {0}", message);
                if (message.IsNull || message.IsNullOrEmpty)
                    return;
                var response = JsonSerializer.Deserialize<NewBuildRedisMessage>(message!);
                if (response != null)
                {
                    var cacheBase = _serviceProvider.GetRequiredService<ICacheBase>();
                    var keycloakClient = _serviceProvider.GetRequiredService<IKeycloakService>()
                        .GetKeycloakClientAsync();
                    var keycloakSetting = _serviceProvider.GetRequiredService<KeycloakSettings>();
                    await cacheBase.RemoveAsync("groups", false);

                    var groups = await cacheBase.GetAsync("groups", async () =>
                    {
                        //TODO: bu listeyi tenant managerdan çekmem lazım
                        return await keycloakClient.GetGroupHierarchyAsync(keycloakSetting.Realm);
                    });
                    var tenantDb = groups.FirstOrDefault(x =>
                        x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                        x.Attributes["StoreMongoConnectionString"].Count() > 0 && x.Name == response.StoreGroupName);
                    if (tenantDb == null)
                        return;

                    BackgroundJob.Enqueue(KeycloakAuthenticationDefaults.TenantApplinkQueue,
                        () => TenantBackgroundTasks.CreateTenantDeepLink(
                            new DataSettings() {
                                ConnectionString = tenantDb.Attributes["StoreMongoConnectionString"].First(),
                                DbProvider = DbProvider.MongoDB
                            }, response));
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing message from Redis channel");
            }
        });

        _logger.LogInformation($"Subscribed to channel: {NEW_BUILD_SUB_NAME}");
    }

    private void ProcessMessageAsync(RedisValue message)
    {
        // Mesaj işleme mantığınızı burada uygulayın
        _logger.LogInformation("Received message: {0}", message);
        if (message.IsNull || message.IsNullOrEmpty)
            return;
        var response = JsonSerializer.Deserialize<BasicResponseModel>(message!);
        if (response != null && response.IsSuccess && response.Message != null &&
            !string.IsNullOrEmpty(response.Message.MongoConnectionString))
        {
            BackgroundJob.Enqueue(KeycloakAuthenticationDefaults.TenantMigrationQueue, () => TenantBackgroundTasks.RunForTenant(new DataSettings {
                ConnectionString = response.Message.MongoConnectionString,
                DbProvider = DbProvider.MongoDB
            }));
        }
    }

    private void OnConnectionFailed(object? sender, ConnectionFailedEventArgs e)
    {
        _isConnected = false;
        _logger.LogError($"Redis connection failed: {e.FailureType} - {e.Exception?.Message}");
    }

    private void OnConnectionRestored(object? sender, ConnectionFailedEventArgs e)
    {
        _isConnected = true;
        _logger.LogInformation("Redis connection restored");
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        if (_redis != null)
        {
            await _subscriber.UnsubscribeAllAsync();
            await _redis.CloseAsync();
            await _redis.DisposeAsync();
        }

        await base.StopAsync(cancellationToken);
    }
}

public class TenantBackgroundTasks
{
    public static IServiceProvider ServiceProvider { get; set; }

    public static async Task RunForTenant(DataSettings tenantDb)
    {
        var logger = ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();

        var mongourl = new MongoUrl(tenantDb.ConnectionString);
        var databaseName = mongourl.DatabaseName;
        if (string.IsNullOrEmpty(databaseName))
            return;

        try
        {
            var database = new MongoClient(tenantDb.ConnectionString).GetDatabase(databaseName);
            var storeRepository = database.GetCollection<Store>(nameof(Store));
            var store = await storeRepository.AsQueryable()
                .FirstOrDefaultAsync();
            using (var scope = ServiceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
                       .CreateScopeWithReplacement(database,store?.Id))
            {
                var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                tenantIdentityAccessor.TenantId = store?.Id;
                var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
                dbContext.SetConnection(tenantDb.ConnectionString);
                if (!await dbContext.DatabaseExist())
                {
                    return;
                }

                await LoadPLuginsAsync(scope);
                await InstallMigrations(scope);
            }
        }
        catch (Exception e)
        {
            logger.LogError(e, "Error during migrations");
        }
    }

    private static Task InstallMigrations(IServiceScope scope)
    {
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();
        logger.LogInformation("Running migration process");
        try
        {
            var migrationProcess = scope.ServiceProvider.GetRequiredService<IMigrationProcess>();
            migrationProcess.RunMigrationProcess();
            var registeredPlugins = scope.ServiceProvider.GetRequiredService<ITypeSearcher>()
                .ClassesOfType<IPlugin>(onlyConcreteClasses: true);
            var pluginAsssemblies = registeredPlugins.Select(x => x.Assembly).ToList();
            var pluginMigrations = scope.ServiceProvider.GetRequiredService<ITypeSearcher>()
                .ClassesOfType(typeof(IMigration), pluginAsssemblies, onlyConcreteClasses: true).ToList();
            
            if(pluginMigrations.Any())
            {
                foreach (var pluginMigration in pluginMigrations.Select((m)=>(IMigration)Activator.CreateInstance(m)).Where(x=>x!=null).OrderBy(x=> x!.Priority).ToList())
                {
                    if (pluginMigration != null)
                    {
                        migrationProcess.RunProcess(pluginMigration);
                    }
                }
            }
            logger.LogInformation("migration process completed");
        }
        catch (System.Exception ex)
        {
            logger.LogError(ex, "Error occurred while running migration process");
        }

        return Task.CompletedTask;
    }

    private static async Task LoadPLuginsAsync(IServiceScope scope)
    {
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();
        var registeredPlugins = scope.ServiceProvider.GetRequiredService<ITypeSearcher>()
            .ClassesOfType<IPlugin>(onlyConcreteClasses: true);

        var pluginsInfo = registeredPlugins.Select(p =>
        {
            var info = p.Assembly.GetCustomAttribute<PluginInfoAttribute>();
            if (info == null)
                return null;
            if (info.SystemName == "Misc.MobileApp")
            {
                var debug = true;
            }
            logger.LogInformation($"Plugin {info.SystemName} is found");
            var plugin = new PluginInfo() {
                FriendlyName = info.FriendlyName,
                Group = info.Group,
                SystemName = info.SystemName,
                Version = info.Version,
                SupportedVersion = info.SupportedVersion,
                Author = info.Author,
                PluginType = p
            };

            return plugin;
        }).Where(p => p != null).ToList();

        //PluginManager.ReferencedPlugins.ToList();

        foreach (var pluginInfo in pluginsInfo)
        {
            var installedPLuginRepository = scope.ServiceProvider.GetRequiredService<IRepository<InstalledPlugin>>();
            var installedPlugin = installedPLuginRepository.Table.FirstOrDefault(x =>
                x.SystemName == pluginInfo.SystemName && x.Version == pluginInfo.Version);
            if (installedPlugin != null)
                continue;
            try
            {
                var plugin = pluginInfo.Instance(scope.ServiceProvider);
                await plugin.Install();

                await installedPLuginRepository.InsertAsync(new InstalledPlugin {
                    SystemName = pluginInfo.SystemName,
                    Version = pluginInfo.Version
                });

                // Mark the plugin as installed
                await PluginExtensions.MarkPluginAsInstalled(pluginInfo.SystemName);
                logger.LogInformation($"Plugin {pluginInfo.FriendlyName} has been installed");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error during installing plugin " + pluginInfo.SystemName,
                    ex.Message + " " + ex.InnerException?.Message);
            }
        }
    }

    public static async Task CreateTenantDeepLink(DataSettings tenantDb, NewBuildRedisMessage message)
    {
        try
        {
            var logger = ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();

            var mongourl = new MongoUrl(tenantDb.ConnectionString);
            var databaseName = mongourl.DatabaseName;
            if (string.IsNullOrEmpty(databaseName))
                return;

            try
            {
                var database = new MongoClient(tenantDb.ConnectionString).GetDatabase(databaseName);
                var storeRepository = database.GetCollection<Store>(nameof(Store));
                var store = await storeRepository.AsQueryable()
                    .FirstOrDefaultAsync();
                using (var scope = ServiceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
                           .CreateScopeWithReplacement(database,store?.Id))
                {
                    var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                    tenantIdentityAccessor.TenantId = store?.Id;
                    var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
                    dbContext.SetConnection(tenantDb.ConnectionString);
                    if (!await dbContext.DatabaseExist())
                    {
                        return;
                    }

                    if (message.Platform == BuildPlatform.Android)
                    {
                        await CreateAndroidApplinkAsync(scope, message);
                    }
                    else if (message.Platform == BuildPlatform.Ios)
                    {
                        await CreateIosApplinkAsync(scope, message);
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, "Error during migrations");
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    private static async Task CreateIosApplinkAsync(IServiceScope scope, NewBuildRedisMessage message)
    {
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();
        var fileService = scope.ServiceProvider.GetRequiredService<IDownloadService>();
        var downloadRepository = scope.ServiceProvider.GetRequiredService<IRepository<Download>>();
        var customerService = scope.ServiceProvider.GetRequiredService<ICustomerService>();
        var bgCustomer = await customerService.GetCustomerBySystemName(SystemCustomerNames.BackgroundTask);

        var iosUniversalLinkmodel = new IosUniversalLinkJsonModel {
            Applinks = new Applinks() {
                Details = [
                    new Detail() {
                        AppIDs = [message.IosAppId],
                        Components = [
                            new KeyValuePair<string, object>("/", "/*"),
                        ],
                        Paths = [
                            "*",
                        ]
                    }
                ],
            },
            Webcredentials = new Webcredentials() {
                Apps = [message.IosAppId]
            },
        };
        
        var applinkJson = JsonSerializer.Serialize(iosUniversalLinkmodel);
        var savedApplinkRecord = downloadRepository.Table.FirstOrDefault(x =>
            x.Filename == "apple-app-site-association" && x.Extension == ".json" && x.DownloadType == DownloadType.None);
        if (savedApplinkRecord != null)
        {
            await fileService.DeleteDownload(savedApplinkRecord);
        }
        
        await fileService.InsertDownload(new Download {
            DownloadGuid = Guid.NewGuid(),
            CustomerId = bgCustomer?.Id,
            UseDownloadUrl = false,
            DownloadUrl = "",
            DownloadBinary = Encoding.UTF8.GetBytes(applinkJson),
            ContentType = "application/json",
            Filename = "apple-app-site-association",
            Extension = ".json",
            DownloadType = DownloadType.None,
        });

        logger.LogInformation($"IosUniversalLink for {message.StoreGroupName} has been created");
    }

    private static async Task CreateAndroidApplinkAsync(IServiceScope scope, NewBuildRedisMessage message)
    {
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<TenantBackgroundTasks>>();
        var fileService = scope.ServiceProvider.GetRequiredService<IDownloadService>();
        var downloadRepository = scope.ServiceProvider.GetRequiredService<IRepository<Download>>();
        var customerService = scope.ServiceProvider.GetRequiredService<ICustomerService>();
        var bgCustomer = await customerService.GetCustomerBySystemName(SystemCustomerNames.BackgroundTask);
        var applinks = new List<AndroidApplinkJsonModel>();
        var applink = new AndroidApplinkJsonModel {
            Relation = [
                "delegate_permission/common.handle_all_urls"
            ],
            Target = new Target() {
                Namespace = "android_app",
                PackageName = message.PackageName,
                Sha256CertFingerprints = message.SigningKeysSHA256
            }
        };

        applinks.Add(applink);

        var applinkJson = JsonSerializer.Serialize(applinks);
        var savedApplinkRecord = downloadRepository.Table.FirstOrDefault(x =>
            x.Filename == "assetlinks" && x.Extension == ".json" && x.DownloadType == DownloadType.None);
        
        if (savedApplinkRecord != null)
        {
            await fileService.DeleteDownload(savedApplinkRecord);
        }
        
        await fileService.InsertDownload(new Download {
            DownloadGuid = Guid.NewGuid(),
            CustomerId = bgCustomer?.Id,
            UseDownloadUrl = false,
            DownloadUrl = "",
            DownloadBinary = Encoding.UTF8.GetBytes(applinkJson),
            ContentType = "application/json",
            Filename = "assetlinks",
            Extension = ".json",
            DownloadType = DownloadType.None,
        });

        logger.LogInformation($"AndroidApplinks for {message.StoreGroupName} has been created");
    }

}

