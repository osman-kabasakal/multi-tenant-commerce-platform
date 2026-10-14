import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:store_user_app/core/constants/app_constants.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/repositories/notification/notification_repository.dart';
import 'package:store_user_app/domain/repositories/notification/notification_storage_repository.dart';

class HasMessageEvent extends EntityEvent<bool> {
  HasMessageEvent({required super.entity});
}

/// Periyodik olarak bildirimleri kontrol eden ve yerel bildirim gösteren servis
@lazySingleton
class NotificationCheckerService {
  final NotificationRepository _notificationRepository;
  final NotificationStorageRepository _storageRepository;
  final BackgroundTaskQueue _backgroundTaskQueue;
  final FlutterLocalNotificationsPlugin _localNotifications;

  Timer? _timer;
  DateTime? _lastNotificationTime;
  bool _isInitialized = false;

  NotificationCheckerService(
    this._notificationRepository,
    this._storageRepository,
    this._backgroundTaskQueue,
  ) : _localNotifications = FlutterLocalNotificationsPlugin();

  // factory metodu kaldırıldı, inject constructor kullanılacak

  /// Bildirimleri kontrol etme servisini başlatır
  Future<void> initialize() async {
    if (LocalDemo.enabled || _isInitialized) return;

    // Yerel bildirimleri yapılandır
    await _configureLocalNotifications();

    // Yerel depolamadan okunmamış bildirim kontrolü yap
    await _checkUnreadNotificationsFromStorage();

    // İlk kontrol
    await checkForNewNotifications();

    // Periyodik kontrol zamanlayıcısını başlat (2 dakika)
    _timer = Timer.periodic(const Duration(minutes: 2), (_) {
      checkForNewNotifications();
    });

    _isInitialized = true;
    LoggerService.info('Notification checker service başlatıldı');
  }

  /// Yerel depolamadan okunmamış bildirimleri kontrol eder
  Future<void> _checkUnreadNotificationsFromStorage() async {
    try {
      // Yerel depodan bildirimleri yükle
      final store = await _storageRepository.loadNotificationStore();

      // Okunmamış bildirim var mı kontrol et
      final hasUnreadNotifications = store.notifications.any(
        (notification) =>
            !notification.seenByUser || !notification.readOnServer,
      );
      getIt.get<EventBus>().publish(
        HasMessageEvent(entity: hasUnreadNotifications),
      );

      LoggerService.debug(
        'Yerel depodan okunmamış bildirim kontrolü: $hasUnreadNotifications',
      );
    } catch (e) {
      LoggerService.error(
        'Yerel depodan okunmamış bildirim kontrolü sırasında hata oluştu',
        e,
      );
      // Hata olursa status false olsun
      getIt.get<EventBus>().publish(HasMessageEvent(entity: false));
    }
  }

  /// Yerel bildirimleri yapılandırır
  Future<void> _configureLocalNotifications() async {
    // Android için kanal oluştur
    const androidChannel = AndroidNotificationChannel(
      'messages_channel',
      'Mesajlar',
      description: 'Bu kanal yeni mesaj bildirimleri için kullanılır',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    // Android için bildirim kanalını ayarla
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // Bildirimleri yapılandır
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Yeni bildirimler için sunucuyu kontrol eder
  Future<void> checkForNewNotifications() async {
    if (LocalDemo.enabled) return;
    LoggerService.debug('Yeni bildirimler kontrol ediliyor...');

    try {
      // Arka planda çalıştır
      _backgroundTaskQueue.enqueueTask((cancellationToken) async {
        final response = await _notificationRepository.getNotifications(
          page: 1,
          pageSize: 10,
        );

        if (response.data == null || response.data!.isEmpty) {
          // Sunucuda bildirim yok, yerel depodan okunmamış bildirim kontrolü yap
          await _checkUnreadNotificationsFromStorage();
          return;
        }

        // Sunucudan gelen bildirimleri yerel depoda işle
        final newNotifications = await _storageRepository
            .processNewNotifications(response.data!);

        // Yerel depodan okunmamış bildirimleri kontrol et (daha kapsamlı)
        await _checkUnreadNotificationsFromStorage();

        // Yeni bildirimler için yerel bildirim göster
        if (newNotifications.isNotEmpty) {
          // Son bildirim zamanını kontrol et (spam önleme)
          if (_shouldShowNotification()) {
            await _showLocalNotification(newNotifications.first);
            _lastNotificationTime = DateTime.now();

            for (var not in newNotifications) {
              // Bildirimin gösterildiğini kaydet
              if (not.id != null) {
                await _storageRepository.markNotificationShown(not.id!);
              }
            }
          }
        }

        // Belirli bir yaşın üzerindeki bildirimleri temizle (örn. 30 gün)
        await _storageRepository.cleanupOldNotifications();
      });
    } catch (e) {
      LoggerService.error('Bildirim kontrolü sırasında hata oluştu', e);
    }
  }

  /// Bildirim gösterilmeli mi kontrol eder (spam önleme)
  bool _shouldShowNotification() {
    // Son bildirimden bu yana en az 5 dakika geçmiş olmalı
    if (_lastNotificationTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(_lastNotificationTime!);
    return difference.inMinutes >= 5;
  }

  /// Yerel bildirim gösterir
  Future<void> _showLocalNotification(QueuedEmail notification) async {
    await _localNotifications.show(
      notification.hashCode,
      notification.subject ?? 'Yeni Bildirim',
      'Yeni bir mesajınız var. Okumak için tıklayın.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'messages_channel',
          'Mesajlar',
          channelDescription:
              'Bu kanal yeni mesaj bildirimleri için kullanılır',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload:
          notification.id != null
              ? jsonEncode({'notificationId': notification.id})
              : null,
    );

    LoggerService.info('Yerel bildirim gösterildi: ${notification.subject}');
  }

  /// Bildirime tıklandığında çağrılır
  void _onNotificationTapped(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final payloadData =
            jsonDecode(response.payload!) as Map<String, dynamic>;
        final notificationId = payloadData['notificationId'] as String?;

        if (notificationId != null) {
          LoggerService.debug('Bildirime tıklandı: $notificationId');

          // Bildirime tıklandığında yerel depolamada 'görüldü' olarak işaretle
          _storageRepository.markNotificationSeen(notificationId);

          // Bildirim detay sayfasına yönlendir
          getIt<AppRouter>().push(
            NotificationDetailRoute(notificationId: notificationId),
          );
        }
      }
    } catch (e) {
      LoggerService.error('Bildirim işleme hatası', e);
    }
  }

  /// Servisi durdurur
  @disposeMethod
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isInitialized = false;
    LoggerService.info('Notification checker service durduruldu');
  }
}
