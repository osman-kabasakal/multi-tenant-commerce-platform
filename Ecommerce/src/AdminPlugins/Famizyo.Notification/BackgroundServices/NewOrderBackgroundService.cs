using Famizyo.Notification.Hubs;
using Famizyo.Notification.Services;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Events;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Stores;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.MultiTenant;
using Hangfire;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using StackExchange.Redis;
using System.Text.Json;

namespace Famizyo.Notification.BackgroundServices;


public class NewOrderRedisMessage
{
    public string StoreId { get; set; }
    public string OrderId { get; set; }
}
public class NewOrderBackgroundService: BackgroundService
{
    private readonly IServiceProvider _serviceProvider;

    public NewOrderBackgroundService(
        IServiceProvider serviceProvider
        )
    {
        _serviceProvider = serviceProvider;
        _logger = serviceProvider.GetRequiredService<ILogger<NewOrderBackgroundService>>();
        ConnectionString = serviceProvider.GetRequiredService<RedisConfig>().RedisPubSubConnectionString;
    }
    
    private IConnectionMultiplexer _redis;
    private ISubscriber _subscriber;
    private bool _isConnected;
    private readonly SemaphoreSlim _connectionLock = new SemaphoreSlim(1, 1);

    private readonly ILogger<NewOrderBackgroundService> _logger;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                if (!_isConnected)
                {
                    await ConnectToRedisAsync(stoppingToken);
                }

                // İşlemler devam ediyor, bağlantı kontrolü için bekleme
                await Task.Delay(ReconnectInterval, stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Redis pub/sub service error occurred");
                _isConnected = false;
                await Task.Delay(1000, stoppingToken); // Hata durumunda kısa bekleme
            }
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
            while (!_isConnected && retryCount < MaxRetryAttempts && !stoppingToken.IsCancellationRequested)
            {
                try
                {
                    if (_redis != null)
                    {
                        await _redis.CloseAsync();
                        await _redis.DisposeAsync();
                    }

                    _redis = await ConnectionMultiplexer.ConnectAsync(ConnectionString);
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
                        $"Failed to connect to Redis. Attempt {retryCount} of {MaxRetryAttempts}");

                    if (retryCount < MaxRetryAttempts)
                        await Task.Delay(ReconnectInterval, stoppingToken);
                }
            }
        }
        finally
        {
            _connectionLock.Release();
        }
    }
    private readonly string NEW_ORDER_SUB_NAME = "NEW_ORDER";
    private async Task SubscribeToChannelAsync()
    {
        await _subscriber.SubscribeAsync(RedisChannel.Literal(NEW_ORDER_SUB_NAME), async (channel, message) =>
        {
            try
            {
                _logger.LogInformation("Received message: {0}", message);
                if (message.IsNull || message.IsNullOrEmpty)
                    return;
                var response = JsonSerializer.Deserialize<NewOrderRedisMessage>(message!);
                if (response != null && !string.IsNullOrEmpty(response.StoreId) && !string.IsNullOrEmpty(response.OrderId))
                {
                    var cacheBase = _serviceProvider.GetRequiredService<ICacheBase>();
                    var keycloakClient = _serviceProvider.GetRequiredService<IKeycloakClientService>()
                        .GetKeycloakClientAsync();
                    var keycloakSetting = _serviceProvider.GetRequiredService<KeycloakSettings>();
                    
                    var groups = await cacheBase.GetAsync("groups", async () =>
                    {
                        //TODO: bu listeyi tenant managerdan çekmem lazım
                        return await keycloakClient.GetGroupHierarchyAsync(keycloakSetting.Realm);
                    });
                    var tenantDb = groups.FirstOrDefault(x =>
                        x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                        x.Attributes["StoreMongoConnectionString"].Any() && 
                        x.Attributes.ContainsKey("StoreId") && 
                        x.Attributes["StoreId"].FirstOrDefault() == response.StoreId);
                    if (tenantDb == null)
                        return;

                    await PublishNewOrder(
                        new DataSettings() {
                            ConnectionString = tenantDb.Attributes["StoreMongoConnectionString"].First(),
                            DbProvider = DbProvider.MongoDB
                        }, response);

                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing message from Redis channel");
            }
        });
    }
    
    private async Task PublishNewOrder(DataSettings dataSettings, NewOrderRedisMessage response)
    {
        
        try
        {
            var logger = _serviceProvider.GetRequiredService<ILogger<NewOrderBackgroundService>>();

            var mongourl = new MongoUrl(dataSettings.ConnectionString);
            var databaseName = mongourl.DatabaseName;
            if (string.IsNullOrEmpty(databaseName))
                return;

            try
            {
                var database = new MongoClient(dataSettings.ConnectionString).GetDatabase(databaseName);
                
               
                using (var scope = _serviceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
                           .CreateScopeWithReplacement(database,response.StoreId))
                {
                    var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                    tenantIdentityAccessor.TenantId = response.StoreId;
                    var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
                    dbContext.SetConnection(dataSettings.ConnectionString);
                    if (!await dbContext.DatabaseExist())
                    {
                        return;
                    }
                    
                    var orderRepository = scope.ServiceProvider.GetRequiredService<IRepository<Grand.Domain.Orders.Order>>();
                    var order = await orderRepository.Table.FirstOrDefaultAsync(x => x.Id == response.OrderId);
                    
                    if (order == null)
                        return;
                        
                    // Create or retrieve notification entry
                    var orderNotificationService = scope.ServiceProvider.GetRequiredService<IOrderNotificationService>();
                    var notification = await orderNotificationService.GetNotificationByOrderIdAsync(order.Id);
                    
                    if (notification == null)
                    {
                        // Create a new notification if it doesn't exist
                        notification = await orderNotificationService.CreateOrderNotificationAsync(
                            order.Id, response.StoreId);
                    }
                    else
                    {
                        // Update the send count
                        await orderNotificationService.IncrementSendCountAsync(notification.Id);
                    }

                    var hub = _serviceProvider.GetRequiredService<IHubContext<NotificationHub>>();
                    var groupName = string.Format(NotificationDefaults.NotificationGroupFormat, response.StoreId,
                        NotificationDefaults.NotificationNewOrderGroupName);
                        
                    // Send notification with both order ID and notification ID for tracking
                    await hub.Clients.Group(groupName)
                        .SendAsync(NotificationDefaults.NotificationClientNewOrderMethodName, 
                            order.Id,
                            notification.Id,
                            cancellationToken: CancellationToken.None);
                    // var mediator= scope.ServiceProvider.GetRequiredService<IMediator>();
                    // await mediator.Publish(new NewTenantOrderEvent(order), CancellationToken.None);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                logger.LogError(e,"Error new order event");
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
        }
    }

    public string ConnectionString { get; set; }

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

    public int ReconnectInterval { get; set; } = 5000;

    public int MaxRetryAttempts { get; set; } = 5;
}
