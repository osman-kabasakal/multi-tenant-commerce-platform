import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_event_handler.dart';
import 'package:store_user_app/core/data/events/entity_event_listener.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';

@singleton
class AuthTokensRefreshEventHandler extends EntityEventHandler<AuthTokens> {
  AuthTokensRefreshEventHandler(super.eventBus);

  @override
  Future<void> onEntityEvent(CommonEvent<AuthTokens> event) async {
    if (event is AuthTokensRefreshEvent) {
      var refreshEvent = event;
      if (refreshEvent.oldTokens != null &&
          (refreshEvent.oldTokens?.email != refreshEvent.entity.email ||
              refreshEvent.oldTokens?.guestId != refreshEvent.entity.guestId)) {
        await (await getIt.getAsync<CacheManager>()).removeByPrefix(
            (await getIt.getAsync<AccountRepository>())
                .generateCachePrefixForRemoval('/'));
        var listeners =
            getIt.getAll<EntityEventListener<AuthTokensRefreshEvent>>();
        for (var listener in listeners) {
          getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
            await listener.onEntityEvent(refreshEvent, cancellationToken);
          });
        }
      }
    }
  }

  @disposeMethod
  @override
  void dispose() {
    super.dispose();
  }
}
