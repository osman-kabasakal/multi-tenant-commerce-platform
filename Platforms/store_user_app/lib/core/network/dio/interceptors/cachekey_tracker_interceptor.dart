import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:store_user_app/core/constants/app_constants.dart';

/// Interceptor for tracking cache keys and their related remote keys from API responses
class CacheKeyTrackerInterceptor extends Interceptor {
  static const _remoteKeysHeader = 'X-Correlation-ID';

  final Box<List<String>> _keyRelationBox;

  CacheKeyTrackerInterceptor(this._keyRelationBox);

  /// Factory method to create the interceptor with initialized Hive box
  static Future<CacheKeyTrackerInterceptor> create() async {
    if (!Hive.isBoxOpen('cache_key_relations')) {
      await Hive.openBox<List<String>>('cache_key_relations');
    }
    return CacheKeyTrackerInterceptor(
        Hive.box<List<String>>('cache_key_relations'));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Get the cache key from the current zone if available
      final cacheKey = Zone.current[cacheKeyZoneKey] as String?;
      if (cacheKey != null) {
        // Store the cache key in the request extras to retrieve it in the response
        options.extra['localCacheKey'] =
            String.fromCharCodes(cacheKey.codeUnits);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CacheKeyTrackerInterceptor.onRequest error: $e');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final localCacheKey =
          response.requestOptions.extra['localCacheKey'] as String?;

      if (localCacheKey != null &&
          response.headers.map.containsKey(_remoteKeysHeader)) {
        // Extract remote cache keys from header
        final relatedRemoteKeysStr = response.headers.value(_remoteKeysHeader);
        if (relatedRemoteKeysStr != null && relatedRemoteKeysStr.isNotEmpty) {
          try {
            final remoteKeys = [relatedRemoteKeysStr];

            // Store the relation between local cache key and remote keys
            if (remoteKeys.isNotEmpty) {
              try {
                if (localCacheKey.contains('getHomePageCategoriesComponent')) {
                  var debug = true;
                }
                _keyRelationBox.put(localCacheKey, remoteKeys).then((v) => v);
              } catch (e) {
                if (kDebugMode) {
                  debugPrint('Error storing cache key relations: $e');
                }
              }
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('Error decoding remote cache keys: $e');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CacheKeyTrackerInterceptor.onResponse error: $e');
      }
    }

    handler.next(response);
  }

  /// Get related remote keys for a local cache key
  List<String> getRelatedRemoteKeys(String localCacheKey) {
    return _keyRelationBox.get(localCacheKey) ?? [];
  }

  /// Get all local cache keys related to a remote key
  List<String> getLocalKeysForRemoteKey(String remoteKey) {
    final result = <String>[];

    for (final key in _keyRelationBox.keys) {
      final remoteKeys = _keyRelationBox.get(key.toString());
      if (remoteKeys != null && remoteKeys.contains(remoteKey)) {
        result.add(key.toString());
      }
    }

    return result;
  }

  /// Get all local cache keys with a remote key prefix
  List<String> getLocalKeysForRemoteKeyPrefix(String remoteKeyPrefix) {
    final result = <String>[];

    for (final key in _keyRelationBox.keys) {
      final remoteKeys = _keyRelationBox.get(key.toString());
      if (remoteKeys != null &&
          remoteKeys
              .any((remoteKey) => remoteKey.startsWith(remoteKeyPrefix))) {
        result.add(key.toString());
      }
    }

    return result;
  }
}
