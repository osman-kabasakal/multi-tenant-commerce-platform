import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/stale_cache_item.dart';
import 'package:store_user_app/core/models/cache/stale_cache_query_model.dart';
import 'package:store_user_app/core/models/cache/stale_cache_response.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import '../../cache/cache_manager.dart';
import '../../network/dio/interceptors/cachekey_tracker_interceptor.dart';
import '../logger/logger_service.dart';
import 'cache_change_notice.dart';
import 'cache_refresh_marker.dart';

@Singleton(dependsOn: [CacheManager, Dio])
class CacheFreshnessService with WidgetsBindingObserver {
  final CacheManager _cacheManager;
  final Dio _dio;
  final CacheKeyTrackerInterceptor _tracker;
  final ConnectivityMonitor _connectivity;
  final CacheRefreshMarker _marker;
  final Future<WebSocket?> Function() _connect;
  final Duration _interval;
  Timer? _timer;
  StreamSubscription<dynamic>? _events;
  StreamSubscription<dynamic>? _socketSubscription;
  WebSocket? _socket;
  bool _disposed = false, _running = false, _connecting = false;
  bool _foreground = true;
  int _connectionGeneration = 0;
  int _identityGeneration = 0, _clearedIdentityGeneration = 0;

  @factoryMethod
  static Future<CacheFreshnessService> create(
    CacheManager cache,
    Dio dio,
    CacheKeyTrackerInterceptor tracker,
    ConnectivityMonitor connectivity,
    EventBus events,
  ) async => CacheFreshnessService._(
    cache,
    dio,
    tracker,
    connectivity,
    events,
    CacheRefreshMarker(),
    _connectSocket,
    const Duration(seconds: 30),
  );

  @visibleForTesting
  factory CacheFreshnessService.forTesting(
    CacheManager cache,
    Dio dio,
    CacheKeyTrackerInterceptor tracker,
    ConnectivityMonitor connectivity,
    EventBus events, {
    required CacheRefreshMarker marker,
    required Future<WebSocket?> Function() connect,
    Duration interval = const Duration(milliseconds: 30),
  }) => CacheFreshnessService._(
    cache,
    dio,
    tracker,
    connectivity,
    events,
    marker,
    connect,
    interval,
  );

  CacheFreshnessService._(
    this._cacheManager,
    this._dio,
    this._tracker,
    this._connectivity,
    EventBus events,
    this._marker,
    this._connect,
    this._interval,
  ) {
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _connectivity.connectionStatus.addListener(_availabilityChanged);
    _events = events.stream.listen((event) {
      if (event is AuthSessionEndedEvent) {
        _disconnect();
        _identityGeneration++;
        unawaited(_tick());
      } else if (event is AuthTokensRefreshEvent) {
        _disconnect();
        if (event.oldTokens != null &&
            (event.oldTokens?.email != event.entity.email ||
                event.oldTokens?.guestId != event.entity.guestId)) {
          _identityGeneration++;
        }
        unawaited(_tick());
      }
    });
    _availabilityChanged();
  }

