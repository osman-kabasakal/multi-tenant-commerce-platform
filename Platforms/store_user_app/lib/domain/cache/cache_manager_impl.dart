import 'dart:async';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_invalidate_event.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/cache/remote_cache.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_model.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';

@Singleton(as: CacheManager, dependsOn: [RemoteCache])
class CacheManagerImpl implements CacheManager {
  final RemoteCache _remoteCache;
  final EventBus _eventBus;
  final Box<DateTime> _cacheKeysBox;

  CacheManagerImpl._(this._remoteCache, this._cacheKeysBox, this._eventBus);

  @factoryMethod
  static Future<CacheManagerImpl> create(
      RemoteCache remoteCache, EventBus eventBus) async {
    // Open a box to track all cache keys
    if (!Hive.isBoxOpen('cache_keys_index')) {
      await Hive.openBox<DateTime>('cache_keys_index');
    }

    return CacheManagerImpl._(
        remoteCache, Hive.box<DateTime>('cache_keys_index'), eventBus);
  }

  @override
  Future<void> clear({bool publish = true}) async {
    await _remoteCache.clear();
    await _cacheKeysBox.clear();
    _publish(publish, 'all', CacheInvalidateType.all);
  }

  void _publish(bool publish, String? key, CacheInvalidateType type) {
    if (publish) {
      _eventBus.publish(CacheInvalidateEvent(
          entity: CacheInvalidateModel(
        key: key,
        type: type,
      )));
    }
  }

  @override
  Future<T?> getAsync<T>(String key, Future<T?> Function() acquire) async {
    var value = await _remoteCache.get<T>(key);
    if (value == null) {
      value = await acquire.call();
      if (value != null) {
        await _remoteCache.set<T>(key, value);
        _trackCacheKey(key);
      }
    }
    return value;
  }

  @override
  Future<T?> getAsyncWithTime<T>(
      String key, Future<T?> Function() acquire, Duration cacheTime) async {
    var value = await _remoteCache.get<T>(key);
    if (value == null) {
      value = await acquire.call();
      if (value != null) {
        await _remoteCache.set<T>(key, value, cacheTime);
        _trackCacheKey(key);
      }
    }
    return value;
  }

  @override
  Future<void> removeAsync(String key, {bool publish = true}) async {
    await _remoteCache.remove(key);
    await _cacheKeysBox.delete(key);
    _publish(publish, key, CacheInvalidateType.key);
  }

  @override
  Future<void> removeByPrefix(String prefix, {bool publish = true}) async {
    await _remoteCache.removeByPrefix(prefix);

    // Remove tracked keys with this prefix
    final keysToRemove = _cacheKeysBox.keys
        .where((k) => k.toString().startsWith(prefix))
        .toList();

    for (final key in keysToRemove) {
      await _cacheKeysBox.delete(key);
    }

    if (keysToRemove.isNotEmpty) {
      _publish(publish, prefix, CacheInvalidateType.prefix);
    }
  }

  @override
  Future<T?> setAsync<T>(String key, Future<T?> Function() acquire) async {
    var value = await acquire.call();
    if (value != null) {
      await _remoteCache.set<T>(key, value);
      _trackCacheKey(key);
    }
    return value;
  }

  @override
  Future<T?> setAsyncWithTime<T>(
      String key, Future<T?> Function() acquire, Duration cacheTime) async {
    var value = await acquire.call();
    if (value != null) {
      await _remoteCache.set<T>(key, value, cacheTime);
      _trackCacheKey(key);
    }
    return value;
  }

  @override
  Future<List<({String key, DateTime createdDate})>> getAllCacheKeys() async {
    var allKeys = _cacheKeysBox.keys.map((k) => k.toString()).toList();
    var validKeys = <({String key, DateTime createdDate})>[];
    for (var k in allKeys) {
      if (await _remoteCache.isValid(k)) {
        validKeys.add((key: k, createdDate: _cacheKeysBox.get(k)!));
      } else {
        await removeAsync(k);
      }
    }
    return validKeys;
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _remoteCache.dispose();
    if (_cacheKeysBox.isOpen) {
      await _cacheKeysBox.close();
    }
  }

  void _trackCacheKey(String key) {
    _cacheKeysBox.put(key, DateTime.now());
  }
}
