import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/entities/notification/stored_notification.dart';

/// Bildirimleri yerel depolamada saklayan ve yöneten repository
@lazySingleton
class NotificationStorageRepository {
  // Bildirimleri saklamak için kullanılacak shared preferences anahtarı
  static const String _storageKey = 'notification_store';
  final SharedPreferences _sharedPreferences;

  NotificationStorageRepository(
    @Named('shared_preferences') this._sharedPreferences,
  );

  @factoryMethod
  static Future<NotificationStorageRepository> create() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return NotificationStorageRepository(sharedPrefs);
  }

  /// Depolanmış tüm bildirimleri yükler
  Future<NotificationStore> loadNotificationStore() async {
    try {
      final String? storeJson = _sharedPreferences.getString(_storageKey);
      if (storeJson == null || storeJson.isEmpty) {
        return const NotificationStore();
      }

      return NotificationStore.fromJson(json.decode(storeJson));
    } catch (e) {
      LoggerService.error('Bildirim deposu yüklenirken hata oluştu', e);
      // Veri bozulmuşsa yeni bir depo oluştur
      return const NotificationStore();
    }
  }

  /// Bildirim deposunu kaydeder
  Future<bool> saveNotificationStore(NotificationStore store) async {
    try {
      final storeJson = json.encode(store.toJson());
      return await _sharedPreferences.setString(_storageKey, storeJson);
    } catch (e) {
      LoggerService.error('Bildirim deposu kaydedilirken hata oluştu', e);
      return false;
    }
  }

  /// QueuedEmail listesinden yerel depodaki bildirimleri güncelleyerek yeni bildirim olup olmadığını belirler
  Future<List<QueuedEmail>> processNewNotifications(
    List<QueuedEmail> notifications,
  ) async {
    final store = await loadNotificationStore();

    // Yeni bildirimleri topla
    final newNotifications = <QueuedEmail>[];
    // Güncellenen bildirim deposu
    final updatedNotifications = List<StoredNotification>.from(
      store.notifications,
    );

    final now = DateTime.now();

    for (final notification in notifications) {
      if (notification.id == null) continue;

      // Bu ID'li bildirim zaten var mı kontrol et
      final existingIndex = updatedNotifications.indexWhere(
        (stored) => stored.id == notification.id,
      );

      if (existingIndex == -1) {
        // Yeni bildirim, depoya ekle ve yeni bildirimler listesine ekle
        updatedNotifications.add(
          StoredNotification(
            id: notification.id!,
            subject: notification.subject,
            sentOnUtc: notification.sentOnUtc,
            createdOnUtc: notification.createdOnUtc,
            readOnServer: notification.readOnUtc != null,
            lastUpdated: now,
          ),
        );

        newNotifications.add(notification);
      } else {
        // Varolan bildirimi güncelle
        final existingNotification = updatedNotifications[existingIndex];

        // Bildirim durumu değişmişse güncelle
        if (notification.readOnUtc != null &&
            !existingNotification.readOnServer) {
          updatedNotifications[existingIndex] = existingNotification.copyWith(
            readOnServer: true,
            lastUpdated: now,
          );
        }

        // Bildirime henüz bildirim gösterilmediyse ve sunucuda okunmadıysa,
        // yeni bildirimler listesine ekle (ama notificationShown flag'ini false olarak bırak)
        if (!existingNotification.notificationShown &&
            notification.readOnUtc == null) {
          newNotifications.add(notification);
        }
      }
    }

    // Son kontrol zamanını güncelle
    final updatedStore = store.copyWith(
      notifications: updatedNotifications,
      lastChecked: now,
    );

    // Güncellenmiş depolu kaydet
    await saveNotificationStore(updatedStore);

    return newNotifications;
  }

  /// Bildirim için bildirim gösterildi olarak işaretle
  Future<void> markNotificationShown(String notificationId) async {
    final store = await loadNotificationStore();
    final updatedNotifications = List<StoredNotification>.from(
      store.notifications,
    );

    final index = updatedNotifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (index != -1) {
      updatedNotifications[index] = updatedNotifications[index].copyWith(
        notificationShown: true,
        lastUpdated: DateTime.now(),
      );

      final updatedStore = store.copyWith(notifications: updatedNotifications);
      await saveNotificationStore(updatedStore);
    }
  }

  /// Kullanıcının bildirimi gördüğünü işaretle
  Future<void> markNotificationSeen(String notificationId) async {
    final store = await loadNotificationStore();
    final updatedNotifications = List<StoredNotification>.from(
      store.notifications,
    );

    final index = updatedNotifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (index != -1) {
      updatedNotifications[index] = updatedNotifications[index].copyWith(
        seenByUser: true,
        lastUpdated: DateTime.now(),
      );

      final updatedStore = store.copyWith(notifications: updatedNotifications);
      await saveNotificationStore(updatedStore);
    }
  }

  /// Tüm notificationları okundu olarak işaretle (sunucuya bildirilmeden)
  Future<void> markAllNotificationsSeen() async {
    final store = await loadNotificationStore();

    final now = DateTime.now();
    final updatedNotifications =
        store.notifications.map((notification) {
          return notification.copyWith(seenByUser: true, lastUpdated: now);
        }).toList();

    final updatedStore = store.copyWith(notifications: updatedNotifications);
    await saveNotificationStore(updatedStore);
  }

  /// Eski bildirimleri depoda temizler
  Future<void> cleanupOldNotifications({
    Duration maxAge = const Duration(days: 30),
  }) async {
    final store = await loadNotificationStore();

    final now = DateTime.now();
    final updatedNotifications =
        store.notifications.where((notification) {
          // Son güncelleme zamanına göre kontrol
          final age = now.difference(notification.lastUpdated);
          return age <= maxAge;
        }).toList();

    // Eğer eski bildirimleri temizlediyse depoya kaydet
    if (updatedNotifications.length != store.notifications.length) {
      final updatedStore = store.copyWith(notifications: updatedNotifications);
      await saveNotificationStore(updatedStore);
    }
  }

  /// Tüm bildirimleri depodan temizler
  Future<void> clearAllNotifications() async {
    await _sharedPreferences.remove(_storageKey);
  }
}
