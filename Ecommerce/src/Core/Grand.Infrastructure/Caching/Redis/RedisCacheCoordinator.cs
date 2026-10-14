using Grand.Infrastructure.ConcurretCollections;
using Grand.Infrastructure.Events;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System.Collections.Concurrent;
using System.Text.Json;

namespace Grand.Infrastructure.Caching.Redis
{
    /// <summary>
    /// Redis tabanlı geliştirilmiş cache koordinatörü
    /// </summary>
    public class RedisCacheCoordinator : IDisposable
    {
        private readonly IConnectionMultiplexer _redis;
        private readonly ILogger<RedisCacheCoordinator> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly string _appInstanceId;
        private readonly ConcurrentDictionary<string, ConcurrentHashSet<CacheEventInfo>> _requestEvents = new();
        private readonly ConcurrentDictionary<string, ConcurrentHashSet<CacheEventInfo>> _globalEvents = new();
        private readonly SemaphoreSlim _processingLock = new(1, 1);
        private readonly Timer _processingTimer;
        private readonly TimeSpan _throttlingWindow = TimeSpan.FromMilliseconds(10000);

        // Cache key zaman aşımı için varsayılan süre
        private readonly TimeSpan _cacheKeyDefaultExpiry = TimeSpan.FromHours(24);

        public RedisCacheCoordinator(
            IConnectionMultiplexer redis,
            ILogger<RedisCacheCoordinator> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _redis = redis;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
            _appInstanceId = Environment.GetEnvironmentVariable("TENANT_APP_INSTANCE_ID") ??
                             Guid.NewGuid().ToString("N"); // Her uygulama instance'ı için benzersiz ID
            _processingTimer = new Timer(ProcessGlobalEvents, null, _throttlingWindow, _throttlingWindow);
        }

        /// <summary>
        /// Cache erişimini Redis'te izle - Batch işlem optimizasyonu ile
        /// </summary>
        public async Task TrackCacheAccessAsync(string correlationId, string cacheKey, string customerId)
        {
            if (string.IsNullOrEmpty(correlationId))
                return;

            try
            {
                var db = _redis.GetDatabase();
                var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds().ToString();

                // Tüm komutları tek bir batch işleminde birleştir
                var batch = db.CreateBatch();

                // 1. Correlation -> Cache Keys ilişkisi (timestamp ile)
                var correlationCacheKeysKey = $"corr:keys:{correlationId}";
                batch.HashSetAsync(correlationCacheKeysKey, cacheKey, timestamp);
                batch.KeyExpireAsync(correlationCacheKeysKey, _cacheKeyDefaultExpiry);

                // 2. Correlation -> CustomerId ilişkisi
                var correlationCustomerKey = $"corr:cust:{correlationId}";
                batch.StringSetAsync(correlationCustomerKey, customerId, _cacheKeyDefaultExpiry);

                // 3. Cache Key -> Correlations ilişkisi (timestamp ile)
                var cacheKeyCorrelationsKey = $"key:corrs:{cacheKey}";
                batch.HashSetAsync(cacheKeyCorrelationsKey, correlationId, timestamp);
                batch.KeyExpireAsync(cacheKeyCorrelationsKey, _cacheKeyDefaultExpiry);

                // 4. Customer -> Correlations ilişkisi
                var customerCorrelationsKey = $"cust:corrs:{customerId}";
                batch.SetAddAsync(customerCorrelationsKey, correlationId);
                batch.KeyExpireAsync(customerCorrelationsKey, _cacheKeyDefaultExpiry);

                // Batch işlemi çalıştır
                batch.Execute();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error tracking cache access for correlation {CorrelationId}", correlationId);
            }
        }

