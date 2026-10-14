using Grand.Infrastructure.ConcurretCollections;
using System.Collections.Concurrent;

namespace Grand.Infrastructure.Caching;

public class CacheTracker : ICacheTracker
{
    private readonly ConcurrentDictionary<string, ConcurrentHashSet<string>> _requestCacheDependencies = new();
    
    public void TrackCacheAccess(string correlationId, string cacheKey)
    {
        if (string.IsNullOrEmpty(correlationId)) return;
        
        _requestCacheDependencies.AddOrUpdate(
            correlationId,
            _ => [cacheKey],
            (_, keys) => 
            {
                keys.TryAdd(cacheKey);
                return keys;
            });
    }
    
    public IEnumerable<string> GetCacheKeysForRequest(string correlationId)
    {
        if (_requestCacheDependencies.TryGetValue(correlationId, out var keys))
            return keys;
            
        return Enumerable.Empty<string>();
    }
    
    public IReadOnlyDictionary<string, ConcurrentHashSet<string>> GetRequestCacheDependencies()
    {
        return _requestCacheDependencies;
    }

    public void removeCorrelationId(string correlationId)
    {
        _requestCacheDependencies.Remove(correlationId, out _);
    }
}