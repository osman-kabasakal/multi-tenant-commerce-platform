using Grand.Infrastructure;
using Grand.Infrastructure.Caching.Redis;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Cache;
using Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using MediatR;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using StackExchange.Redis;
using System;
using System.Text.Json;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Handlers;

public class StaleCacheKeyQueryHandler : IRequestHandler<StaleCacheQuery, StaleCacheResponse>
{
    private readonly IRepository<CacheKeyCorrelation> _cacheKeyCorrelationRepository;
    private readonly IDateTimeService _dateTimeService;
    private readonly IConnectionMultiplexer _redis;
    private readonly ILogger<StaleCacheKeyQueryHandler> _logger;
    private readonly TenantCacheJournal _journal;
    private readonly IWorkContext _workContext;

    public StaleCacheKeyQueryHandler(
        IRepository<CacheKeyCorrelation> cacheKeyCorrelationRepository, 
        IDateTimeService dateTimeService,
        IConnectionMultiplexer redis,
        ILogger<StaleCacheKeyQueryHandler> logger)
        : this(cacheKeyCorrelationRepository, dateTimeService, redis, logger, null, null) { }

    public StaleCacheKeyQueryHandler(IRepository<CacheKeyCorrelation> cacheKeyCorrelationRepository,
        IDateTimeService dateTimeService, IConnectionMultiplexer redis, ILogger<StaleCacheKeyQueryHandler> logger,
        TenantCacheJournal journal, IWorkContext workContext)
    {
        _cacheKeyCorrelationRepository = cacheKeyCorrelationRepository;
        _dateTimeService = dateTimeService;
        _redis = redis;
        _logger = logger;
        _journal = journal;
        _workContext = workContext;
    }

