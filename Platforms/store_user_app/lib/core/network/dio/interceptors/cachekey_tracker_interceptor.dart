import 'package:synchronized/synchronized.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:store_user_app/core/constants/app_constants.dart';

/// Interceptor for tracking cache keys and their related remote keys from API responses
class CacheKeyTrackerInterceptor extends Interceptor {
  static const _remoteKeysHeader = 'X-Correlation-ID';

  final Box<List<String>> _keyRelationBox;
  final _writes = Lock();

  CacheKeyTrackerInterceptor(this._keyRelationBox);

  /// Factory method to create the interceptor with initialized Hive box
  static Future<CacheKeyTrackerInterceptor> create() async {
    if (!Hive.isBoxOpen('cache_key_relations')) {
      await Hive.openBox<List<String>>('cache_key_relations');
    }
    return CacheKeyTrackerInterceptor(
      Hive.box<List<String>>('cache_key_relations'),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Get the cache key from the current zone if available
      final cacheKey = Zone.current[cacheKeyZoneKey] as String?;
      if (cacheKey != null) {
        // Store the cache key in the request extras to retrieve it in the response
        options.extra['localCacheKey'] = String.fromCharCodes(
          cacheKey.codeUnits,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CacheKeyTrackerInterceptor.onRequest error: $e');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final local = response.requestOptions.extra['localCacheKey'] as String?;
      if (local != null &&
          response.requestOptions.extra['skipCacheTracking'] != true) {
        await _writes.synchronized(() async {
          final remote =
              response.headers.value(_remoteKeysHeader)?.trim().toLowerCase();
          final valid =
              remote != null &&
              RegExp(
                r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
              ).hasMatch(remote);
          final ids = <String>{
            ...getRelatedRemoteKeys(local),
            if (valid) remote,
          };
          await _keyRelationBox.put(
            local,
            valid && ids.length <= 100 ? ids.toList() : <String>[],
          );
        });
      }
      handler.next(response);
    } catch (error) {
      handler.reject(
        DioException(requestOptions: response.requestOptions, error: error),
      );
    }
  }

  Future<void> forget(String key) =>
      _writes.synchronized(() => _keyRelationBox.delete(key));
  Future<void> clear() async {
    await _writes.synchronized(() => _keyRelationBox.clear());
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
          remoteKeys.any(
            (remoteKey) => remoteKey.startsWith(remoteKeyPrefix),
          )) {
        result.add(key.toString());
      }
    }

    return result;
  }
}