        /// <summary>
        /// Cache invalidation eventi ekle (istek bazlı veya global)
        /// </summary>
        public void AddCacheInvalidation(string cacheKey, CacheEvent eventType)
        {
            var tenantId = GetCurrentTenantId(cacheKey);
            // var httpContext = _httpContextAccessor.HttpContext;
            //
            // if (httpContext != null && httpContext.Items.TryGetValue("CorrelationId", out var correlationId))
            // {
            //     // İstek bağlamında ise, istek bazlı event birikimi
            //     var key = $"{tenantId}:{correlationId}";
            //     _requestEvents.AddOrUpdate(
            //         key,
            //         _ => new ConcurrentHashSet<CacheEventInfo> { new(cacheKey, eventType, DateTimeOffset.UtcNow) },
            //         (_, events) => 
            //         {
            //             events.Add(new CacheEventInfo(cacheKey, eventType, DateTimeOffset.UtcNow));
            //             return events;
            //         });
            // }
            // else
            // {
            //     // İstek dışında ise, global event birikimi
            //     var key = tenantId;
            //     _globalEvents.AddOrUpdate(
            //         key,
            //         _ => new ConcurrentHashSet<CacheEventInfo> { new(cacheKey, eventType, DateTimeOffset.UtcNow) },
            //         (_, events) => 
            //         {
            //             events.Add(new CacheEventInfo(cacheKey, eventType, DateTimeOffset.UtcNow));
            //             return events;
            //         });
            // }

            var key = tenantId;
            _globalEvents.AddOrUpdate(
                key,
                _ => new ConcurrentHashSet<CacheEventInfo> { new(cacheKey, eventType, DateTimeOffset.UtcNow) },
                (_, events) =>
                {
                    events.Add(new CacheEventInfo(cacheKey, eventType, DateTimeOffset.UtcNow));
                    return events;
                });
        }

        /// <summary>
        /// İstek sonunda biriken cache eventlerini işle
        /// </summary>
        public async Task ProcessRequestEventsAsync()
        {
            var httpContext = _httpContextAccessor.HttpContext;

            if (httpContext != null && httpContext.Items.TryGetValue("CorrelationId", out var correlationId))
            {
                var tenantId = GetCurrentTenantId();
                var key = $"{tenantId}:{correlationId}";

                if (_requestEvents.TryRemove(key, out var events) && events.Any())
                {
                    await ProcessEventsAsync(tenantId, events);
                }
            }
        }

