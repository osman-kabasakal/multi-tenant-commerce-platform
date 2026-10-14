using Grand.Infrastructure.Caching.Message;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Events;
using Grand.Infrastructure.MultiTenant;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;

namespace Grand.Infrastructure.Caching.Redis;

public class RedisMessageCacheManager : RedisTrackedMemoryCacheBase, ICacheBase
{
    private readonly IMemoryCache _cache;
    private readonly IMessageBus _messageBus;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly RedisCacheCoordinator _cacheTracker;

    private readonly ITenantIdentityAccessor _tenantIdentityAccessor;

    // private readonly IConfiguration _configuration;
    private readonly IMediator _mediator;

    public RedisMessageCacheManager(IMemoryCache cache, IMediator mediator, IMessageBus messageBus, CacheConfig config, IHttpContextAccessor httpContextAccessor, RedisCacheCoordinator cacheTracker,ITenantIdentityAccessor tenantIdentityAccessor)
        : base(cache, mediator, config, httpContextAccessor, cacheTracker)
    {
        _cache = cache;
        _messageBus = messageBus;
        _httpContextAccessor = httpContextAccessor;
        _cacheTracker = cacheTracker;
        _tenantIdentityAccessor = tenantIdentityAccessor;
        _mediator = mediator;
    }

    /// <summary>
    ///     Removes the value with the specified key from the cache
    /// </summary>
    /// <param name="key">Key of cached item</param>
    /// <param name="publisher">Publisher</param>
    public override Task RemoveAsync(string key, bool publisher = true)
    {
        if (publisher)
        {
            if (_httpContextAccessor.HttpContext != null &&
                _httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            {
                if (storeId != null)
                    key = storeId.ToString() + "." + key;
            }
            else
            {
                key = GetCacheKeyWithTenantPrefixByConfig(key);
            }
        }
        
        _cache.Remove(key);

        if (publisher)
        {
            _messageBus.PublishAsync(new MessageEvent { Key = key, MessageType = (int)MessageEventType.RemoveKey });
            _cacheTracker.AddCacheInvalidation(key,CacheEvent.RemoveKey);
            
            // _mediator.Publish(new EntityCacheEvent(key, CacheEvent.RemoveKey));
        }

        return Task.CompletedTask;
    }

    /// <summary>
    ///     Removes items by key prefix
    /// </summary>
    /// <param name="prefix">String prefix</param>
    /// <param name="publisher">publisher</param>
    public override Task RemoveByPrefix(string prefix, bool publisher = true)
    {
        if (publisher)
        {
            if (_httpContextAccessor.HttpContext != null &&
                _httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            {
                if (storeId != null)
                    prefix = storeId.ToString() + "." + prefix;
            }
            else
            {
                prefix = GetCacheKeyWithTenantPrefixByConfig(prefix);
            }
        }
        
        _cacheTracker.AddCacheInvalidation(prefix,CacheEvent.RemovePrefix);
        var entriesToRemove = CacheEntries.Where(x => x.Key.Contains(prefix, StringComparison.InvariantCultureIgnoreCase));
        foreach (var cacheEntries in entriesToRemove)
        {
            _cache.Remove(cacheEntries.Key);
        };
        

        if (publisher)
        {
            _messageBus.PublishAsync(new MessageEvent { Key = prefix, MessageType = (int)MessageEventType.RemoveByPrefix });
            // _mediator.Publish(new EntityCacheEvent(prefix, CacheEvent.RemovePrefix));
        }

        return Task.CompletedTask;
    }

    /// <summary>
    ///     Clear cache
    /// </summary>
    /// <param name="publisher">publisher</param>
    public override Task Clear(bool publisher = true)
    {
        RemoveByPrefix(GetCacheKeyWithTenantPrefix(""),publisher);
        if (publisher)
            _messageBus.PublishAsync(new MessageEvent { Key = "", MessageType = (int)MessageEventType.ClearCache });

        return Task.CompletedTask;
    }
    
    /// <summary>
    /// Cache key'e tenant prefix'i ekle
    /// </summary>
    private string GetCacheKeyWithTenantPrefix(string key)
    {
        if (_httpContextAccessor.HttpContext != null &&
            _httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
        {
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        }
        else
        {
            key = GetCacheKeyWithTenantPrefixByConfig(key);
        }

        return key;
    }
    
    private string GetCacheKeyWithTenantPrefixByConfig(string key)
    {
        var storeIdConf = _tenantIdentityAccessor.TenantId;
        if (!string.IsNullOrEmpty(storeIdConf))
        {
            key = storeIdConf.ToString() + "." + key;
        }
        return key;
    }
}