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
        
        public RedisTrackedMemoryCacheBase(
            IMemoryCache cache, 
            IMediator mediator, 
            CacheConfig cacheConfig, 
            IHttpContextAccessor httpContextAccessor,
            RedisCacheCoordinator cacheCoordinator) 
            : base(cache, mediator, cacheConfig, httpContextAccessor)
        {
            _cacheCoordinator = cacheCoordinator;
            _httpContextAccessor = httpContextAccessor;
        }

        public override async Task<T> GetAsync<T>(string key, Func<Task<T>> acquire)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.GetAsync<T>(cacheKeyWithTenantPrefix, acquire);
        }

        public override async Task<T> GetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.GetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override T Get<T>(string key, Func<T> acquire)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            _ = TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return base.Get<T>(cacheKeyWithTenantPrefix, acquire);
        }
        
        public override T Get<T>(string key, Func<T> acquire, int cacheTime)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            _ = TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return base.Get<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
        }
        
        public override async Task<T> SetAsync<T>(string key, Func<Task<T>> acquire)
        {
            var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
            await TrackCacheAccessAsync(cacheKeyWithTenantPrefix);
            return await base.SetAsync<T>(cacheKeyWithTenantPrefix, acquire);
        }
        
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
        private string GetCacheKeyWithTenantPrefix(string key)
        {
            if (_httpContextAccessor.HttpContext != null &&
                _httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
                if (storeId != null)
                    key = storeId.ToString() + "." + key;
            return key;
        }
    }
}