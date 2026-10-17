import 'package:store_user_app/core/services/cache/cache_change_notice.dart';
import 'package:store_user_app/core/services/cache/cache_refresh_marker.dart';
import 'package:store_user_app/core/services/apns_notification_bridge.dart';
import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
/*********DO NOT DELETE THIS LINE ***********/

// FCM mesajlarını arka planda işlemek için global handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (CacheChangeNotice.push(message.data) != null) {
    await CacheRefreshMarker().mark();
    return;
  }
  await Firebase.initializeApp();
}

@lazySingleton
class FCMService {
  ApnsNotificationBridge? _apns;
  Future<void>? _initializing;
  StreamSubscription<String>? _tokenSubscription;
  bool _messageListenersReady = false;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = LoggerService.logger;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  final Dio _dio;
  final CacheFreshnessService _cacheFreshness;

  FCMService(
    ComponentRepository componentRepository,
    this._secureStorage,
    this._dio,
    this._cacheFreshness,
  );

  bool get isInitialized => _isInitialized;

  /// FCM servisini başlatır ve konfigüre eder
  Future<void> initialize() {
    final pending = _initializing;
    if (pending != null) return pending;
    final operation = _initialize();
    _initializing = operation;
    return operation.whenComplete(() => _initializing = null);
  }

  // Fixed stages remain visible in signed releases without exposing tokens, URLs or response bodies.
  void _registrationDiagnostic(String stage, {bool? authorized, bool? tokenPresent, int? status, Object? error}) {
    debugPrint('PushRegistration stage=$stage authorized=$authorized tokenPresent=$tokenPresent status=$status errorType=${error?.runtimeType}');
  }

