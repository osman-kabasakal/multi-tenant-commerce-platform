using Grand.Infrastructure.ConcurretCollections;
using System;

namespace Grand.Infrastructure.Caching;

public interface ICacheTracker
{
    void TrackCacheAccess(string correlationId, string cacheKey);
    IEnumerable<string> GetCacheKeysForRequest(string correlationId);
    IReadOnlyDictionary<string, ConcurrentHashSet<string>> GetRequestCacheDependencies();

    void removeCorrelationId(string correlationId);
}
