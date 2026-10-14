import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/entities/models/orders/order_paging_model/order_paging_model.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';

import 'order_list_view_model.dart';

part 'order_list_use_case.g.dart';

@riverpod
class OrderListUseCase extends _$OrderListUseCase
    with CacheInvalidationBase, CacheAwareAsyncProvider<OrderListViewModel> {
  late OrderRepository _orderRepository;
  late StreamSubscription<EntityEvent> _eventSubscription;
  late EventBus _eventBus;

  late CacheManager _remoteCache;
  String get _cacheKey {
    return _orderRepository.generateCacheKey("/Order/CustomerOrders", [
      OrderPagingModel(pageIndex: 0, pageNumber: 1, pageSize: 20),
    ]);
  }

  @override
  FutureOr<OrderListViewModel> build() async {
    await registerCorrelation();

    _orderRepository = await getIt.getAsync<OrderRepository>();

    _eventBus = getIt.get<EventBus>();
    _eventSubscription = _eventBus.stream.listen(handleEvent);

    _remoteCache = await getIt.getAsync<CacheManager>();

    ref.onDispose(() {
      _eventSubscription.cancel();
    });
    return await _getInitialStateModel();
  }

  Future<List<OrderDetailsModel>> _getGuestOrderList() async {
    try {
      return correlationService.runWithCorrelation(correlationId, () async {
        var response =
            (await _remoteCache.getAsync<List<OrderDetailsModel>>(
              _cacheKey,
              () async => [],
            )) ??
            [];

        await correlationService.setCurrentCacheKey(_cacheKey);
        return response;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }

      return [];
    }
  }

  Future<OrderListViewModel> _getInitialStateModel() async {
    try {
      var currentUser = await getIt.getAsync<AuthService>();
      if (currentUser.currentTokens?.isGuest ?? false) {
        return OrderListViewModel(
          isLoading: false,
          orders: await _getGuestOrderList(),
          pagingContext: OrderPagingModel(hasNextPage: false),
        );
      }
      var orderList = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderCustomerOrders(
              OrderPagingModel(pageIndex: 0, pageNumber: 1, pageSize: 20),
            ),
          );
      return OrderListViewModel(
        isLoading: false,
        customerOrderListModel: orderList?.data,
        orders: orderList?.data?.orders ?? [],
        pagingContext: orderList?.data?.pagingContext,
      );
    } catch (e) {
      return OrderListViewModel();
    }
  }

  Future<void> loadOrders({int pageNumber = 1, int pageSize = 20}) async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true));
    try {
      var currentUser = await getIt.getAsync<AuthService>();
      if ((currentUser.currentTokens?.isGuest ?? false)) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            orders: await _getGuestOrderList(),
            pagingContext: OrderPagingModel(hasNextPage: false),
          ),
        );
        return;
      }
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderCustomerOrders(
              OrderPagingModel(
                pageIndex: pageNumber - 1,
                pageNumber: pageNumber,
                pageSize: pageSize,
              ),
            ),
          );
      if (apiResponse != null && apiResponse.data != null) {
        var orders = state.requireValue.orders.toList();
        orders.addAll(apiResponse.data?.orders ?? []);

        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            customerOrderListModel: apiResponse.data,
            pagingContext: apiResponse.data?.pagingContext,
            orders: orders,
          ),
        );
        return;
      }
      state = AsyncValue.data(state.requireValue.copyWith(isLoading: false));
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(isLoading: false));
    }
  }

  Future<void> refreshOrders() async {
    var userService = await getIt.getAsync<AuthService>();
    if (userService.currentTokens?.isGuest ?? false) {
      state = AsyncValue.data(
        state.requireValue.copyWith(isLoading: true, orders: []),
      );
      await loadOrders();
      return;
    }
    state = AsyncValue.data(
      state.requireValue.copyWith(isLoading: true, orders: []),
    );
    await cacheFreshness();
  }

  Future<void> loadMoreOrder() async {
    if (state.isLoading ||
        !state.hasValue ||
        (state.requireValue.pagingContext?.hasNextPage ?? false) == false) {
      return;
    }
    await loadOrders(
      pageNumber: (state.requireValue.pagingContext?.pageNumber ?? 1) + 1,
      pageSize: state.requireValue.pagingContext?.pageSize ?? 20,
    );
  }

  void handleEvent(EntityEvent event) async {
    if (event is EntityCreatedEvent<CheckoutStepResponse>) {
      await cacheFreshness();
      // await _remoteCache.removeByPrefix(
      //   _orderRepository.generateCachePrefixForRemoval('/Order'),
      // );
      // await _cacheFreshness();
      // if (event.entity.success == 1 || event.entity.error == 1) {
      //   state = state = AsyncValue.data(state.requireValue.copyWith(
      //     isLoading: true,
      //     orders: [],
      //   ));
      //   await loadOrders();
      // }
    }

    if (event is EntityCreatedEvent<OrderDetailsModel> ||
        event is EntityUpdatedEvent<OrderDetailsModel>) {
      await cacheFreshness();

      // await _remoteCache.removeByPrefix(
      //   _orderRepository.generateCachePrefixForRemoval('/Order'),
      // );
      // await _cacheFreshness();
      // state = state = AsyncValue.data(state.requireValue.copyWith(
      //   isLoading: true,
      //   orders: [],
      // ));
      // await loadOrders();
    }

    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        // await _remoteCache.removeByPrefix(
        //   _orderRepository.generateCachePrefixForRemoval('/'),
        // );
        await cacheFreshness();
        // await _cacheFreshness();
        // state = state = AsyncValue.data(state.requireValue.copyWith(
        //   isLoading: true,
        //   orders: [],
        // ));
        // await loadOrders();
      }
    }
  }
}
