import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/services/correlation/correlation_service.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
part 'discounted_list_controller.g.dart';

@riverpod
class DiscountedListController extends _$DiscountedListController
    with
        BaseEventListenerProvider<List<ProductOverviewModel>>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<List<ProductOverviewModel>> {
  @override
  FutureOr<List<ProductOverviewModel>> build() async {
    await registerCorrelation();
    initListenar();
    return await _build();
  }

  Future<List<ProductOverviewModel>> _build() async {
    var compoenentRepository = await getIt.getAsync<ComponentRepository>();
    try {
      var products =
          await correlationService.runRepositoryMethodWithCorrelation(
              correlationId,
              () => compoenentRepository.getPersonalizedProducts(200));
      return products ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> loadState() async {
    state = await AsyncValue.guard(_build);
  }

  @override
  void handleEvent(EntityEvent event) {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
          await loadState();
        });
      }
    }
  }
}
