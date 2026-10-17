using StackExchange.Redis;
using Grand.Infrastructure.MultiTenant;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using System;
using System.Threading.Tasks;

namespace Grand.Infrastructure.Caching
{
    /// <summary>
    /// Redis tabanlı cache key izleme ile çalışan memory cache
    /// </summary>
    public class RedisTrackedMemoryCacheBase : MemoryCacheBase
    {
        private readonly RedisCacheCoordinator _cacheCoordinator;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ITenantIdentityAccessor _tenantIdentityAccessor;
        private readonly CacheConfig _cacheConfig;
        private readonly IMemoryCache _memory;
        private readonly TenantCacheJournal _journal;
        private sealed record ObservedValue<T>(T Value, CacheReadStamp Stamp);
        
        public RedisTrackedMemoryCacheBase(
            IMemoryCache cache, 
            IMediator mediator, 
            CacheConfig cacheConfig, 
            IHttpContextAccessor httpContextAccessor,
            RedisCacheCoordinator cacheCoordinator)
            : this(cache, mediator, cacheConfig, httpContextAccessor, cacheCoordinator, null) { }

        public RedisTrackedMemoryCacheBase(
            IMemoryCache cache,
            IMediator mediator,
            CacheConfig cacheConfig,
            IHttpContextAccessor httpContextAccessor,
            RedisCacheCoordinator cacheCoordinator,
            ITenantIdentityAccessor tenantIdentityAccessor)
            : this(cache, mediator, cacheConfig, httpContextAccessor, cacheCoordinator, tenantIdentityAccessor, null) { }

        public RedisTrackedMemoryCacheBase(IMemoryCache cache, IMediator mediator, CacheConfig cacheConfig,
            IHttpContextAccessor httpContextAccessor, RedisCacheCoordinator cacheCoordinator,
            ITenantIdentityAccessor tenantIdentityAccessor, TenantCacheJournal journal)
            : base(cache, mediator, cacheConfig, httpContextAccessor)
        {
            _cacheCoordinator = cacheCoordinator;
            _httpContextAccessor = httpContextAccessor;
            _tenantIdentityAccessor = tenantIdentityAccessor;
            _cacheConfig = cacheConfig;
            _memory = cache;
            _journal = journal;
        }

        public override Task<T> GetAsync<T>(string key, Func<Task<T>> acquire)
            => GetAsync(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);

        public override async Task<T> GetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
        {
            if (_journal?.Enabled == true && !string.IsNullOrEmpty(_journal.CurrentStore())) return await GetObservedAsync(key, acquire, cacheTime, false).ConfigureAwait(false);
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.GetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override T Get<T>(string key, Func<T> acquire)
            => Get(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);
        
        public override T Get<T>(string key, Func<T> acquire, int cacheTime)
        {
            if (_journal?.Enabled == true && !string.IsNullOrEmpty(_journal.CurrentStore())) return GetObservedAsync(key, () => Task.FromResult(acquire()), cacheTime, false).GetAwaiter().GetResult();
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            _ = TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return base.Get<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override Task<T> SetAsync<T>(string key, Func<Task<T>> acquire)
            => SetAsync(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);
        
        public override async Task<T> SetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
        {
            if (_journal?.Enabled == true && !string.IsNullOrEmpty(_journal.CurrentStore())) return await GetObservedAsync(key, acquire, cacheTime, true).ConfigureAwait(false);
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.SetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        private async Task<T> GetObservedAsync<T>(string logicalKey, Func<Task<T>> acquire, int cacheTime, bool replace)
        {
            var store = _journal.CurrentStore();
            var key = GetCacheKeyWithTenantPrefix(logicalKey);
            var acquisitionStarted = false;
            var acquired = false;
            T acquiredValue = default;
            try
            {
                if (cacheTime <= 0)
                {
                    var before = await _journal.ObserveAsync(store).ConfigureAwait(false);
                    acquisitionStarted = true;
                    acquiredValue = await acquire().ConfigureAwait(false);
                    acquired = true;
                    await _journal.TrackCurrentAsync(store, key, before).ConfigureAwait(false);
                    return acquiredValue;
                }
                if (!replace && _memory.TryGetValue(key, out ObservedValue<T> cached) &&
                    await _journal.IsFreshAsync(store, key, cached.Stamp).ConfigureAwait(false))
                {
                    await _journal.TrackCurrentAsync(store, key, cached.Stamp).ConfigureAwait(false);
                    return cached.Value;
                }
                var gate = CacheEntries.GetOrAdd(key, _ => new SemaphoreSlim(1, 1));
                await gate.WaitAsync().ConfigureAwait(false);
                try
                {
                    if (!replace && _memory.TryGetValue(key, out cached) &&
                        await _journal.IsFreshAsync(store, key, cached.Stamp).ConfigureAwait(false))
                    {
                        await _journal.TrackCurrentAsync(store, key, cached.Stamp).ConfigureAwait(false);
                        return cached.Value;
                    }
                    var before = await _journal.ObserveAsync(store).ConfigureAwait(false);
                    acquisitionStarted = true;
                    var value = acquiredValue = await acquire().ConfigureAwait(false);
                    acquired = true;
                    if (cacheTime > 0 && await _journal.IsFreshAsync(store, key, before).ConfigureAwait(false))
                        _memory.Set(key, new ObservedValue<T>(value, before),
                            new MemoryCacheEntryOptions { AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(cacheTime) }
                                .RegisterPostEvictionCallback((removed, _, reason, _) => {
                                    if (reason != EvictionReason.Replaced) CacheEntries.TryRemove(removed.ToString(), out _);
                                }));
                    else _memory.Remove(key);
                    // Keep the data's observation, rather than stamping stale data as newly read.
                    await _journal.TrackCurrentAsync(store, key, before).ConfigureAwait(false);
                    return value;
                }
                finally { gate.Release(); }
            }
            catch (RedisException) when (!acquisitionStarted || acquired)
            {
                // Never repeat an acquisition that already ran; a factory may have side effects.
                return acquired ? acquiredValue : await acquire().ConfigureAwait(false);
            }
        }

        /// <summary>
        /// Cache erişimini Redis'te izle
        /// </summary>
        private async Task TrackCacheAccessAsync(string key)
        {
            if (_httpContextAccessor.HttpContext?.Items.TryGetValue("CorrelationId", out var correlationId) == true &&
                _httpContextAccessor.HttpContext?.Items.TryGetValue("CurrentCustomerId", out var customerId) == true)
            {
                await _cacheCoordinator.TrackCacheAccessAsync(
                    correlationId.ToString(), 
                    key, 
                    customerId?.ToString() ?? "anonymous");
            }
        }
        
        /// <summary>
        /// Cache key'e tenant prefix'i ekle
        /// </summary>
        protected string GetCacheKeyWithTenantPrefix(string key)
        {
            string store = null;
            if (_httpContextAccessor.HttpContext?.Items.TryGetValue("StoreId", out var value) == true) store = value?.ToString();
            if (string.IsNullOrEmpty(store)) store = _tenantIdentityAccessor?.TenantId;
            return string.IsNullOrEmpty(store) ? key : store + "." + key;
        }
    }
}