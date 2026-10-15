using FirebaseAdmin.Messaging;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Data;
using Grand.Domain.PushNotifications;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.MultiTenant;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using StackExchange.Redis;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace Grand.Business.Marketing.Services.PushNotifications
{
    /// <summary>
    /// Redis kuyruktan FCM bildirimlerini işleyip gönderen servis
    /// </summary>
    /// disabled
    public class RedisFCMNotificationService : BackgroundService
    {
        private readonly IConnectionMultiplexer _redis;

        private readonly ILogger<RedisFCMNotificationService> _logger;

        // private readonly IPushNotificationsService _pushNotificationsService;
        // private readonly FirebaseService _firebaseService;
        private readonly IServiceProvider _serviceProvider;
        private readonly IKeycloakClientService _keycloakClientService;
        private readonly KeycloakSettings _keycloakSettings;
        private readonly ICacheBase _cacheBase;
        private readonly TimeSpan _processingInterval = TimeSpan.FromSeconds(3);
        private readonly TimeSpan _errorRetryDelay = TimeSpan.FromSeconds(5);
        private readonly int _maxBatchSize = 1000;

        public RedisFCMNotificationService(
            IConnectionMultiplexer redis,
            ILogger<RedisFCMNotificationService> logger,
            // IPushNotificationsService pushNotificationsService,
            IServiceProvider serviceProvider,
            IKeycloakClientService keycloakClientService,
            KeycloakSettings keycloakSettings,
            ICacheBase cacheBase
        )
        {
            _redis = redis;
            _logger = logger;
            // _pushNotificationsService = pushNotificationsService;
            // _firebaseService = firebaseService;
            _serviceProvider = serviceProvider;
            _keycloakClientService = keycloakClientService;
            _keycloakSettings = keycloakSettings;
            _cacheBase = cacheBase;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Redis FCM Notification Service starting");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    // FCM kuyruğundan bekleyen bildirimleri işle
                    var batchCount = await ProcessFCMQueue(stoppingToken);

                    // Eğer hiç bildirim işlemediyse biraz bekle
                    if (batchCount == 0)
                    {
                        await Task.Delay(_processingInterval, stoppingToken);
                    }
                }
                catch (OperationCanceledException)
                {
                    // Servis durdurulduğunda beklenen exception
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing FCM notification queue");
                    await Task.Delay(_errorRetryDelay, stoppingToken);
                }
            }

            _logger.LogInformation("Redis FCM Notification Service stopping");
        }

        /// <summary>
        /// FCM bildirim kuyruğunu işle
        /// </summary>
        private async Task<int> ProcessFCMQueue(CancellationToken cancellationToken)
        {
            var db = _redis.GetDatabase();
            var processedCount = 0;

            var fcmQueueLength = await db.ListLengthAsync("fcm:queue");
            if (fcmQueueLength == 0)
            {
                return processedCount;
            }

            //FCM batch
            var pendingNotificationKeys = await db.ListLeftPopAsync("fcm:queue", fcmQueueLength);
            if (pendingNotificationKeys.Length == 0)
                return processedCount;

            var fcmQueueBatch = db.CreateBatch();
            var pendingNotificationKeysDatas = new ConcurrentDictionary<RedisValue, Task<RedisValue>>();
            foreach (var pendingNotificationKey in pendingNotificationKeys)
            {
                // Pending notification bilgilerini al
                if (pendingNotificationKey.IsNullOrEmpty || pendingNotificationKeysDatas.ContainsKey(pendingNotificationKey))
                {
                    continue;
                }

                pendingNotificationKeysDatas.TryAdd(pendingNotificationKey,
                    fcmQueueBatch.StringGetAsync(pendingNotificationKey.ToString()));
            }

            fcmQueueBatch.Execute();

            // var deleteTaskList = new List<Task>();
            // var taskPool = new List<Task>();

            // var pendingNotificationBatch = db.CreateBatch();

            var wsNotificationQueList = new List<string> { };

            foreach (var (pendingNotificationKey, pendingDataTask) in pendingNotificationKeysDatas)
            {
                try
                {
                    var pendingData = await pendingDataTask;
                    if (pendingData.IsNullOrEmpty)
                        continue;

                    var notification =
                        JsonSerializer.Deserialize<RedisCacheCoordinator.PendingFcmNotification>(pendingData);

                    // Bildirimi işle
                    var queueItem = await ProcessPendingNotification(notification);

                    if (queueItem != RedisValue.Null)
                        wsNotificationQueList.Add(queueItem);

                    processedCount++;

                    // Bildirimi Redis'ten sil
                    await db.KeyDeleteAsync(pendingNotificationKey.ToString());
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing FCM notification key: {Key}", pendingNotificationKey);

                    // Hata durumunda bildirimi kuyruğun sonuna tekrar ekle
                    if (!pendingNotificationKey.IsNullOrEmpty)
                    {
                        await db.ListRemoveAsync("fcm:queue", pendingNotificationKey);
                        await db.ListRightPushAsync("fcm:queue", pendingNotificationKey,When.Always);
                    }
                }
            }

            // fcmQueueBatch.Execute();
            // await Task.WhenAll(deleteTaskList);

            if (wsNotificationQueList.Count > 0)
            {
                foreach (var queKey in wsNotificationQueList)
                {
                    await db.ListRightPushAsync("ws:notifications", queKey);
                }
            }

            return processedCount;
        }

        /// <summary>
        /// Bekleyen bildirimi işle ve FCM olarak gönder
        /// WebSocket entegrasyonu ile aktif kullanıcılara bildirim göndermesi eklendi
        /// </summary>
        private async Task<RedisValue> ProcessPendingNotification(
            RedisCacheCoordinator.PendingFcmNotification notification)
        {
            try
            {
                var groups = await _cacheBase.GetAsync("groups", async () =>
                {
                    //TODO: bu listeyi tenant managerdan çekmem lazım
                    return await _keycloakClientService.GetKeycloakClientAsync()
                        .GetGroupHierarchyAsync(_keycloakSettings.Realm);
                });
                var tenantDb = groups.Where(x => x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                                                 x.Attributes["StoreMongoConnectionString"].Count() > 0 &&
                                                 x.Attributes["StoreId"].FirstOrDefault() == notification.TenantId)
                    .Select(x => new DataSettings() {
                        ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
                        DbProvider = DbProvider.MongoDB
                    }).FirstOrDefault();

                if (tenantDb != null)
                {
                    var mongourl = new MongoUrl(tenantDb.ConnectionString);
                    var databaseName = mongourl.DatabaseName;
                    var database = new MongoClient(tenantDb.ConnectionString).GetDatabase(databaseName);
                    using (var tenantScope = _serviceProvider
                               .GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
                               .CreateScopeWithReplacement(database,notification.TenantId))
                    {
                        // var _pushNotificationsService =
                        //     tenantScope.ServiceProvider.GetRequiredService<IPushNotificationsService>();
                        // var _firebaseService = tenantScope.ServiceProvider.GetRequiredService<FirebaseService>();
                        // Bekleyen FCM bildirimi için müşterinin token'larını al
                        // var pushRegistrations =
                        //     await _pushNotificationsService.GetPushReceiverByCustomerId(notification.CustomerId);

                        // WebSocket bildirimi için Redis'e yayınlama
                        try
                        {
                            var tenantIdentityAccessor = tenantScope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                            tenantIdentityAccessor.TenantId = notification.TenantId;
                            var customerService = tenantScope.ServiceProvider.GetRequiredService<ICustomerService>();
                            var customer = await customerService.GetCustomerById(notification.CustomerId);
                            if (customer == null)
                            {
                                var debug = $"Customer not found for ID: {notification.CustomerId}";
                            }

                            var db = _redis.GetDatabase();
                            var wsNotificationKey =
                                $"ws:notification:{notification.TenantId}:{notification.CustomerId}";

                            // WebSocket için bildirim verisini hazırla
                            var wsData = new Dictionary<string, object> {
                                { "correlationIds", notification.CorrelationIds },
                                { "tenantId", notification.TenantId },
                                { "customerId", notification.CustomerId },
                                { "timestamp", DateTimeOffset.UtcNow.ToString("o") },
                                { "type", "cache_invalidation" }
                            };

                            // WebSocket bildirimi verilerini Redis'e kaydet (kısa bir süreliğine)
                            await db.StringSetAsync(wsNotificationKey, JsonSerializer.Serialize(wsData),
                                TimeSpan.FromMinutes(15));

                            // WebSocket bildirim kuyruğuna ekle (WebSocket Controller tarafından işlenecek)
                            // taskPool.Add(redisBatch.ListRightPushAsync("ws:notifications", wsNotificationKey));

                            _logger.LogInformation(
                                "WebSocket notification queued for customer {CustomerId} in tenant {TenantId}",
                                notification.CustomerId, notification.TenantId);

                            return wsNotificationKey;
                        }
                        catch (Exception wsEx)
                        {
                            _logger.LogWarning(wsEx,
                                "Failed to queue WebSocket notification for customer {CustomerId} in tenant {TenantId}",
                                notification.CustomerId, notification.TenantId);
                        }

                        // // Token geçersiz veya FCM bildirimleri devre dışı ise sadece WebSocket bildirimi gönder
                        // if (pushRegistrations == null || string.IsNullOrEmpty(pushRegistrations.Token) ||
                        //     !pushRegistrations.Allowed)
                        //     return;
                        //
                        // // Correlation ID'leri 10'ar gruplar halinde gönder (FCM mesaj boyut sınırlaması için)
                        // // Her grup için refreshCacheTime'ı farklı ayarla
                        // var baseRefreshTime = DateTimeOffset.UtcNow;
                        // var correlationBatches = notification.CorrelationIds
                        //     .Select((item, index) => new { Item = item, Index = index })
                        //     .GroupBy(x => x.Index / 10)
                        //     .Select(g => g.Select(x => x.Item).ToList())
                        //     .ToList();
                        //
                        // for (int i = 0; i < correlationBatches.Count; i++)
                        // {
                        //     var correlationBatch = correlationBatches[i];
                        //     var refreshCacheTime = baseRefreshTime.AddSeconds(i * 5); // Her batch için 5 saniye ekle
                        //
                        //     var data = new Dictionary<string, string> {
                        //         { "CorrelationIds", JsonSerializer.Serialize(correlationBatch) },
                        //         { "TenantId", notification.TenantId },
                        //         { "RefreshCacheTime", refreshCacheTime.ToString("o") },
                        //         { "Type", "cache_invalidation" }
                        //     };
                        //
                        //     // FCM mesajını hazırla
                        //     var fcmMessage = new Message {
                        //         Token = pushRegistrations.Token,
                        //         Data = data
                        //     };
                        //
                        //     // FCM bildirimi gönder
                        //     var response = await _firebaseService.SendMessageAsync(fcmMessage);
                        //
                        //     if (response == null)
                        //     {
                        //         _logger.LogWarning(
                        //             "Failed to send FCM notification to customer {CustomerId} in tenant {TenantId}",
                        //             notification.CustomerId, notification.TenantId);
                        //
                        //         // Token geçersiz olabilir, sil
                        //         await _pushNotificationsService.DeletePushReceiver(pushRegistrations);
                        //
                        //         // Diğer batch'leri işlemeye gerek yok
                        //         break;
                        //     }
                        //     else
                        //     {
                        //         _logger.LogInformation(
                        //             "Sent FCM notification for customer {CustomerId} in tenant {TenantId} with {CorrelationCount} correlations. " +
                        //             "RefreshCacheTime: {RefreshTime}",
                        //             notification.CustomerId, notification.TenantId, correlationBatch.Count,
                        //             refreshCacheTime);
                        //     }
                        // }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error processing FCM notification for customer {CustomerId} in tenant {TenantId}",
                    notification.CustomerId, notification.TenantId);
            }

            return RedisValue.Null;
        }
    }
}