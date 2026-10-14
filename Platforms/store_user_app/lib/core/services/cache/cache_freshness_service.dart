import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
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
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../../cache/cache_manager.dart';
import '../../network/dio/interceptors/cachekey_tracker_interceptor.dart';
import '../logger/logger_service.dart';

/// Service for checking and refreshing stale caches when SignalR might have missed messages
@Singleton(dependsOn: [CacheManager, Dio])
class CacheFreshnessService {
  final CacheManager _cacheManager;
  final Dio _dio;
  final CacheKeyTrackerInterceptor _cacheTrackerInterceptor;
  final ConnectivityMonitor _connectivityMonitor;
  final EventBus _eventBus;

  Timer? _checkTimer;
  bool _isRunning = false;
  WebSocketChannel? _webSocketChannel;
  // Timer? _reconnectTimer;
  // Timer? _refreshConnectionTimer;
  bool _isConnected = false;
  bool _isConnecting = false;

  static const Duration _checkInterval = Duration(seconds: 30);
  // static const Duration _reconnectInterval = Duration(seconds: 30);

  // late StreamSubscription<EntityEvent> _eventStreamSubscription;

  @factoryMethod
  static Future<CacheFreshnessService> create(
    CacheManager cacheManager,
    Dio dio,
    CacheKeyTrackerInterceptor cacheTrackerInterceptor,
    ConnectivityMonitor connectivityMonitor,
    EventBus eventBus,
  ) async {
    var service = CacheFreshnessService._(
      cacheManager,
      dio,
      cacheTrackerInterceptor,
      connectivityMonitor,
      eventBus,
    );

    return service;
  }

  CacheFreshnessService._(
    this._cacheManager,
    this._dio,
    this._cacheTrackerInterceptor,
    this._connectivityMonitor,
    this._eventBus,
  ) {
    _connectivityMonitor.connectionStatus.addListener(
      _handleConnectivityChange,
    );
    // _eventStreamSubscription = _eventBus.stream.listen(handleEvent);
    // _startPeriodicCheck();
  }

  // void handleEvent(EntityEvent event) {
  //   if (event is AuthTokensRefreshEvent) {
  //     if (event.oldTokens != null &&
  //         (event.oldTokens?.bearerRefreshToken !=
  //                 event.entity.bearerRefreshToken ||
  //             event.oldTokens?.bearerToken != event.entity.bearerToken)) {
  //       _checkAndRefreshConnection();
  //     }
  //   }
  // }

  void _handleConnectivityChange() {
    if (_connectivityMonitor.connectionStatus.value.contains(
      ConnectivityResult.none,
    )) {
      // Lost connection, close WebSocket if open
      _closeWebSocket();
    } else {
      // Connection restored, try to connect WebSocket
      checkCacheFreshness().then((_) => _startPeriodicCheck());
    }
  }

