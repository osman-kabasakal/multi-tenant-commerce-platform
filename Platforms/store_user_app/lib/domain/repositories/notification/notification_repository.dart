import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cross_cutting_concerns/aspects/caching_aspect.dart';
import 'package:store_user_app/core/cross_cutting_concerns/decorators/repository_decorator.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/domain/entities/notification/notification_model.dart';

@injectable
class NotificationRepository extends BaseRepository {
  final Dio _dio;

  NotificationRepository(this._dio, super.decorator, super.eventBus);

  @factoryMethod
  static NotificationRepository create(
    Dio dio,
    CachingAspect cachingAspect,
    RepositoryDecorator decorator,
    EventBus eventBus,
  ) {
    return NotificationRepository(dio, decorator, eventBus);
  }

  // Cache'li metod
  Future<NotificationListResponse> getNotifications({
    required int page,
    required int pageSize,
  }) async {
    return (await decorator.execute(
          operationName: 'notificationList_${page}_${pageSize}',
          cacheKey: null,
          // generateCacheKey('CustomerMessage', [
          //   'List',
          //   page,
          //   pageSize,
          // ]),
          cacheDuration: null,
          operation: () async {
            try {
              final response = await _dio.post<Map<String, dynamic>>(
                '/CustomerMessages/UnreadMessages',
                data: {'page': page, 'pageSize': pageSize},
              );

              if (response.statusCode == 200) {
                return NotificationListResponse.fromJson(response.data!);
              }
              return const NotificationListResponse(data: [], total: 0);
            } catch (e) {
              rethrow;
            }
          },
        )) ??
        const NotificationListResponse(data: [], total: 0);
  }

  Future<NotificationDetailResponse?> getNotificationDetail(
    String notificationId,
  ) async {
    try {
      return (await decorator.execute(
        operationName: 'notificationDetail_$notificationId',
        cacheKey: generateCacheKey('CustomerMessage', [
          'Detail',
          notificationId,
        ]),
        cacheDuration: null,
        operation: () async {
          final response = await _dio.get<Map<String, dynamic>>(
            '/CustomerMessages/GetMessageDetail',
            queryParameters: {'queuedEmailId': notificationId},
          );

          if (response.statusCode == 200) {
            return NotificationDetailResponse.fromJson(response.data!);
          }
          return null;
        },
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      return (await decorator.execute(
            operationName: 'markNotificationAsRead_$notificationId',
            cacheKey: null,
            cacheDuration: null,
            operation: () async {
              final response = await _dio.get<Map<String, dynamic>>(
                '/CustomerMessages/SetMessageRead',
                queryParameters: {'queuedEmailId': notificationId},
              );

              if (response.statusCode == 200 && response.data != null) {
                return response.data!['success'] as bool? ?? false;
              }
              return false;
            },
          )) ??
          false;
    } catch (e) {
      return false;
    }
  }
}
