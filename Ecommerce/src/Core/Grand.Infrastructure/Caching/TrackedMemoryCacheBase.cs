using Grand.Infrastructure.Configuration;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using System;

namespace Grand.Infrastructure.Caching;

public class TrackedMemoryCacheBase: MemoryCacheBase
{
    private readonly ICacheTracker _cacheTracker;
    private readonly IHttpContextAccessor _httpContextAccessor;
    
    public TrackedMemoryCacheBase(
        IMemoryCache cache, 
        IMediator mediator, 
        CacheConfig cacheConfig, 
        IHttpContextAccessor httpContextAccessor,
        ICacheTracker cacheTracker) 
        : base(cache, mediator, cacheConfig, httpContextAccessor)
    {
        _cacheTracker = cacheTracker;
        _httpContextAccessor = httpContextAccessor;
    }
    
    public override async Task<T> GetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
    {
        var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
        TrackCacheAccess(cacheKeyWithTenantPrefix);
        return await base.GetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
    }
    
    public override T Get<T>(string key, Func<T> acquire, int cacheTime)
    {
        var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
        TrackCacheAccess(cacheKeyWithTenantPrefix);
        return base.Get<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
    }
    
    public override async Task<T> SetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
    {
        var cacheKeyWithTenantPrefix = GetCacheKeyWithTenantPrefix(key);
        TrackCacheAccess(cacheKeyWithTenantPrefix);
        return await base.SetAsync<T>(cacheKeyWithTenantPrefix, acquire, cacheTime);
    }
    
    private void TrackCacheAccess(string key)
    {
        if (_httpContextAccessor.HttpContext?.Items.TryGetValue("CorrelationId", out var correlationId)==true)
        {
            _cacheTracker.TrackCacheAccess(correlationId.ToString(), key);
        }
    }

    private string GetCacheKeyWithTenantPrefix(string key){
        if (_httpContextAccessor.HttpContext != null &&
            _httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        return key;
    }
}