        /// <summary>
        /// Timer tarafından çağrılan global eventleri işle
        /// </summary>
        private async void ProcessGlobalEvents(object state)
        {
            if (!await _processingLock.WaitAsync(0))
                return;

            try
            {
                foreach (var kv in _globalEvents.ToList())
                {
                    var tenantId = kv.Key;
                    var events = kv.Value;

                    if (events.Any())
                    {
                        await ProcessEventsAsync(tenantId, new ConcurrentHashSet<CacheEventInfo>(events));
                        _globalEvents[tenantId].Clear();
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing global cache events");
            }
            finally
            {
                _processingLock.Release();
            }
        }

        /// <summary>
        /// Cache eventlerini gruplayıp Redis'e yayınla - optimizasyon
        /// </summary>
        private async Task ProcessEventsAsync(string tenantId, ConcurrentHashSet<CacheEventInfo> events)
        {
            try
            {
                // Daha verimli gruplama yaklaşımı
                var groupedEventMap = new Dictionary<(string CacheKey, CacheEvent EventType), List<CacheEventInfo>>();

                foreach (var evt in events)
                {
                    var key = (evt.CacheKey, evt.EventType);
                    if (!groupedEventMap.TryGetValue(key, out var list))
                    {
                        list = new List<CacheEventInfo>();
                        groupedEventMap[key] = list;
                    }

                    list.Add(evt);
                }

                var groupedEvents = groupedEventMap.Select(g => new ProcessedCacheEvent {
                    CacheKey = g.Key.CacheKey,
                    EventType = g.Key.EventType,
                    Count = g.Value.Count,
                    FirstSeen = g.Value.Min(e => e.Timestamp),
                    LastSeen = g.Value.Max(e => e.Timestamp),
                    InvalidationTimestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
                }).ToList();

                if (!groupedEvents.Any())
                    return;

                // Redis'e yayınla
                await PublishToRedisAsync(tenantId, groupedEvents);

                _logger.LogDebug(
                    "Processed {EventCount} cache events for tenant {TenantId}, grouped to {GroupCount} events",
                    events.Count, tenantId, groupedEvents.Count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing cache events for tenant {TenantId}", tenantId);
            }
        }

        /// <summary>
        /// Gruplanmış cache eventlerini Redis'e yayınla
        /// </summary>
        private async Task PublishToRedisAsync(string tenantId, List<ProcessedCacheEvent> events)
        {
            try
            {
                var message = new CacheEventBatchMessage {
                    TenantId = tenantId,
                    SourceInstanceId = _appInstanceId,
                    Events = events,
                    Timestamp = DateTimeOffset.UtcNow
                };

                var subscriber = _redis.GetSubscriber();
                var channel = RedisChannel.Literal("cache:invalidations");

                await subscriber.PublishAsync(channel, JsonSerializer.Serialize(message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing cache events to Redis");
            }
        }

        /// <summary>
        /// Redis kanalını dinle ve gelen mesajları işle
        /// </summary>
        public void SubscribeToRedisChannel()
        {
            try
            {
                var subscriber = _redis.GetSubscriber();
                var channel = RedisChannel.Literal("cache:invalidations");

                subscriber.Subscribe(channel, async (_, message) =>
                {
                    try
                    {
                        var eventBatch = JsonSerializer.Deserialize<CacheEventBatchMessage>(message);

                        // Kendi gönderdiğimiz mesajları işleme
                        if (eventBatch.SourceInstanceId != _appInstanceId)
                        {
                            await HandleCacheInvalidationMessageAsync(eventBatch);
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error processing Redis cache invalidation message");
                    }
                });

                _logger.LogInformation("Subscribed to Redis cache invalidation channel");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error subscribing to Redis cache invalidation channel");
            }
        }

        /// <summary>
        /// Redis'ten gelen cache invalidation mesajını işle
        /// </summary>
        private async Task HandleCacheInvalidationMessageAsync(CacheEventBatchMessage eventBatch)
        {
            try
            {
                _logger.LogInformation(
                    "Received cache event batch from instance {SourceId} for tenant {TenantId} with {EventCount} events",
                    eventBatch.SourceInstanceId,
                    eventBatch.TenantId,
                    eventBatch.Events.Count);

                var db = _redis.GetDatabase();

                foreach (var cacheEvent in eventBatch.Events)
                {
                    // Zaman damgasını kullanarak invalidation kaydı
                    var invalidationKey = $"inv:key:{cacheEvent.CacheKey}";
                    var invalidationTime = cacheEvent.InvalidationTimestamp.ToString();
                    await db.StringSetAsync(invalidationKey, invalidationTime, _cacheKeyDefaultExpiry);

                    var staleInfoKey = $"inv:info:{cacheEvent.CacheKey}";
                    var staleInfo = new StaleKeyInfo {
                        CacheKey = cacheEvent.CacheKey,
                        EventType = cacheEvent.EventType,
                        Timestamp = DateTimeOffset.UtcNow,
                        InvalidationTimestamp = cacheEvent.InvalidationTimestamp,
                        Reason = $"Cache invalidation from {eventBatch.SourceInstanceId}"
                    };

                    await db.StringSetAsync(staleInfoKey, JsonSerializer.Serialize(staleInfo), _cacheKeyDefaultExpiry);

                    // Etkilenen correlation'ları bulup FCM bildirimleri için hazırla
                    await ProcessAffectedCorrelationsAsync(eventBatch.TenantId, cacheEvent);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error handling cache invalidation message");
            }
        }

        /// <summary>
        /// Etkilenen correlation'ları belirleyip FCM bildirimleri için hazırla - optimizasyon
        /// </summary>
        private async Task ProcessAffectedCorrelationsAsync(string tenantId, ProcessedCacheEvent cacheEvent)
        {
            try
            {
                var db = _redis.GetDatabase();
                var affectedCorrelations = new HashSet<string>();

                if (cacheEvent.EventType == CacheEvent.RemovePrefix)
                {
                    // Daha verimli key tarama ve işleme
                    var keyPattern = $"key:corrs:{cacheEvent.CacheKey}*";
                    var matchingKeys = await ScanKeysAsync(db, keyPattern);

                    // Redis'ten tüm verileri tek seferde almak için batch işlemi
                    var batch = db.CreateBatch();
                    var hashGetTasks = new Dictionary<string, Task<HashEntry[]>>();

                    foreach (var key in matchingKeys)
                    {
                        hashGetTasks[key] = batch.HashGetAllAsync(key);
                    }

                    batch.Execute();

                    // Sonuçları işle
                    foreach (var entry in hashGetTasks)
                    {
                        var hashEntries = await entry.Value;

                        foreach (var hashEntry in hashEntries)
                        {
                            var correlationId = hashEntry.Name.ToString();
                            var accessTimestamp = long.Parse(hashEntry.Value.ToString());

                            if (accessTimestamp < cacheEvent.InvalidationTimestamp)
                            {
                                affectedCorrelations.Add(correlationId);
                            }
                        }
                    }
                }
                else
                {
                    // Tek anahtar için iyileştirilmiş kod
                    var keyCorrelationsKey = $"key:corrs:{cacheEvent.CacheKey}";
                    var correlationEntries = await db.HashGetAllAsync(keyCorrelationsKey);

                    foreach (var entry in correlationEntries)
                    {
                        var correlationId = entry.Name.ToString();
                        var accessTimestamp = long.Parse(entry.Value.ToString());

                        if (accessTimestamp < cacheEvent.InvalidationTimestamp)
                        {
                            affectedCorrelations.Add(correlationId);
                        }
                    }
                }

                if (!affectedCorrelations.Any())
                    return;

                // Müşteri ID'lerini toplu olarak al
                var customerIdDict = new Dictionary<string, string>();
                var batchSize = 100;

                for (int i = 0; i < affectedCorrelations.Count; i += batchSize)
                {
                    var batch = db.CreateBatch();
                    var correlationBatch = affectedCorrelations.Skip(i).Take(batchSize).ToList();
                    var tasks = new Dictionary<string, Task<RedisValue>>();

                    foreach (var correlationId in correlationBatch)
                    {
                        tasks[correlationId] = batch.StringGetAsync($"corr:cust:{correlationId}");
                    }

                    batch.Execute();

                    // Tasks sonuçlarını işle
                    // foreach (var task in tasks)
                    // {
                    //     var value = await task.Value;
                    //     if (!value.IsNullOrEmpty)
                    //     {
                    //         customerIdDict[task.Key] = value.ToString();
                    //     }
                    // }
                }

                // Müşteri ID'lerine göre grupla
                var customerCorrelations = new Dictionary<string, List<string>>();

                foreach (var entry in customerIdDict)
                {
                    var correlationId = entry.Key;
                    var customerId = entry.Value;

                    if (!customerCorrelations.TryGetValue(customerId, out var list))
                    {
                        list = new List<string>();
                        customerCorrelations[customerId] = list;
                    }

                    list.Add(correlationId);
                }

                // FCM bildirimleri için batch işlemi
                // var fcmBatch = db.CreateBatch();
                // var fcmTasks = new List<Task>();

                var listQue = new List<string>();

                foreach (var customer in customerCorrelations)
                {
                    var key = $"fcm:pending:{tenantId}:{customer.Key}";

                    var pendingNotification = new PendingFcmNotification {
                        TenantId = tenantId,
                        CustomerId = customer.Key,
                        CorrelationIds = customer.Value.Distinct().ToList(),
                        Timestamp = DateTimeOffset.UtcNow
                    };

                    if (await db.KeyExistsAsync(key))
                    {
                        var existsKeyValue = await db.StringGetAsync(key);
                        if (!existsKeyValue.IsNullOrEmpty)
                        {
                            var existingNotification =
                                JsonSerializer.Deserialize<PendingFcmNotification>(existsKeyValue);
                            pendingNotification.CorrelationIds.AddRange(existingNotification.CorrelationIds);
                            pendingNotification.CorrelationIds = pendingNotification.CorrelationIds.Distinct().ToList();
                            pendingNotification.Timestamp = DateTimeOffset.UtcNow;
                        }
                    }

                    // Redis'e müşteri başına bekleyen bildirimleri ekle
                    await db.StringSetAsync(key, JsonSerializer.Serialize(pendingNotification),
                        TimeSpan.FromMinutes(15));
                    // FCM bildirim işleyicisini tetiklemek için işleme sırasına ekle
                    listQue.Add(key);
                }

                // fcmBatch.Execute();

                // Tüm task'ları bekle
                // await Task.WhenAll(fcmTasks);

                if (listQue.Count > 0)
                {
                    foreach (var queKey in listQue)
                    {
                        await db.ListRightPushAsync("fcm:queue", queKey);
                    }
                }

                _logger.LogDebug(
                    "Processed FCM notifications for {CustomerCount} customers with {CorrelationCount} total correlations",
                    customerCorrelations.Count, affectedCorrelations.Count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing affected correlations for cache event");
            }
        }

        /// <summary>
        /// FCM bildirimini Redis'e ekle
        /// </summary>
        private async Task EnqueueFcmNotificationAsync(string tenantId, string customerId, List<string> correlationIds)
        {
            try
            {
                var db = _redis.GetDatabase();
                var key = $"fcm:pending:{tenantId}:{customerId}";

                var pendingNotification = new PendingFcmNotification {
                    TenantId = tenantId,
                    CustomerId = customerId,
                    CorrelationIds = correlationIds,
                    Timestamp = DateTimeOffset.UtcNow
                };

                // Redis'e müşteri başına bekleyen bildirimleri ekle
                await db.StringSetAsync(key, JsonSerializer.Serialize(pendingNotification), TimeSpan.FromMinutes(5));

                // FCM bildirim işleyicisini tetiklemek için işleme sırasına ekle
                await db.ListRightPushAsync("fcm:queue", key);

                _logger.LogDebug(
                    "Enqueued FCM notification for customer {CustomerId} in tenant {TenantId} with {CorrelationCount} correlations",
                    customerId, tenantId, correlationIds.Count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error enqueueing FCM notification");
            }
        }

        /// <summary>
        /// Redis'ten keyleri pattern ile ara - optimizasyon
        /// </summary>
        private async Task<List<string>> ScanKeysAsync(IDatabase db, string pattern)
        {
            var result = new List<string>();
            long cursor = 0;
            int batchSize = 5000; // Daha büyük bir COUNT değeriyle daha az SCAN işlemi

            do
            {
                var scanResult = await db.ExecuteAsync("SCAN", cursor.ToString(), "MATCH", pattern, "COUNT",
                    batchSize.ToString());
                var entries = (RedisResult[])scanResult;
                cursor = long.Parse((string)entries[0]);

                var items = (RedisResult[])entries[1];
                result.AddRange(items.Select(x => (string)x));
            } while (cursor != 0);

            return result;
        }

        /// <summary>
        /// Geçerli tenant ID'sini al
        /// </summary>
        private string GetCurrentTenantId(string cacheKey = null)
        {
            if (_httpContextAccessor.HttpContext?.Items.TryGetValue("StoreId", out var storeId) == true &&
                storeId != null)
            {
                return storeId.ToString();
            }
            else if (!string.IsNullOrEmpty(cacheKey))
            {
                var tenantId = cacheKey.Split(".");

                return tenantId.Length <= 1 ? "system" : tenantId[0];
            }

            return "system";
        }

        /// <summary>
        /// Cache event bilgisini tutan sınıf
        /// </summary>
        private class CacheEventInfo
        {
            public string CacheKey { get; }
            public CacheEvent EventType { get; }
            public DateTimeOffset Timestamp { get; }

            public CacheEventInfo(string cacheKey, CacheEvent eventType, DateTimeOffset timestamp)
            {
                CacheKey = cacheKey;
                EventType = eventType;
                Timestamp = timestamp;
            }

            public override bool Equals(object obj)
            {
                if (obj is CacheEventInfo other)
                    return CacheKey == other.CacheKey && EventType == other.EventType;
                return false;
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(CacheKey, EventType);
            }
        }

        /// <summary>
        /// İşlenmiş cache eventi
        /// </summary>
        public class ProcessedCacheEvent
        {
            public string CacheKey { get; set; }
            public CacheEvent EventType { get; set; }
            public int Count { get; set; }
            public DateTimeOffset FirstSeen { get; set; }
            public DateTimeOffset LastSeen { get; set; }
            public long InvalidationTimestamp { get; set; }
        }

        /// <summary>
        /// Redis'e yayınlanan cache event batch'i
        /// </summary>
        public class CacheEventBatchMessage
        {
            public string TenantId { get; set; }
            public string SourceInstanceId { get; set; }
            public List<ProcessedCacheEvent> Events { get; set; }
            public DateTimeOffset Timestamp { get; set; }
        }

        /// <summary>
        /// Stale cache key bilgisi
        /// </summary>
        public class StaleKeyInfo
        {
            public string CacheKey { get; set; }
            public CacheEvent EventType { get; set; }
            public DateTimeOffset Timestamp { get; set; }
            public long InvalidationTimestamp { get; set; }
            public string Reason { get; set; }
        }

        /// <summary>
        /// FCM bildirimi için bekleyen bildirim bilgisi
        /// </summary>
        public class PendingFcmNotification
        {
            public string TenantId { get; set; }
            public string CustomerId { get; set; }
            public List<string> CorrelationIds { get; set; }
            public DateTimeOffset Timestamp { get; set; }
        }

        private bool _disposed;

        ~RedisCacheCoordinator()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed) return;
            if (disposing)
            {
                _redis?.Dispose();
                _processingLock?.Dispose();
                _processingTimer?.Dispose();
            }

            _disposed = true;
        }
    }
}