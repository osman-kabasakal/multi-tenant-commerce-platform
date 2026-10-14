import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_loyalty_points_model/customer_loyalty_points_model.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';

import '../../../../domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';

part 'customer_loyalty_points_controller.g.dart';

@riverpod
class CustomerLoyaltyPointsController extends _$CustomerLoyaltyPointsController
    with
        BaseEventListenerProvider<CustomerLoyaltyPointsModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CustomerLoyaltyPointsModel> {
  late OrderRepository _orderRepository;
  @override
  FutureOr<CustomerLoyaltyPointsModel> build() async {
    await registerCorrelation();
    _orderRepository = await getIt.getAsync<OrderRepository>();
    initListenar();
    return _loadCustomerLoyaltyPoints();
  }

  FutureOr<CustomerLoyaltyPointsModel> _loadCustomerLoyaltyPoints() async {
    var loyaltyPoints =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _orderRepository.getOrderCustomerLoyaltyPoints(),
    );

    if (loyaltyPoints.success) {
      return loyaltyPoints!.data!;
    }
    throw Exception(
        'Müşteri sadakat puanlarınızı çekerken bir hata oluştu! Lütfen tekrar deneyiniz!');
  }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => await _loadCustomerLoyaltyPoints());
  }

  @override
  void handleEvent(EntityEvent event) async {
    if (event is EntityCreatedEvent<CheckoutStepResponse> ||
        event is EntityCreatedEvent<OrderDetailsModel> ||
        event is EntityUpdatedEvent<OrderDetailsModel>) {
      await cacheFreshness();
      state = await AsyncValue.guard(
          () async => await _loadCustomerLoyaltyPoints());
    }

    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        await cacheFreshness();
        state = await AsyncValue.guard(
            () async => await _loadCustomerLoyaltyPoints());
      }
    }
  }
}