  /// Start WebSocket connection to the backend FcmWebSocketController with authentication headers
  Future<void> startWs() async {
    if (_isConnected ||
        _isConnecting ||
        _connectivityMonitor.connectionStatus.value.contains(
          ConnectivityResult.none,
        )) {
      return;
    }

    _isConnecting = true;

    try {
      // Get auth tokens for authentication headers
      final authService = await getIt.getAsync<AuthService>();
      final tokens = await authService.getAccessToken();

      if (tokens == null) {
        LoggerService.error(
          'Unable to get authentication tokens for WebSocket connection',
        );
        _scheduleReconnect();
        return;
      }

      // Create WebSocket URL with query parameters for authentication
      final wsBaseUrl = AppConfig.instance.apiBaseUrl.replaceFirst(
        'http',
        'ws',
      );

      // Add tokens as query parameters instead of headers
      // This is a workaround since WebSocket handshake can accept query parameters

      final wsUrlWithAuth = '$wsBaseUrl/api/ws/fcm';

      LoggerService.info('Connecting to WebSocket with auth parameters');

      // Create a WebSocket connection using IOWebSocketChannel
      // This allows us to use protocols for the connection
      WebSocket socket;

      if (kDebugMode) {
        // In debug mode, use a custom HttpClient that ignores SSL certificate errors
        final securityContext = SecurityContext.defaultContext;

        final httpClient = HttpClient(context: securityContext)
          ..badCertificateCallback = (
            X509Certificate cert,
            String host,
            int port,
          ) {
            LoggerService.info(
              'Ignoring SSL certificate error for $host:$port in debug mode',
            );
            return true; // Accept any certificate in debug mode
          };

        socket = await WebSocket.connect(
          wsUrlWithAuth,
          protocols: [
            'stale-cache-websocket-protocol',
            'sec-websocket-protocol',
          ],
          headers: {
            'X-CSRF-TOKEN': tokens.csrfToken,
            'Authorization': 'Bearer ${tokens.bearerToken}',
          },
          customClient: httpClient,
        );
      } else {
        // In release mode, use the default HttpClient
        socket = await WebSocket.connect(
          wsUrlWithAuth,
          protocols: [
            'stale-cache-websocket-protocol',
            'sec-websocket-protocol',
          ],
          headers: {
            'X-CSRF-TOKEN': tokens.csrfToken,
            'Authorization': 'Bearer ${tokens.bearerToken}',
          },
        );
      }

      _webSocketChannel = IOWebSocketChannel(socket);
      _isConnected = true;
      _isConnecting = false;

      _webSocketChannel!.stream.listen(
        (dynamic message) {
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          LoggerService.error('WebSocket error', error);
          _isConnected = false;
          _scheduleReconnect();
        },
        onDone: () {
          LoggerService.info('WebSocket connection closed');
          _isConnected = false;
          _scheduleReconnect();
        },
      );
    } catch (e, stackTrace) {
      LoggerService.error('Error connecting to WebSocket', e, stackTrace);
      _isConnected = false;
      _isConnecting = false;
      _scheduleReconnect();
    }
  }

