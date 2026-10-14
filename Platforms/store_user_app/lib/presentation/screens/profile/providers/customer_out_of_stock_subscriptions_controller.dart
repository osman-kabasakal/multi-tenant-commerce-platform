import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/catalog/customer_out_of_stock_subscriptions_model/customer_out_of_stock_subscriptions_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/customer_out_of_stock_subscriptions_model/out_of_stock_subscription_model/out_of_stock_subscription_model.dart';
import 'package:store_user_app/domain/repositories/out_of_stock_subscription/out_of_stock_subscription_repository.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';

part 'customer_out_of_stock_subscriptions_controller.g.dart';

@riverpod
class CustomerOutOfStockSubscriptionsController
    extends _$CustomerOutOfStockSubscriptionsController
    with
        BaseEventListenerProvider<CustomerOutOfStockSubscriptionsModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CustomerOutOfStockSubscriptionsModel> {
  late OutOfStockSubscriptionRepository _outOfStockSubscriptionRepository;

  @override
  FutureOr<CustomerOutOfStockSubscriptionsModel> build() async {
    await registerCorrelation();

    _outOfStockSubscriptionRepository =
        await getIt.getAsync<OutOfStockSubscriptionRepository>();
    initListenar();
    return _loadOutOfStockSubscriptions();
  }

  FutureOr<CustomerOutOfStockSubscriptionsModel> _loadOutOfStockSubscriptions(
      [int pageNumber = 1]) async {
    var outOfStockSubscriptions =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _outOfStockSubscriptionRepository
          .getOutOfStockSubscriptionCustomerSubscriptions(pageNumber),
    );

    if (outOfStockSubscriptions.success) {
      pageNumber = outOfStockSubscriptions!.data!.pagerModel!.pageNumber! + 1;
      return outOfStockSubscriptions.data!;
    }

    throw Exception('Beklenmeyen bir hata oluştu! Lütfen tekrar deneyiniz.');
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async =>
        await _loadOutOfStockSubscriptions(
            state.requireValue.pagerModel!.pageNumber! + 1));
  }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
        () async => await _loadOutOfStockSubscriptions(1));
  }

  Future<void> deleteSubscriptions(List<String> subscriptionIds) async {
    if (subscriptionIds.isEmpty) return;

    try {
      state = const AsyncValue.loading();

      // API'ye silme isteği gönder
      final result =
          await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _outOfStockSubscriptionRepository
            .postOutOfStockSubscriptionCustomerSubscriptions(subscriptionIds),
      );

      if (result?.success ?? false) {
        // Cache'i temizle ve listeyi yenile
        await cacheFreshness();

        // Başarılı silme işlemi sonrası listeyi yenile
        state = AsyncValue.data(result!.data!);
      } else {
        // Hata durumunda mevcut state'i koru ve hata fırlat
        state = AsyncValue.error(
          'Abonelikler silinirken bir hata oluştu.',
          StackTrace.current,
        );
      }
    } catch (e) {
      // Hata durumunda
      state = AsyncValue.error(
          'Beklenmeyen bir hata oluştu: ${e.toString()}', StackTrace.current);
    }
  }

  @override
  void handleEvent(EntityEvent event) async {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        await cacheFreshness();
        state = await AsyncValue.guard(
            () async => await _loadOutOfStockSubscriptions());
      }
    }

    if (event is EntityCreatedEvent<OutOfStockSubscriptionModel>) {
      await cacheFreshness();
      state = await AsyncValue.guard(
          () async => await _loadOutOfStockSubscriptions());
    }
  }
}
