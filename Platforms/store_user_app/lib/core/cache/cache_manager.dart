abstract class CacheManager {
  Future<T?> getAsync<T>(String key, Future<T?> Function() acquire);
  Future<T?> getAsyncWithTime<T>(
      String key, Future<T?> Function() acquire, Duration cacheTime);
  Future<T?> setAsync<T>(String key, Future<T?> Function() acquire);
  Future<T?> setAsyncWithTime<T>(
      String key, Future<T?> Function() acquire, Duration cacheTime);
  Future<void> removeAsync(String key, {bool publish = true});
  Future<void> removeByPrefix(String prefix, {bool publish = true});
  Future<void> clear({bool publish = true});
  Future<List<({String key, DateTime createdDate})>> getAllCacheKeys();
  Future<void> dispose();
}