  /// Handle messages received from WebSocket
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);

        if (data is Map<String, dynamic> &&
            data.containsKey('correlationIds') &&
            data['correlationIds'] is List) {
          final correlationIds = List<String>.from(data['correlationIds']);
          final timestamp =
              data['timestamp'] != null
                  ? DateTime.parse(data['timestamp'])
                  : DateTime.now().toUtc();

          // Create StaleCacheResponse model from received data
          final responseData = StaleCacheResponse(
            staleCorrelationIds: correlationIds,
            asOf: timestamp,
          );

          // Process stale correlation IDs
          processStaleCorrelationIds(responseData);
        }
      }
    } catch (e) {
      LoggerService.error('Error processing WebSocket message', e);
    }
  }

  /// Process stale correlation IDs received from WebSocket or API
  Future<void> processStaleCorrelationIds(
    StaleCacheResponse responseData,
  ) async {
    try {
      var handleCacheKey = [];
      for (var correlationId in responseData.staleCorrelationIds) {
        var cacheKeys = _cacheTrackerInterceptor.getLocalKeysForRemoteKey(
          correlationId,
        );
        for (var key in cacheKeys) {
          if (!handleCacheKey.contains(key)) {
            await _cacheManager.removeAsync(key);
            if (kDebugMode) {
              print('Removed stale cache key: $key');
            }
          }
        }
      }
      // var localKeys =
      //     responseData.staleCorrelationIds
      //         .map((e) => _cacheTrackerInterceptor.getLocalKeysForRemoteKey(e))
      //         .expand((element) => element)
      //         .toList();

      // // Remove stale cache entries
      // for (final key in localKeys) {
      //   await _cacheManager.removeAsync(key);
      //   if (kDebugMode) {
      //     print('Removed stale cache key: $key');
      //   }
      // }
    } catch (e) {
      LoggerService.error('Error processing stale correlation IDs', e);
    }
  }

  /// Close WebSocket connection
  void _closeWebSocket() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    _isConnected = false;
    _checkTimer?.cancel();
  }

  /// Schedule WebSocket reconnection
  void _scheduleReconnect() {
    // _reconnectTimer?.cancel();
    // _reconnectTimer = Timer(_reconnectInterval, () => startWs());
  }

  /// Check if WebSocket connection needs to be refreshed with updated tokens
  // Future<void> _checkAndRefreshConnection() async {
  //   if (!_isConnected) {
  //     await startWs();
  //     return;
  //   }

  //   try {
  //     final authService = await getIt.getAsync<AuthService>();
  //     final tokens = await authService.getAccessToken();

  //     if (tokens != null && !tokens.shouldRefresh) {
  //       // Tokens are about to expire, close current connection and reconnect with new tokens
  //       LoggerService.info(
  //         'Auth tokens are about to expire, refreshing WebSocket connection',
  //       );
  //       _closeWebSocket();
  //       await startWs();
  //     }
  //   } catch (e) {
  //     LoggerService.error('Error checking WebSocket connection status', e);
  //   }
  // }

  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    // _refreshConnectionTimer?.cancel();

    // Check cache freshness periodically
    _checkTimer = Timer.periodic(_checkInterval, (_) => checkCacheFreshness());

    // Check and refresh WebSocket connection periodically (every 15 minutes)
    // _refreshConnectionTimer = Timer.periodic(
    //   const Duration(minutes: 15),
    //   (_) => _checkAndRefreshConnection(),
    // );
  }

  /// Check cache freshness for all cached keys
  Future<void> checkCacheFreshness() async {
    if (_isRunning ||
        _connectivityMonitor.connectionStatus.value.contains(
          ConnectivityResult.none,
        ))
      return;

    _isRunning = true;
    try {
      // Get all cache keys (this would need to be implemented in CacheManager)
      final cacheKeys = await getAllCacheKeys();

      if (cacheKeys.isEmpty) {
        return;
      }

      // Split keys into batches to avoid too large requests
      const batchSize = 50;
      for (var i = 0; i < cacheKeys.length; i += batchSize) {
        final end =
            (i + batchSize < cacheKeys.length)
                ? i + batchSize
                : cacheKeys.length;
        final batch = cacheKeys.sublist(i, end);

        await _checkBatchFreshness(batch);
      }
    } catch (e) {
      LoggerService.error('Error checking cache freshness', e);
    } finally {
      _isRunning = false;
    }
  }

  /// Check the freshness of a batch of cache keys
  Future<void> _checkBatchFreshness(
    List<({String key, DateTime createdDate})> cacheKeys,
  ) async {
    try {
      var data = cacheKeys.fold(<StaleCacheItem>[], (box, value) {
        box.addAll(
          _cacheTrackerInterceptor
              .getRelatedRemoteKeys(value.key)
              .map(
                (a) => StaleCacheItem(
                  correlationId: a,
                  asOf: value.createdDate.toUtc(),
                ),
              ),
        );

        return box;
      });
      var requestData = StaleCacheQueryModel(staleCacheItems: data);
      final response = await _dio.post<Map<String, dynamic>>(
        '/StaleCache/stale-cache-keys',
        data: jsonDecode(jsonEncode(requestData.toJson())),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = StaleCacheResponse.fromJson(response.data!);
        await processStaleCorrelationIds(responseData);
      }
    } catch (e) {
      LoggerService.error('Error checking batch freshness', e);
    }
  }

  /// Get all cache keys (this would need implementation in your CacheManager)
  Future<List<({String key, DateTime createdDate})>> getAllCacheKeys() async {
    try {
      return await _cacheManager.getAllCacheKeys();
    } catch (e) {
      LoggerService.error('Error getting all cache keys', e);
      return [];
    }
  }

  @disposeMethod
  void dispose() {
    _checkTimer?.cancel();
    // _reconnectTimer?.cancel();
    // _refreshConnectionTimer?.cancel();
    _closeWebSocket();
    _connectivityMonitor.connectionStatus.removeListener(
      _handleConnectivityChange,
    );
    // _eventStreamSubscription.cancel();
  }
}
