import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'stored_notification.freezed.dart';
part 'stored_notification.g.dart';

/// Yerel depolamada saklanacak bildirim bilgilerini içeren model.
/// Sunucudan gelen bildirimlerin hangi durumlarda olduğunu takip etmek için kullanılır.
@freezed
class StoredNotification with _$StoredNotification implements StoreJsonSerializable {
  const factory StoredNotification({
    /// Bildirim ID'si
    required String id,
    
    /// Bildirim başlığı
    String? subject,
    
    /// Bildirim gönderildiği tarih
    DateTime? sentOnUtc,
    
    /// Bildirim oluşturulduğu tarih
    DateTime? createdOnUtc,
    
    /// Yerel bildirim gösterildi mi?
    @Default(false) bool notificationShown,
    
    /// Kullanıcı bildirimi gördü mü?
    @Default(false) bool seenByUser,
    
    /// Bildirim okundu mu? (ReadOnUtc değeri sunucuda var mı)
    @Default(false) bool readOnServer,
    
    /// Bildirim bilgilerinin son güncellenme zamanı
    required DateTime lastUpdated,
  }) = _StoredNotification;

  factory StoredNotification.fromJson(Map<String, dynamic> json) =>
      _$StoredNotificationFromJson(json);
}

/// Tüm bildirim deposunu temsil eden sınıf
@freezed
class NotificationStore with _$NotificationStore implements StoreJsonSerializable {
  const factory NotificationStore({
    /// Saklanan tüm bildirimler
    @Default([]) List<StoredNotification> notifications,
    
    /// Son kontrol edilme zamanı
    DateTime? lastChecked,
  }) = _NotificationStore;

  factory NotificationStore.fromJson(Map<String, dynamic> json) =>
      _$NotificationStoreFromJson(json);
}