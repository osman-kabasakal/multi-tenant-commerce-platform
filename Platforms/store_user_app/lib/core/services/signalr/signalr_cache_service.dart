// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';
// import 'package:injectable/injectable.dart';
// import 'package:signalr_netcore/ihub_protocol.dart';
// import 'package:signalr_netcore/signalr_client.dart';
// import 'package:store_user_app/core/data/events/entity_event.dart';
// import 'package:store_user_app/core/data/events/event_bus.dart';
// import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
// import 'package:store_user_app/core/services/auth/auth_service.dart';
// import 'package:http/io_client.dart';
// import 'package:store_user_app/core/services/signalr/app_signalr_http_client.dart';
// import 'package:logging/src/logger.dart';
// import '../../cache/cache_manager.dart';
// import '../../config/app_config.dart';
// import '../../network/dio/interceptors/cachekey_tracker_interceptor.dart';
// import '../logger/logger_service.dart';

// @Singleton(dependsOn: [CacheManager, CacheKeyTrackerInterceptor, AuthService])
// class SignalRCacheService {
//   final CacheManager _cacheManager;
//   final CacheKeyTrackerInterceptor _cacheKeyTracker;
//   final EventBus _eventBus;
//   final AuthService _authService;

//   late final HubConnection _hubConnection;
//   Timer? _reconnectTimer;
//   bool _isConnecting = false;

//   // Hub method names
//   static const String _removeCacheKeyMethod = "RemoveCacheKey";
//   static const String _removeByPrefixMethod = "RemoveByPrefix";

//   late final StreamSubscription<EntityEvent> _streamSubscription;

//   @factoryMethod
//   static Future<SignalRCacheService> create(
//     CacheManager cacheManager,
//     CacheKeyTrackerInterceptor cacheKeyTracker,
//     EventBus eventBus,
//     AuthService authService,
//   ) async {
//     return SignalRCacheService._(
//         cacheManager, cacheKeyTracker, eventBus, authService);
//   }

//   SignalRCacheService._(this._cacheManager, this._cacheKeyTracker,
//       this._eventBus, this._authService) {
//     runWithClient(_initializeConnection, () {
//       final httpClient = HttpClient()
//         ..badCertificateCallback =
//             (X509Certificate cert, String host, int port) => true;

//       return IOClient(httpClient);
//     });
//   }

//   get _headers {
//     var header = MessageHeaders();
//     header.setHeaderValue(
//         'x-store-token', _authService.currentTokens?.accessToken ?? '');
//     return header;
//   }

//   Future<void> _initializeConnection() async {
//     try {
//       final hubUrl = "${AppConfig.instance.apiBaseUrl}/cachehub";

//       // Create hub connection
//       _hubConnection = HubConnectionBuilder()
//           .withUrl(
//         hubUrl,
//         options: HttpConnectionOptions(
//             httpClient: AppSignalRHttpClient(null),
//             skipNegotiation: false,
//             logMessageContent: true,
//             logger: Logger('signalr logger'),
//             accessTokenFactory: () async {
//               return '${_authService.currentTokens?.bearerToken}';
//             },
//             // headers: _headers,
//             requestTimeout: 1000 * 50),
//       )
//           .withAutomaticReconnect(retryDelays: [
//         2000,
//         5000,
//         10000,
//         30000
//       ]) // Retry delays in milliseconds
//           .build();

//       // Set up event handlers
//       _hubConnection.onclose(({error}) => _onDisconnected(error));
//       _hubConnection.onreconnecting(({error}) => _onReconnecting(error));
//       _hubConnection
//           .onreconnected(({connectionId}) => _onReconnected(connectionId));

//       // Register cache invalidation handlers
//       _hubConnection.on(_removeCacheKeyMethod, _handleRemoveCacheKey);
//       _hubConnection.on(_removeByPrefixMethod, _handleRemoveByPrefix);

