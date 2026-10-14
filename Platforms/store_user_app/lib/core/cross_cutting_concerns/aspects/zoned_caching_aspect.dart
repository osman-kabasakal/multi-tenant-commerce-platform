import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:store_user_app/core/constants/app_constants.dart';

import '../../cache/cache_manager.dart';
import 'caching_aspect.dart';

/// Enhanced caching aspect that integrates with Zone values for cache key tracking
@lazySingleton
class ZonedCachingAspect extends CachingAspect {
  ZonedCachingAspect(super.cache);

  @factoryMethod
  static ZonedCachingAspect factorySingleton(CacheManager cache) {
    return ZonedCachingAspect(cache);
  }

  @override
  Future<T?> cacheOperation<T>({
    required String key,
    required Future<T?> Function() operation,
    Duration? duration,
  }) async {
    // Store the cache key in the current zone for tracking
    return await runZoned(
      () {
        var zone = Zone.current;
        return zone.run(() async {
          if (duration == null) {
            return await cache.getAsync<T>(key, operation);
          }
          return await cache.getAsyncWithTime<T>(key, operation, duration);
        });
      },
      zoneValues: {
        cacheKeyZoneKey: key,
      },
    );
  }

  /// Get the current cache key from the Zone
  static String? getCurrentCacheKey() {
    try {
      return Zone.current[cacheKeyZoneKey] as String?;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting current cache key: $e');
      }
      return null;
    }
  }
}