  bool get _available =>
      !_disposed &&
      _foreground &&
      !_connectivity.connectionStatus.value.contains(ConnectivityResult.none);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _availabilityChanged();
  }

  void _availabilityChanged() {
    if (!_available) {
      _timer?.cancel();
      _timer = null;
      _disconnect();
      return;
    }
    _timer ??= Timer.periodic(_interval, (_) => unawaited(_tick()));
    unawaited(_tick());
  }

  Future<void> _tick() async {
    await checkCacheFreshness();
    await startWs();
  }

  static Future<WebSocket?> _connectSocket() async {
    final tokens = await (await getIt.getAsync<AuthService>()).getAccessToken();
    if (tokens?.bearerToken == null || tokens!.bearerToken!.isEmpty) {
      return null;
    }
    return openSocket(
      Uri.parse(AppConfig.instance.apiBaseUrl),
      tokens.bearerToken!,
      tokens.csrfToken,
    );
  }

  @visibleForTesting
  static Future<WebSocket> openSocket(
    Uri origin,
    String bearer,
    String? csrf,
  ) async {
    if (!['http', 'https'].contains(origin.scheme) ||
        origin.userInfo.isNotEmpty ||
        origin.hasQuery ||
        origin.hasFragment) {
      throw ArgumentError('Use a configured HTTP(S) store origin.');
    }
    final uri = origin.replace(
      scheme: origin.scheme == 'https' ? 'wss' : 'ws',
      path: '/api/ws/fcm',
    );
    // The public tenant gateway resolves the server-only store credential. It is never embedded in Flutter.
    final socket = await WebSocket.connect(
      uri.toString(),
      protocols: ['stale-cache-websocket-protocol'],
      headers: {
        'Authorization': 'Bearer $bearer',
        if (LocalDemo.enabled && LocalDemo.tenantHost.isNotEmpty)
          'Host': LocalDemo.tenantHost,
        if (csrf != null) 'X-CSRF-TOKEN': csrf,
      },
    );
    return socket;
  }

  Future<void> startWs() async {
    if (!_available || _socket != null || _connecting) return;
    _connecting = true;
    final generation = _connectionGeneration;
    try {
      if (_clearedIdentityGeneration != _identityGeneration) return;
      if (!_available || generation != _connectionGeneration) return;
      final socket = await _connect();
      if (!_available || generation != _connectionGeneration) {
        await socket?.close();
        return;
      }
      if (socket == null) return;
      _socket = socket;
      _socketSubscription = socket.listen(
        (message) {
          final notice = CacheChangeNotice.socket(message);
          if (notice != null) {
            unawaited(_applyNotice(notice));
          }
        },
        onError: (_) {
          if (generation == _connectionGeneration) _disconnect();
        },
        onDone: () {
          if (generation == _connectionGeneration) _disconnect();
        },
      );
    } catch (_) {
      // The HTTP check remains active; the periodic tick retries with current credentials.
      if (generation == _connectionGeneration) _disconnect();
    } finally {
      if (generation == _connectionGeneration) _connecting = false;
    }
  }

  void _disconnect() {
    _connectionGeneration++;
    _connecting = false;
    final subscription = _socketSubscription;
    _socketSubscription = null;
    if (subscription != null) unawaited(subscription.cancel());
    final socket = _socket;
    _socket = null;
    if (socket != null) {
      unawaited(socket.close().then<void>((_) {}, onError: (_) {}));
    }
  }

  Future<void> _applyNotice(CacheChangeNotice notice) async {
    try {
      if (!_available) {
        await _marker.mark();
        return;
      }
      await processStaleCorrelationIds(
        StaleCacheResponse(
          staleCorrelationIds: notice.ids,
          asOf: notice.timestamp,
        ),
      );
    } catch (_) {
      try {
        await _marker.mark();
      } catch (_) {
        LoggerService.info(
          'Cache change will be verified by the next HTTP check.',
        );
      }
    }
  }

  Future<bool> handlePushData(Map<String, dynamic> data) async {
    final notice = CacheChangeNotice.push(data);
    if (notice == null) return false;
    await _applyNotice(notice);
    return true;
  }

  Future<void> processStaleCorrelationIds(StaleCacheResponse response) async {
    if (_disposed) return;
    final keys = <String>{};
    for (final id in response.staleCorrelationIds) {
      keys.addAll(_tracker.getLocalKeysForRemoteKey(id));
    }
    for (final key in keys) {
      await _cacheManager.removeAsync(key);
      await _tracker.forget(key);
    }
  }

  Future<void> refreshAfterBackgroundPush() => _clear();

  Future<void> _clear() async {
    await _cacheManager.clear();
    await _tracker.clear();
  }

  Future<void> checkCacheFreshness() async {
    if (_running || !_available) return;
    _running = true;
    try {
      while (_clearedIdentityGeneration != _identityGeneration && _available) {
        final generation = _identityGeneration;
        await _clear();
        _clearedIdentityGeneration = generation;
      }
      if (!_available) return;
      await _marker.apply(_clear);
      final correlations = <String, DateTime>{};
      for (final entry in await getAllCacheKeys()) {
        final related = _tracker.getRelatedRemoteKeys(entry.key);
        if (related.isEmpty) {
          await _cacheManager.removeAsync(entry.key);
          continue;
        }
        for (final id in related) {
          correlations.putIfAbsent(id, () => entry.createdDate.toUtc());
        }
      }
      final items =
          correlations.entries
              .map(
                (entry) =>
                    StaleCacheItem(correlationId: entry.key, asOf: entry.value),
              )
              .toList();
      for (var offset = 0; offset < items.length && _available; offset += 50) {
        final end = (offset + 50).clamp(0, items.length);
        final request = StaleCacheQueryModel(
          staleCacheItems: items.sublist(offset, end),
        );
        final response = await _dio.post<Map<String, dynamic>>(
          '/StaleCache/stale-cache-keys',
          data: jsonDecode(jsonEncode(request.toJson())),
          options: Options(extra: {'skipCacheTracking': true}),
        );
        if (response.statusCode == 200 && response.data != null && _available) {
          await processStaleCorrelationIds(
            StaleCacheResponse.fromJson(response.data!),
          );
        }
      }
    } catch (_) {
      LoggerService.info('Cache freshness check will retry when available.');
    } finally {
      _running = false;
    }
  }

  Future<List<({String key, DateTime createdDate})>> getAllCacheKeys() =>
      _cacheManager.getAllCacheKeys();

  @disposeMethod
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    _disconnect();
    if (_events != null) unawaited(_events!.cancel());
    _connectivity.connectionStatus.removeListener(_availabilityChanged);
    WidgetsBinding.instance.removeObserver(this);
  }
}
