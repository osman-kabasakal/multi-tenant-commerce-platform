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
  // Arka planda alınan bildirimler için gerekli işlemler
  await Firebase.initializeApp();
}

@lazySingleton
class FCMService {
  final ComponentRepository _componentRepository;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = LoggerService.logger;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CacheFreshnessService _cacheFreshnessService;
  bool _isInitialized = false;
  final Dio _dio;

  FCMService(
    this._componentRepository,
    this._secureStorage,
    this._dio,
    this._cacheFreshnessService,
  );

  bool get isInitialized => _isInitialized;

  /// FCM servisini başlatır ve konfigüre eder
  Future<void> initialize() async {
    if (LocalDemo.enabled || _isInitialized) return;

    try {
      // if (kDebugMode) {
      //   // Firebase'i başlat
      //   await Firebase.initializeApp(
      //     options: fairebase_options.DefaultFirebaseOptions.currentPlatform,
      //   );
      // } else {
      //   // Firebase'i başlat
      //   await Firebase.initializeApp(
      //     options: fairebase_options.DefaultFirebaseOptions.currentPlatform,
      //   );
      // }

      // Arka plan mesaj işleyicisini ayarla
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // FCM izinlerini al
      await _requestPermissions();

      // Lokal bildirimleri ayarla
      await _setupLocalNotifications();

      // Mesaj dinleyicilerini ayarla
      _setupMessageListeners();

      // FCM token al ve gerekirse sunucuya kaydet
      FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
        if (kDebugMode) {
          _logger.d('FCM Token yenilendi: $token');
        }
        await storeTokenSecurely(token);
        await saveTokenToServer(token);
      });
      var savedToken = await getSecureToken();
      if (savedToken == null) {
        // Eğer token yoksa yeni token al
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          _isInitialized = true;
          await storeTokenSecurely(token);
          await saveTokenToServer(token);

          if (kDebugMode) {
            _logger.d('FCM Token: $token');
          }
        }
      } else {
        _isInitialized = true;
        // Eğer token varsa, sunucuya kaydet
        // await saveTokenToServer(savedToken);
      }

      // Initialize WebSocket connection for cache freshness
      // await _cacheFreshnessService.startWs();
    } catch (e) {
      if (kDebugMode) {
        _logger.e('FCM başlatma hatası: $e');
      }
    }
  }

  Future<void> storeTokenSecurely(String token) async {
    await _secureStorage.write(key: 'fcm_token', value: token);
  }

  Future<String?> getSecureToken() async {
    return await _secureStorage.read(key: 'fcm_token');
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
  void _handleForegroundMessage(RemoteMessage message) {
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
  void _handleAppOpenedFromNotification(RemoteMessage message) {
    if (kDebugMode) {
      _logger.d('Bildirim tıklandı: ${message.notification?.title}');
    }

    var localPath = message.data['local_path'];
    if (localPath != null) {
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
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      _logger.e('FCM token alma hatası: $e');
      return null;
    }
  }

  /// FCM token'ı sunucuya kaydetmek için kullanılabilir
  Future<void> saveTokenToServer(String token) async {
    if (!_isInitialized) {
      _logger.e('FCM henüz başlatılmadı');
      return;
    }
    if (token.isEmpty) {
      _logger.e('Geçersiz FCM token');
      return;
    }
    try {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );
      // Token'ı sunucuya kaydetmek için gerekli API çağrısını yap
      final response = await _dio.post(
        '/PushNotifications/ProcessRegistration',
        queryParameters: {
          'success': settings.authorizationStatus != AuthorizationStatus.denied,
          'value': token,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          _logger.d('Token sunucuya kaydedildi');
        }
      } else {
        if (kDebugMode) {
          _logger.e('Token kaydetme hatası: ${response.data}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Token kaydetme hatası: $e');
      }
    }
  }

  /// Belirli bir konuya abone olur
  Future<void> subscribeToTopic(String topic) async {
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
      print('Error handling notification tap: $e');
      getIt<AppRouter>().pushPath(AppPaths.homeIndex());
    }
  }
}
