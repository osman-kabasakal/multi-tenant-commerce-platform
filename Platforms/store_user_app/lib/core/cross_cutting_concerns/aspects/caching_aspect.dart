import 'package:injectable/injectable.dart';

import '../../cache/cache_manager.dart';

@lazySingleton
class CachingAspect {
  final CacheManager cache;

  CachingAspect(this.cache);

  Future<T?> cacheOperation<T>({
    required String key,
    required Future<T?> Function() operation,
    Duration? duration,
  }) async {
    // Önbellekte veri var mı kontrol et
    if (duration == null) {
      return await cache.getAsync<T>(key, operation);
    }

    return await cache.getAsyncWithTime<T>(key, operation, duration);
  }
}

// Caching aspect decoratör
class CachingAspectDecorator {
  final String key;
  final Duration cacheFor;

  const CachingAspectDecorator({
    required this.key,
    required this.cacheFor,
  });
}