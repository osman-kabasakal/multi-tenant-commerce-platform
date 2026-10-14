using System.Collections.Concurrent;
using Core.Models.Configs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Primitives;
using SaasManager.Application.Common.Interfaces.Cache;
using SaasManager.Domain.Events;

namespace SaasManager.Infrastructure.Caching;

public class MemoryCacheBase(
    IMemoryCache cache,
    IMediator mediator,
    CacheConfig cacheConfig,
    IHttpContextAccessor httpContextAccessor)
    : ICacheBase
{

    #region Fields

    private bool _disposed;
    private static CancellationTokenSource _resetCacheToken = new();

    protected readonly ConcurrentDictionary<string, SemaphoreSlim> CacheEntries = new();

    #endregion

    #region Methods

    public virtual Task<T?> GetAsync<T>(string key, Func<Task<T>> acquire)
    {
        return GetAsync(key, acquire, cacheConfig.DefaultCacheTimeMinutes);
    }

    public virtual async Task<T?> GetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
    {
        if (httpContextAccessor.HttpContext != null &&
            httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        if (cache.TryGetValue(key, out T? cacheEntry)) return cacheEntry;
        var semaphore = CacheEntries.GetOrAdd(key, _ => new SemaphoreSlim(1, 1));
        await semaphore.WaitAsync();
        try
        {
            if (!cache.TryGetValue(key, out cacheEntry))
            {
                cacheEntry = await acquire();
                cache.Set(key, cacheEntry, GetMemoryCacheEntryOptions(cacheTime));
            }
        }
        finally
        {
            semaphore.Release();
        }

        return cacheEntry;
    }

    public virtual Task<T> SetAsync<T>(string key, Func<Task<T>> acquire)
    {
        return SetAsync(key, acquire, cacheConfig.DefaultCacheTimeMinutes);
    }

    public virtual async Task<T> SetAsync<T>(string key, Func<Task<T>> acquire, int cacheTime)
    {
        if (httpContextAccessor.HttpContext != null &&
            httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        var semaphore = CacheEntries.GetOrAdd(key, _ => new SemaphoreSlim(1, 1));
        await semaphore.WaitAsync();
        try
        {
            var cacheEntry = await acquire();
            cache.Set(key, cacheEntry, GetMemoryCacheEntryOptions(cacheTime));
            return cacheEntry;
        }
        finally
        {
            semaphore.Release();
        }
    }

    public virtual T? Get<T>(string key, Func<T> acquire)
    {
        return Get(key, acquire, cacheConfig.DefaultCacheTimeMinutes);
    }

    public virtual T? Get<T>(string key, Func<T> acquire, int cacheTime)
    {
        if (httpContextAccessor.HttpContext != null &&
            httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        if (cache.TryGetValue(key, out T? cacheEntry)) return cacheEntry;
        var semaphore = CacheEntries.GetOrAdd(key, _ => new SemaphoreSlim(1, 1));
        semaphore.Wait();
        try
        {
            if (!cache.TryGetValue(key, out cacheEntry))
            {
                cacheEntry = acquire();
                cache.Set(key, cacheEntry, GetMemoryCacheEntryOptions(cacheTime));
            }
        }
        finally
        {
            semaphore.Release();
        }

        return cacheEntry;
    }

    public virtual Task RemoveAsync(string key, bool publisher = true)
    {
        if (httpContextAccessor.HttpContext != null &&
            httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                key = storeId.ToString() + "." + key;
        cache.Remove(key);

        if (publisher)
            mediator.Publish(new EntityCacheEvent(key, CacheEvent.RemoveKey));

        return Task.CompletedTask;
    }

    public virtual Task RemoveByPrefix(string prefix, bool publisher = true)
    {
        if (httpContextAccessor.HttpContext != null &&
            httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var storeId))
            if (storeId != null)
                prefix = storeId.ToString() + "." + prefix;
        var entriesToRemove = CacheEntries.Where(x => x.Key.StartsWith(prefix, StringComparison.OrdinalIgnoreCase));
        foreach (var cacheEntries in entriesToRemove) cache.Remove(cacheEntries.Key);

        if (publisher)
            mediator.Publish(new EntityCacheEvent(prefix, CacheEvent.RemovePrefix));

        return Task.CompletedTask;
    }

    public virtual Task Clear(bool publisher = true)
    {
        //clear keys
        foreach (var cacheEntry in CacheEntries.Keys.ToList())
            cache.Remove(cacheEntry);

        //cancel
        _resetCacheToken.Cancel();
        //dispose
        _resetCacheToken.Dispose();

        _resetCacheToken = new CancellationTokenSource();

        return Task.CompletedTask;
    }

    ~MemoryCacheBase()
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
        if (disposing) cache.Dispose();
        _disposed = true;
    }

    #endregion

    #region Utilities

    private MemoryCacheEntryOptions GetMemoryCacheEntryOptions(int cacheTime)
    {
        var options = new MemoryCacheEntryOptions { AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(cacheTime) }
            .AddExpirationToken(new CancellationChangeToken(_resetCacheToken.Token))
            
            .RegisterPostEvictionCallback(PostEvictionCallback);

        return options;
    }

    private void PostEvictionCallback(object key,
        object? value,
        EvictionReason reason,
        object? state)
    {
        if (reason != EvictionReason.Replaced)
            CacheEntries.TryRemove(key.ToString()!, out var _);
    }

    #endregion
}