//       _streamSubscription = _eventBus.stream.listen((event) {
//         if (event is AuthTokensRefreshEvent) {
//           if (event.oldTokens != null &&
//               (event.oldTokens?.email != event.entity.email ||
//                   event.oldTokens?.guestId != event.entity.guestId)) {
//             _hubConnection.stop();
//           }
//         }
//       });

//       // Start connection
//       await _startConnection();
//     } catch (e) {
//       LoggerService.error('Error initializing SignalR connection', e);
//       _scheduleReconnect();
//     }
//   }

//   Future<void> _startConnection() async {
//     if (_isConnecting || _hubConnection.state == HubConnectionState.Connected) {
//       return;
//     }
//     if (_authService.currentTokens == null) {
//       _scheduleReconnect();
//       return;
//     }

//     _isConnecting = true;
//     try {
//       await _hubConnection.start();
//       LoggerService.info('SignalR connection established');
//       _isConnecting = false;
//     } catch (e) {
//       _isConnecting = false;
//       LoggerService.error('Failed to start SignalR connection', e);
//       _scheduleReconnect();
//     }
//   }

//   void _onDisconnected(dynamic error) {
//     if (error != null) {
//       LoggerService.error('SignalR connection closed with error', error);
//     } else {
//       LoggerService.info('SignalR connection closed');
//     }
//     _scheduleReconnect();
//   }

//   void _onReconnecting(dynamic error) {
//     LoggerService.warning('SignalR reconnecting', error);
//   }

//   void _onReconnected(String? connectionId) {
//     LoggerService.info('SignalR reconnected with ID: $connectionId');
//   }

//   void _scheduleReconnect() {
//     _reconnectTimer?.cancel();
//     _reconnectTimer = Timer(const Duration(seconds: 5), () async {
//       if (_hubConnection.state != HubConnectionState.Connected) {
//         await _startConnection();
//       }
//     });
//   }

//   // Handle RemoveCacheKey message from SignalR
//   void _handleRemoveCacheKey(List<Object?>? parameters) async {
//     if (parameters == null || parameters.isEmpty) return;

//     try {
//       final remoteKey = parameters[0].toString();
//       LoggerService.info('SignalR received RemoveCacheKey: $remoteKey');

//       // Find local cache keys related to this remote key
//       final localKeys = _cacheKeyTracker.getLocalKeysForRemoteKey(remoteKey);

//       // Remove each related local cache key
//       for (final localKey in localKeys) {
//         await _cacheManager.removeAsync(localKey);
//         if (kDebugMode) {
//           print('Removed local cache key due to SignalR: $localKey');
//         }
//       }
//     } catch (e) {
//       LoggerService.error('Error handling RemoveCacheKey', e);
//     }
//   }

//   // Handle RemoveByPrefix message from SignalR
//   void _handleRemoveByPrefix(List<Object?>? parameters) async {
//     if (parameters == null || parameters.isEmpty) return;

//     try {
//       final remoteKeyPrefix = parameters[0].toString();
//       LoggerService.info('SignalR received RemoveByPrefix: $remoteKeyPrefix');

//       // Find local cache keys related to remote keys with this prefix
//       final localKeys =
//           _cacheKeyTracker.getLocalKeysForRemoteKeyPrefix(remoteKeyPrefix);

//       // Remove each related local cache key
//       for (final localKey in localKeys) {
//         await _cacheManager.removeAsync(localKey);
//         if (kDebugMode) {
//           print('Removed local cache key due to SignalR prefix: $localKey');
//         }
//       }
//     } catch (e) {
//       LoggerService.error('Error handling RemoveByPrefix', e);
//     }
//   }

//   @disposeMethod
//   Future<void> dispose() async {
//     _reconnectTimer?.cancel();
//     if (_hubConnection.state == HubConnectionState.Connected) {
//       await _hubConnection.stop();
//     }
//     _streamSubscription.cancel();
//   }
// }
