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
            : base(cache, mediator, cacheConfig, httpContextAccessor)
        {
            _cacheCoordinator = cacheCoordinator;
            _httpContextAccessor = httpContextAccessor;
            _tenantIdentityAccessor = tenantIdentityAccessor;
            _cacheConfig = cacheConfig;
        }

        public override Task<T> GetAsync<T>(string key, Func<Task<T>> acquire)
            => GetAsync(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);

        public override async Task<T> GetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.GetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override T Get<T>(string key, Func<T> acquire)
            => Get(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);
        
        public override T Get<T>(string key, Func<T> acquire, int cacheTime)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            _ = TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return base.Get<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override Task<T> SetAsync<T>(string key, Func<Task<T>> acquire)
            => SetAsync(key, acquire, _cacheConfig.DefaultCacheTimeMinutes);
        
        public override async Task<T> SetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.SetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
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