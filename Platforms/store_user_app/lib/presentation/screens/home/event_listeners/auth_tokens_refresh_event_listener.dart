import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_event_listener.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/notification/notification_storage_repository.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';

@Injectable(as: EntityEventListener<AuthTokensRefreshEvent>)
class AuthTokensRefreshEventListener
    extends EntityEventListener<AuthTokensRefreshEvent> {
  @override
  Future<void> onEntityEvent(
    AuthTokensRefreshEvent event,
    CancellationToken cancellationToken,
  ) async {
    var notificationStorage =
        await getIt.getAsync<NotificationStorageRepository>();
    await notificationStorage.clearAllNotifications();

    var notificationCheckerService =
        await getIt.getAsync<NotificationCheckerService>();
    await notificationCheckerService.checkForNewNotifications();

    var componentRespository = await getIt.getAsync<ComponentRepository>();
    var cacheManager = await getIt.getAsync<CacheManager>();
    await cacheManager.removeByPrefix(
      componentRespository.generateCachePrefixForRemoval(
        componentRespository.postSuggestedProductsCacheKeyPrefix,
        event.oldTokens?.email ?? event.oldTokens?.guestId,
      ),
    );
    await cacheManager.removeByPrefix(
      componentRespository.generateCachePrefixForRemoval(
        componentRespository.getPersonalizedProductsCacheKeyPrefix,
        event.oldTokens?.email ?? event.oldTokens?.guestId,
      ),
    );
    await cacheManager.removeByPrefix(
      componentRespository.generateCachePrefixForRemoval(
        componentRespository.postCustomerNavigationCacheKeyPrefix,
        event.oldTokens?.email ?? event.oldTokens?.guestId,
      ),
    );
    await cacheManager.removeByPrefix(
      componentRespository.generateCachePrefixForRemoval(
        componentRespository.postCustomerRecommendedProductsCacheKeyPrefix,
        event.oldTokens?.email ?? event.oldTokens?.guestId,
      ),
    );
  }
}
