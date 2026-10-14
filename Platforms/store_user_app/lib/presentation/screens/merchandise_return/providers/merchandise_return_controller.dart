import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/core/utils/extensions/address_model_extensions.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/order_item_model/order_item_model.dart';
import 'package:store_user_app/domain/repositories/merchandise_return/merchandise_return_repository.dart';

import '../view_models/merchandise_return_view_model.dart';

part 'merchandise_return_controller.g.dart';

@riverpod
class MerchandiseReturnController extends _$MerchandiseReturnController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<MerchandiseReturnViewModel> {
  late MerchandiseReturnRepository _merchandiseReturnRepository;
  @override
  FutureOr<MerchandiseReturnViewModel> build(String orderId) async {
    await registerCorrelation();
    _merchandiseReturnRepository =
        await getIt.getAsync<MerchandiseReturnRepository>();
    var returnModel = await _getMerchandiseReturnModel();

    return MerchandiseReturnViewModel(
      merchandiseReturnModel: returnModel,
      isLoading: false,
      totalSteps: _getTotalSteps(returnModel),
      currentStep: 0,
      returnItems: [],
    );
  }

  int _getTotalSteps(MerchandiseReturnModel model) {
    int steps = 2;

    if (model.showPickupAddress != null && model.showPickupAddress!) {
      steps++;
    }

    if (model.showPickupDate != null && model.showPickupDate!) {
      steps++;
    }

    return steps;
  }

  Future<MerchandiseReturnModel> _getMerchandiseReturnModel() async {
    try {
      final response = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _merchandiseReturnRepository
                .getMerchandiseReturnMerchandiseReturn(orderId),
          );

      if (response != null && response.data != null) {
        return response.data!;
      } else if (response != null &&
          response.isRedirectResponse &&
          response.redirect!.redirectUri != null &&
          response.redirect!.redirectUri!.queryParameters['routeName'] ==
              'HomePage') {
        await getIt<AppRouter>().replacePath(AppPaths.homeIndex());
        return MerchandiseReturnModel();
      }
      throw Exception('Merchandise return could not be loaded');
    } catch (e) {
      throw Exception(
        'An error occurred while loading the merchandise return: $e',
      );
    }
  }

  Future<void> addReturnItem(OrderItemModel orderItem) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        returnItems: [
          ...state.requireValue.returnItems.where((r) => r.id != orderItem.id),
          orderItem,
        ],
      ),
    );
  }

  Future<void> removeReturnItem(OrderItemModel orderItem) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        returnItems: [
          ...state.requireValue.returnItems.where((r) => r.id != orderItem.id),
        ],
      ),
    );
  }

  Future<void> setPickupDate(DateTime pickUpDate) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        merchandiseReturnModel: state.requireValue.merchandiseReturnModel
            .copyWith(pickupDate: pickUpDate),
      ),
    );
  }

  Future<void> setComment(String? comments) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        merchandiseReturnModel: state.requireValue.merchandiseReturnModel
            .copyWith(comments: comments),
      ),
    );
  }

  Future<void> setPickUpExistingAddress(String pickUpAddressId) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        merchandiseReturnModel: state.requireValue.merchandiseReturnModel
            .copyWith(pickupAddressId: pickUpAddressId),
      ),
    );
  }

  Future<void> setPickUpNewAddress(AddressModel newAddress) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        merchandiseReturnModel: state.requireValue.merchandiseReturnModel
            .copyWith(
              merchandiseReturnNewAddress: newAddress,
              pickupAddressId: null,
            ),
      ),
    );
  }

  void stepContinue() {
    if (state.isLoading ||
        !state.hasValue ||
        state.requireValue.currentStep + 1 >
            state.requireValue.totalSteps - 1) {
      return;
    }

    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentStep: state.requireValue.currentStep + 1,
      ),
    );
  }

  void goToStep(int step) {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.data(state.requireValue.copyWith(currentStep: step));
  }

  Future<void> createMerchandiseReturnRequest() async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.loading();
    try {
      var requestModel = state.requireValue.merchandiseReturnModel.copyWith(
        items: state.requireValue.returnItems,
      );

      if (!state.requireValue.merchandiseReturnModel.showPickupAddress! ||
          requestModel.pickupAddressId != null) {
        requestModel = requestModel.copyWith(
          merchandiseReturnNewAddress:
              await (requestModel.merchandiseReturnNewAddress ?? AddressModel())
                  .fillRequiredAddressFields(),
        );
      }

      var response = await _merchandiseReturnRepository
          .postMerchandiseReturnMerchandiseReturn(requestModel);

      if (response != null && response.data != null) {
        var eventBus = getIt.get<EventBus>();

        eventBus.publish(
          EntityCreatedEvent<MerchandiseReturnModel>(entity: response.data!),
        );

        eventBus.publish(
          EntityUpdatedEvent<OrderDetailsModel>(
            oldEntity: OrderDetailsModel(id: orderId),
            entity: OrderDetailsModel(id: orderId),
          ),
        );

        state = AsyncValue.data(
          state.requireValue.copyWith(
            merchandiseReturnModel: response.data!,
            isSubmitting: true,
          ),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.requireValue.copyWith(
          error: 'An error occurred while creating the return request: $e',
        ),
      );
    }
  }
}