  Future<void> _initialize() async {
    if (LocalDemo.enabled) return;
    if (ApnsNotificationBridge.enabled) {
      _registrationDiagnostic('apns_initialize_started');
      try {
        _apns ??= ApnsNotificationBridge(
          onToken: _registerCurrentToken,
          onOpened:
              (data) =>
                  _handleAppOpenedFromNotification(RemoteMessage.fromMap(data)),
          onMessage:
              (data) => _handleForegroundMessage(RemoteMessage.fromMap(data)),
        );
        _isInitialized = true;
        final registration = await _apns!.initialize();
        _registrationDiagnostic('apns_identity_verified', authorized: registration.authorized, tokenPresent: registration.token != null);
        await _apns!.consumeCacheRefresh(
          _cacheFreshness.refreshAfterBackgroundPush,
        );
        if (!registration.authorized) {
          await saveTokenToServer('denied');
        } else if (registration.token != null) {
          await _registerCurrentToken(registration.token!);
        }
      } catch (error) {
        _registrationDiagnostic('apns_initialize_failed', error: error);
        _isInitialized = false;
        _logger.e('APNs registration could not be initialized');
      }
      return;
    }
    if (_isInitialized) {
      // Authentication may have changed the current customer since the last registration.
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) await _registerCurrentToken(token);
      } catch (_) {
        _logger.w(
          'Notification registration will be retried on the next initialization',
        );
      }
      return;
    }
    try {
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      await _requestPermissions();
      await _setupLocalNotifications();
      if (!_messageListenersReady) {
        _setupMessageListeners();
        _messageListenersReady = true;
      }
      _isInitialized = true;
      _tokenSubscription ??= FirebaseMessaging.instance.onTokenRefresh.listen(
        _registerCurrentToken,
      );
      // Query the native SDK and register on every launch, even when secure storage has an old token.
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _registerCurrentToken(token);
    } catch (_) {
      _isInitialized = false;
      _logger.e('Notification registration could not be initialized');
    }
  }

  Future<void> _registerCurrentToken(String token) async {
    _registrationDiagnostic('native_token_received');
    await storeTokenSecurely(token);
    _registrationDiagnostic('token_storage_complete');
    await saveTokenToServer(token);
  }

  Future<RemoteMessage?> getInitialMessage() async {
    if (ApnsNotificationBridge.enabled) {
      final data = await _apns?.initialMessage();
      return data == null ? null : RemoteMessage.fromMap(data);
    }
    return FirebaseMessaging.instance.getInitialMessage();
  }

  Future<void> storeTokenSecurely(String token) async {
    await _secureStorage.write(
      key: ApnsNotificationBridge.enabled ? 'push_token_apns_v1' : 'fcm_token',
      value: token,
    );
  }

  Future<String?> getSecureToken() async {
    return await _secureStorage.read(
      key: ApnsNotificationBridge.enabled ? 'push_token_apns_v1' : 'fcm_token',
    );
  }

  /// FCM bildirimler için izin ister
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      _logger.w('Notification permissions were not granted');
    }
  }

  /// Lokal bildirimleri ayarlar
  Future<void> _setupLocalNotifications() async {
    // Android için kanal oluştur
    var androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Önemli Bildirimler',
      description: 'Bu kanal önemli bildirimler için kullanılır',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
    );

    // Android için bildirim kanalını ayarla
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // İzinleri al
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveBackgroundNotificationResponse:
          _handleLocalNotificationTapped,
      onDidReceiveNotificationResponse: _handleLocalNotificationTapped,
    );
  }

  /// FCM mesaj dinleyicilerini ayarlar
  void _setupMessageListeners() {
    // Foreground mesajları dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Notification tıklama olayını dinle
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleAppOpenedFromNotification(message);
    });
  }

  /// Ön planda gelen mesajları işler
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (message.data['Type'] == 'cache_invalidation') {
      await _cacheFreshness.handlePushData(message.data);
      return;
    }
    _logger.d('Foreground mesajı alındı: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final android = message.notification?.android;
    final iOS = message.notification?.apple;

    if (Platform.isAndroid && android != null) {
      getIt.get<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        try {
          // Action link ve deeplink işleme
          var uri = Uri.tryParse(
            android.clickAction ??
                message.data['action_link'] ??
                AppPaths.homeIndex(),
          );
          var deeplinkService = getIt.get<DeeplinkService>();
          String? localPath;

          if (uri != null) {
            localPath = await deeplinkService.handleIncomingLink(uri);
          } else {
            localPath = AppPaths.homeIndex();
          }

          // Payload'a local path ekle
          Map<String, dynamic> payload = {...message.data};
          if (localPath != null) {
            payload['local_path'] = localPath;
          }

          // Resim işleme, X-STORE-TOKEN ve authorization header'ları ile
          // BigPictureStyleInformation? bigPictureStyleInformation;
          // if (android.imageUrl != null) {
          //   try {
          //     final dio = await getIt.getAsync<Dio>();
          //     final tokens =
          //         await (await getIt.getAsync<AuthService>()).getAccessToken();

          //     final response = await dio.get(
          //       android.imageUrl!,
          //       options: Options(
          //         headers: {
          //           if (tokens != null)
          //             'Authorization': 'Bearer ${tokens.bearerToken}',
          //           if (tokens != null) 'X-STORE-TOKEN': tokens.accessToken,
          //         },
          //         responseType: ResponseType.bytes,
          //       ),
          //     );

          //     if (response.statusCode == 200 && response.data != null) {
          //       final byteArray =
          //           response.data is List<int>
          //               ? response.data as List<int>
          //               : (response.data is String
          //                   ? utf8.encode(response.data as String)
          //                   : null);

          //       if (byteArray != null) {
          //         bigPictureStyleInformation = BigPictureStyleInformation(
          //           ByteArrayAndroidBitmap(Uint8List.fromList(byteArray)),
          //           // largeIcon: ByteArrayAndroidBitmap(
          //           //   Uint8List.fromList(byteArray),
          //           // ),
          //           contentTitle: title,
          //           summaryText: body,
          //         );
          //       }
          //     }
          //   } catch (e) {
          //     _logger.e('Bildirim resmi işleme hatası: $e');
          //   }
          // }

          // Bildirimi göster
          await _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel_yeni',
                'Önemli Bildirimler',
                channelDescription:
                    'Bu kanal önemli bildirimler için kullanılır',
                icon: '@mipmap/ic_launcher',
                importance: Importance.high,
                priority: Priority.high,
                // styleInformation: bigPictureStyleInformation,
                playSound: true,
                enableVibration: true,
                vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
              ),
            ),
            payload: jsonEncode(payload),
          );
        } catch (e) {
          _logger.e('Android bildirim işleme hatası: $e');
        }
      });
    } else if (Platform.isIOS && iOS != null) {
      getIt.get<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        try {
          // Action link ve deeplink işleme
          var uri = Uri.tryParse(
            message.data['action_link'] ?? AppPaths.homeIndex(),
          );
          var deeplinkService = getIt.get<DeeplinkService>();
          String? localPath;

          if (uri != null) {
            localPath = await deeplinkService.handleIncomingLink(uri);
          } else {
            localPath = AppPaths.homeIndex();
          }

          // Payload'a local path ekle
          Map<String, dynamic> payload = {...message.data};
          if (localPath != null) {
            payload['local_path'] = localPath;
          }

          // iOS için resim desteği
          // List<DarwinNotificationAttachment>? attachments;
          // if (message.data['image_url'] != null) {
          //   try {
          //     // X-STORE-TOKEN ve authorization header'ları ile resmi al
          //     final dio = await getIt.getAsync<Dio>();
          //     final tokens =
          //         await (await getIt.getAsync<AuthService>()).getAccessToken();

          //     final response = await dio.get(
          //       message.data['image_url'],
          //       options: Options(
          //         headers: {
          //           if (tokens != null)
          //             'Authorization': 'Bearer ${tokens.bearerToken}',
          //           if (tokens != null) 'X-STORE-TOKEN': tokens.accessToken,
          //         },
          //         responseType: ResponseType.bytes,
          //       ),
          //     );

          //     if (response.statusCode == 200 && response.data != null) {
          //       // Geçici dosyaya kaydet
          //       final directory = await getApplicationDocumentsDirectory();
          //       final imagePath =
          //           '${directory.path}/notification_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
          //       final file = File(imagePath);
          //       if (response.data is List<int>) {
          //         await file.writeAsBytes(response.data as List<int>);
          //         attachments = [
          //           DarwinNotificationAttachment(
          //             imagePath,
          //             identifier: 'image',
          //           ),
          //         ];
          //       }
          //     }
          //   } catch (e) {
          //     _logger.e('iOS bildirim resmi işleme hatası: $e');
          //   }
          // }

          // iOS bildirimi göster
          await _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                // attachments: attachments,
              ),
            ),
            payload: jsonEncode(payload),
          );
        } catch (e) {
          _logger.e('iOS bildirim işleme hatası: $e');
        }
      });
    }
  }

  /// Bildirim tıklandığında çağrılır
  Future<void> _handleAppOpenedFromNotification(RemoteMessage message) async {
    final data = message.data;
    if (data['Type'] == 'cache_invalidation') {
      await _cacheFreshness.handlePushData(data);
      return;
    }
    String? localPath =
        data['local_path'] is String ? data['local_path'] as String : null;
    if (localPath == null && data['action_link'] is String) {
      final uri = Uri.tryParse(data['action_link'] as String);
      if (uri != null) {
        localPath = await getIt<DeeplinkService>().handleIncomingLink(uri);
      }
    }
    if (localPath != null &&
        localPath.startsWith('/') &&
        !localPath.startsWith('//')) {
      getIt<AppRouter>().pushPath(localPath);
    }
  }

  /// Kullanıcının FCM token'ını alır
  Future<String?> getToken() async {
    if (!_isInitialized) {
      _logger.e('FCM henüz başlatılmadı');
      return null;
    }

    try {
      if (ApnsNotificationBridge.enabled) return _apns?.getToken();
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      _logger.e('Notification token could not be read');
      return null;
    }
  }

  /// FCM token'ı sunucuya kaydetmek için kullanılabilir
  Future<void> saveTokenToServer(String token) async {
    _registrationDiagnostic('receiver_attempt');
    if (!_isInitialized) {
      _logger.e('FCM henüz başlatılmadı');
      return;
    }
    if (token.isEmpty) {
      _logger.e('Geçersiz FCM token');
      return;
    }
    try {
      final bool allowed;
      if (ApnsNotificationBridge.enabled) {
        allowed = await _apns?.permission() ?? false;
        if (allowed && !(_apns?.ownsRegistration(token) ?? false)) {
          throw const FormatException('Expected a native APNs registration.');
        }
      } else {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        allowed =
            settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
      }
      _registrationDiagnostic('receiver_permission_checked', authorized: allowed);
      final response = await _dio.post(
        '/PushNotifications/ProcessRegistration',
        data: {
          'success': allowed,
          'value': allowed ? token : 'Permission denied',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      _registrationDiagnostic('receiver_response', status: response.statusCode);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          _logger.d('Token sunucuya kaydedildi');
        }
      } else {
        if (kDebugMode) {
          _logger.e('Token kaydetme isteği reddedildi: ${response.statusCode}');
        }
      }
    } catch (e) {
      _registrationDiagnostic('receiver_failed', status: e is DioException ? e.response?.statusCode : null, error: e);
      if (kDebugMode) {
        _logger.e('Token kaydetme isteği başarısız oldu');
      }
    }
  }

  /// Belirli bir konuya abone olur
  Future<void> subscribeToTopic(String topic) async {
    if (ApnsNotificationBridge.enabled) {
      throw UnsupportedError(
        'Direct APNs uses tenant device registrations instead of FCM topics.',
      );
    }
    if (!_isInitialized) return;

    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      _logger.d('$topic konusuna abone olundu');
    } catch (e) {
      _logger.e('Konuya abone olma hatası: $e');
    }
  }

  /// Belirli bir konudan aboneliği kaldırır
  Future<void> unsubscribeFromTopic(String topic) async {
    if (ApnsNotificationBridge.enabled) {
      throw UnsupportedError(
        'Direct APNs uses tenant device registrations instead of FCM topics.',
      );
    }
    if (!_isInitialized) return;

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      _logger.d('$topic konusundan abonelik kaldırıldı');
    } catch (e) {
      _logger.e('Konudan abonelik kaldırma hatası: $e');
    }
  }

  static void _handleLocalNotificationTapped(NotificationResponse details) {
    if (details.payload == null) {
      return;
    }

    try {
      var payload = jsonDecode(details.payload!);
      var localPath = payload['local_path'];

      if (localPath != null) {
        getIt<AppRouter>().pushPath(localPath);
      } else if (payload['action_link'] != null) {
        // Action link varsa, deeplink servisi ile işle
        getIt.get<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
          final deeplinkService = getIt<DeeplinkService>();
          var uri = Uri.tryParse(payload['action_link']);
          if (uri != null) {
            var path = await deeplinkService.handleIncomingLink(uri);
            if (path != null) {
              getIt<AppRouter>().pushPath(path);
            } else {
              getIt<AppRouter>().pushPath(AppPaths.homeIndex());
            }
          } else {
            getIt<AppRouter>().pushPath(AppPaths.homeIndex());
          }
        });
      } else {
        getIt<AppRouter>().pushPath(AppPaths.homeIndex());
      }
    } catch (e) {
      debugPrint('Notification action could not be opened');
      getIt<AppRouter>().pushPath(AppPaths.homeIndex());
    }
  }
}
