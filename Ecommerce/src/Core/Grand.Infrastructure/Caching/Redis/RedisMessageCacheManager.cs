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
    private readonly TenantCacheJournal _journal;

    private readonly ITenantIdentityAccessor _tenantIdentityAccessor;

    // private readonly IConfiguration _configuration;
    private readonly IMediator _mediator;

    public RedisMessageCacheManager(IMemoryCache cache, IMediator mediator, IMessageBus messageBus, CacheConfig config, IHttpContextAccessor httpContextAccessor, RedisCacheCoordinator cacheTracker,ITenantIdentityAccessor tenantIdentityAccessor)
        : this(cache, mediator, messageBus, config, httpContextAccessor, cacheTracker, tenantIdentityAccessor, null) { }

    public RedisMessageCacheManager(IMemoryCache cache, IMediator mediator, IMessageBus messageBus, CacheConfig config,
        IHttpContextAccessor httpContextAccessor, RedisCacheCoordinator cacheTracker, ITenantIdentityAccessor tenantIdentityAccessor,
        TenantCacheJournal journal)
        : base(cache, mediator, config, httpContextAccessor, cacheTracker, tenantIdentityAccessor, journal)
    {
        _cache = cache;
        _messageBus = messageBus;
        _httpContextAccessor = httpContextAccessor;
        _cacheTracker = cacheTracker;
        _journal = journal;
        _tenantIdentityAccessor = tenantIdentityAccessor;
        _mediator = mediator;
    }

    /// <summary>
    ///     Removes the value with the specified key from the cache
    /// </summary>
    /// <param name="key">Key of cached item</param>
    /// <param name="publisher">Publisher</param>
    public override async Task RemoveAsync(string key, bool publisher = true)
    {
        if (publisher) key = GetCacheKeyWithTenantPrefix(key);
        if (string.IsNullOrWhiteSpace(key)) throw new InvalidOperationException("A cache removal requires an owned key.");
        if (publisher && _journal?.Enabled == true && !string.IsNullOrEmpty(_journal.CurrentStore()))
            await _journal.InvalidateAsync(_journal.CurrentStore(), key, CacheEvent.RemoveKey);
        _cache.Remove(key);
        if (publisher)
        {
            await _messageBus.PublishAsync(new MessageEvent { Key = key, MessageType = (int)MessageEventType.RemoveKey });
            if (_journal?.Enabled != true) _cacheTracker.AddCacheInvalidation(key, CacheEvent.RemoveKey);
        }
    }

    public override async Task RemoveByPrefix(string prefix, bool publisher = true)
    {
        if (publisher) prefix = GetCacheKeyWithTenantPrefix(prefix);
        if (string.IsNullOrWhiteSpace(prefix)) throw new InvalidOperationException("A cache removal requires an owned prefix.");
        if (publisher && _journal?.Enabled == true && !string.IsNullOrEmpty(_journal.CurrentStore()))
            await _journal.InvalidateAsync(_journal.CurrentStore(), prefix, CacheEvent.RemovePrefix);
        foreach (var entry in CacheEntries.Where(x => x.Key.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)))
            _cache.Remove(entry.Key);
        if (publisher)
        {
            await _messageBus.PublishAsync(new MessageEvent { Key = prefix, MessageType = (int)MessageEventType.RemoveByPrefix });
            if (_journal?.Enabled != true) _cacheTracker.AddCacheInvalidation(prefix, CacheEvent.RemovePrefix);
        }
    }

    public override Task Clear(bool publisher = true)
    {
        var prefix = GetCacheKeyWithTenantPrefix("");
        if (string.IsNullOrWhiteSpace(prefix)) throw new InvalidOperationException("Clearing the cache requires the current tenant.");
        // A qualified prefix travels on the wire; recipients never clear their whole process.
        return RemoveByPrefix(publisher ? "" : prefix, publisher);
    }
}