    public async Task<StaleCacheResponse> Handle(StaleCacheQuery request, CancellationToken cancellationToken)
    {
        if (request.StaleCacheItems == null || request.StaleCacheItems.Count == 0)
        {
            return new StaleCacheResponse();
        }

        if (_journal?.Enabled == true)
        {
            var ids = request.StaleCacheItems.Select(x => x.CorrelationId).ToArray();
            var store = _journal.CurrentStore();
            var customer = _workContext?.CurrentCustomer;
            if (string.IsNullOrEmpty(store) || _workContext?.CurrentStore?.Id != store || customer == null || string.IsNullOrEmpty(customer.Id))
                throw new InvalidOperationException("Check client cache only in the current owned customer/store context.");
            try
            {
                var stale = await _journal.StaleAsync(store, customer.Id, ids);
                return new StaleCacheResponse { StaleCorrelationIds = stale.ToList(), AsOf = DateTime.UtcNow };
            }
            catch (RedisException error)
            {
                _logger.LogWarning("Client cache tracking unavailable: {ErrorType}", error.GetType().Name);
                return new StaleCacheResponse { StaleCorrelationIds = ids.Distinct().ToList(), AsOf = DateTime.UtcNow };
            }
        }

        var minAsof = request.StaleCacheItems.OrderBy(x => x.AsOf).First().AsOf;
        var staleCorrelationIds = request.StaleCacheItems.Select(x => x.CorrelationId).ToList();
        var result = new StaleCacheResponse
        {
            StaleCorrelationIds = new List<string>(),
            AsOf = minAsof
        };

        try
        {
            // var tasks = new List<Task>();
            // var staleCorrelationsFromDb = new List<string>();
            var staleCorrelationsFromRedis = new List<string>();

            // 1. Paralel sorgulama: Hem DB hem Redis sorguları eş zamanlı başlat
            // var dbTask = Task.Run(async () => {
            //     // MongoDB'den veritabanından bayat olarak işaretlenmiş correlation ID'lerini kontrol et
            //     var staledCorrelationsFromDb = await _cacheKeyCorrelationRepository.Table
            //         .Where(x => x.IsStale && 
            //         x.CreatedAt >= minAsof.AddSeconds(-10).ConvertToUtcTime(_dateTimeService) && 
            //         staleCorrelationIds.Contains(x.CorrelationId))
            //         .ToListAsync(cancellationToken);
            //
            //     staleCorrelationsFromDb = staledCorrelationsFromDb
            //         .Select(x => x.CorrelationId)
            //         .Distinct()
            //         .ToList();
            // });
            
            var redisTask = Task.Run(async () => {
                // Batch sorgu için Redis'i optimize et
                var db = _redis.GetDatabase();
                var pipe = db.CreateBatch();
                
                // 1. Tüm correlation'ların cache key'lerini toplama görevlerini başlat
                var correlationCacheKeyTasks = new Dictionary<string, Task<HashEntry[]>>();
                foreach (var correlationId in staleCorrelationIds)
                {
                    // Her bir correlation ID için ilişkili cache key'leri (Hash)
                    var correlationCacheKeysKey = $"corr:keys:{correlationId}";
                    correlationCacheKeyTasks[correlationId] = pipe.HashGetAllAsync(correlationCacheKeysKey);
                }
                
                // 2. Batch sorguyu çalıştır
                pipe.Execute();
                
                // 3. Her correlation için cache key'leri kontrol et ve timestamp'e göre stale durumunu belirle
                foreach (var correlationId in staleCorrelationIds)
                {
                    var cacheKeyEntries = await correlationCacheKeyTasks[correlationId];
                    if (cacheKeyEntries != null && cacheKeyEntries.Length > 0)
                    {
                        bool isStale = false;
                        
                        // İkinci batch için hazırlık
                        var invalidationCheckPipe = db.CreateBatch();
                        var invalidationTasks = new Dictionary<string, Task<RedisValue>>();
                        
                        // Her cache key için bayatlama kontrolü yap
                        foreach (var entry in cacheKeyEntries)
                        {
                            var cacheKey = entry.Name.ToString();
                            var accessTimestamp = long.Parse(entry.Value.ToString());
                            
                            // Cache key'in bayatlama bilgisini kontrol et
                            var invalidationKey = $"inv:key:{cacheKey}";
                            invalidationTasks[cacheKey] = invalidationCheckPipe.StringGetAsync(invalidationKey);
                        }
                        
                        // Tüm invalidation kontrollerini çalıştır
                        invalidationCheckPipe.Execute();
                        
                        // Kontrol sonuçlarını işle
                        foreach (var entry in cacheKeyEntries)
                        {
                            var cacheKey = entry.Name.ToString();
                            var accessTimestamp = long.Parse(entry.Value.ToString());
                            
                            var invalidationTime = await invalidationTasks[cacheKey];
                            if (!invalidationTime.IsNullOrEmpty)
                            {
                                var invalidationTimestamp = long.Parse(invalidationTime.ToString());
                                
                                // Erişim zamanı, invalidasyon zamanından önceyse, bu key o correlation için bayat
                                if (accessTimestamp < invalidationTimestamp)
                                {
                                    isStale = true;
                                    break;
                                }
                            }
                        }
                        
                        if (isStale)
                        {
                            staleCorrelationsFromRedis.Add(correlationId);
                        }
                    }
                    else
                    {
                        staleCorrelationsFromRedis.Add(correlationId);
                    }
                }
            });
            
            // Paralel çalıştır ve tamamlanmasını bekle
            await redisTask;

            // Her iki kaynaktan gelen bayat ID'leri birleştir
            result.StaleCorrelationIds = staleCorrelationsFromRedis
                .Distinct()
                .ToList();

            _logger.LogInformation(
                "Found {StaleCount} stale correlations out of {TotalCount} requested {RedisCount} from Redis)",
                result.StaleCorrelationIds.Count, staleCorrelationIds.Count, staleCorrelationsFromRedis.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking stale cache keys for {CorrelationCount} correlations", staleCorrelationIds.Count);
        }

        return result;
    }
}
