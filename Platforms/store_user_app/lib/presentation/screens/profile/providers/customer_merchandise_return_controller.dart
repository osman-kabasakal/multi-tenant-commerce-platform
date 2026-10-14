import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_merchandise_returns_model/customer_merchandise_returns_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/domain/repositories/merchandise_return/merchandise_return_repository.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';
part 'customer_merchandise_return_controller.g.dart';

@riverpod
class CustomerMerchandiseReturnController
    extends _$CustomerMerchandiseReturnController
    with
        BaseEventListenerProvider<CustomerMerchandiseReturnsModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CustomerMerchandiseReturnsModel> {
  late MerchandiseReturnRepository _merchandiseReturnRepository;

  @override
  FutureOr<CustomerMerchandiseReturnsModel> build() async {
    await registerCorrelation();
    _merchandiseReturnRepository =
        await getIt.getAsync<MerchandiseReturnRepository>();
    initListenar();
    return await getMerchandiseReturns();
  }

  Future<CustomerMerchandiseReturnsModel> getMerchandiseReturns() async {
    var merchandiseReturns =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _merchandiseReturnRepository
          .getMerchandiseReturnCustomerMerchandiseReturns(),
    );

    if (merchandiseReturns.success) {
      return merchandiseReturns!.data!;
    }
    throw Exception(
        'İadelerinizi çekerken bir hata oluştu! Lütfen tekrar deneyiniz!');
  }

  Future<void> refresh() {
    state = AsyncValue.loading();
    return getMerchandiseReturns()
        .then((value) => state = AsyncValue.data(value));
  }

  @override
  void handleEvent(EntityEvent event) async {
    if (event is EntityCreatedEvent<MerchandiseReturnModel>) {
      await cacheFreshness();
      state = await AsyncValue.guard(() async => await getMerchandiseReturns());
    }

    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        await cacheFreshness();
        state =
            await AsyncValue.guard(() async => await getMerchandiseReturns());
      }
    }
  }
}
