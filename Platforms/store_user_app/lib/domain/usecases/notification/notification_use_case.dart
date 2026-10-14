import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_invalidate_event.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_model.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/entities/notification/notification_model.dart';
import 'package:store_user_app/domain/entities/notification/stored_notification.dart';
import 'package:store_user_app/domain/repositories/notification/notification_repository.dart';
import 'package:store_user_app/domain/repositories/notification/notification_storage_repository.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';

part 'notification_use_case.g.dart';

@riverpod
class NotificationUseCase extends _$NotificationUseCase
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<NotificationListResponse> {
  @override
  Future<NotificationListResponse> build() async {
    await registerCorrelation();
    return await _getNotifications(1, 10);
  }

  Future<NotificationListResponse> _getNotifications(
    int page,
    int pageSize,
  ) async {
    try {
      // Yerel depolamadan tüm bildirimleri al
      final storageRepository =
          await getIt.getAsync<NotificationStorageRepository>();
      var notificationStore = await storageRepository.loadNotificationStore();

      // Yeni bildirimleri sunucudan kontrol et ve yerel depoya ekle
      final repository = await getIt.getAsync<NotificationRepository>();
      final apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await repository.getNotifications(page: 1, pageSize: 50),
          );

      // Sunucudan gelen yeni bildirimleri yerel depoya işle
      if (apiResponse != null &&
          apiResponse.data != null &&
          apiResponse.data!.isNotEmpty) {
        await storageRepository.processNewNotifications(apiResponse.data!);

        // Depodaki bildirimleri tekrar yükle (yeni eklenenlerle birlikte)
        notificationStore = await storageRepository.loadNotificationStore();
      }

      // Depodaki bildirimlerin QueuedEmail listesine dönüştürülmesi
      // Not: StoredNotification modelinden QueuedEmail modeline dönüşüm yapılıyor
      final notifications =
          notificationStore.notifications
              .map(
                (stored) => QueuedEmail(
                  id: stored.id,
                  subject: stored.subject,
                  createdOnUtc: stored.createdOnUtc,
                  sentOnUtc: stored.sentOnUtc,
                  readOnUtc: stored.readOnServer ? DateTime.now() : null,
                ),
              )
              .toList();

      // Tarihe göre sırala (en yeniler üstte)
      notifications.sort(
        (a, b) => (b.createdOnUtc ?? DateTime(2000)).compareTo(
          a.createdOnUtc ?? DateTime(2000),
        ),
      );

      // Sayfalama
      final startIndex = (page - 1) * pageSize;
      final endIndex =
          startIndex + pageSize < notifications.length
              ? startIndex + pageSize
              : notifications.length;

      final paginatedNotifications =
          startIndex < notifications.length
              ? notifications.sublist(startIndex, endIndex)
              : <QueuedEmail>[];

      return NotificationListResponse(
        data: paginatedNotifications,
        total: notifications.length,
      );
    } catch (e) {
      LoggerService.error('Bildirimleri getirirken hata oluştu', e);
      return const NotificationListResponse(data: [], total: 0);
    }
  }

  Future<NotificationListResponse> loadMore(int page, int pageSize) async {
    if (state.isLoading || state.hasError || !state.hasValue) {
      return const NotificationListResponse(data: [], total: 0);
    }

    state = const AsyncValue.loading();

    try {
      final result = await _getNotifications(page, pageSize);

      if (page == 1) {
        // İlk sayfa yükleniyorsa, doğrudan sonuçları kullan
        state = AsyncValue.data(result);
        return result;
      } else if (result.data?.isEmpty ?? true) {
        // Yeni data yoksa mevcut state'i koru
        state = AsyncValue.data(state.requireValue);
        return result;
      }

      // Yeni ve eski verileri birleştir
      state = AsyncValue.data(
        NotificationListResponse(
          data: [...(state.requireValue.data ?? []), ...result.data!],
          total: result.total,
        ),
      );

      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return const NotificationListResponse(data: [], total: 0);
    }
  }

  Future<NotificationDetailResponse?> getNotificationDetail(
    String notificationId,
  ) async {
    final repository = await getIt.getAsync<NotificationRepository>();

    return await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await repository.getNotificationDetail(notificationId),
    );
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      // Sunucuda okundu olarak işaretle
      final repository = await getIt.getAsync<NotificationRepository>();
      final result = await repository.markNotificationAsRead(notificationId);

      // Yerel depolamada bildirimi okundu olarak işaretle
      final storageRepository =
          await getIt.getAsync<NotificationStorageRepository>();

      // StoredNotification'ı güncelle (seenByUser ve readOnServer)
      final store = await storageRepository.loadNotificationStore();
      final notifications = List<StoredNotification>.from(store.notifications);

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(
          seenByUser: true,
          readOnServer: true,
          lastUpdated: DateTime.now(),
        );

        final updatedStore = store.copyWith(notifications: notifications);
        await storageRepository.saveNotificationStore(updatedStore);
        getIt.get<EventBus>().publish(
          HasMessageEvent(
            entity: notifications.any((n) => !n.seenByUser || !n.readOnServer),
          ),
        );
      }

      // Bildirimler değiştiği için cache'i temizle
      if (result) {
        // Sunucudaki cache'i temizle
        await (await getIt.getAsync<CacheManager>()).removeByPrefix(
          repository.generateCachePrefixForRemoval('CustomerMessage'),
        );
      }

      // State'i yenile
      ref.invalidateSelf();

      return result;
    } catch (e) {
      LoggerService.error(
        'Bildirimi okundu olarak işaretlerken hata oluştu',
        e,
      );
      return false;
    }
  }
}
