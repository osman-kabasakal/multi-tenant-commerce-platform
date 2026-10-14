import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/add_cart_from_wishlist_model/add_cart_from_wishlist_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/wishlist/wishlist_repository.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart'
    as shopping_cart_item_model;

import '../../../core/data/events/entity_event.dart';
import '../../entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import '../../repositories/action_cart/action_cart_repository.dart';
import 'wish_list_state.dart';

part 'wish_list_use_case.g.dart';

@riverpod
class WishListUseCase extends _$WishListUseCase
    with CacheInvalidationBase, CacheAwareAsyncProvider<WishListState> {
  late WishlistRepository _wishlistRepository;
  late ActionCartRepository _actionCartRepository;
  late StreamSubscription<EntityEvent> _eventSubscription;
  late EventBus _eventBus;

  @override
  FutureOr<WishListState> build() async {
    await registerCorrelation();

    _wishlistRepository = await getIt.getAsync<WishlistRepository>();
    _actionCartRepository = await getIt.getAsync<ActionCartRepository>();
    _eventBus = getIt.get<EventBus>();
    _eventSubscription = _eventBus.stream.listen(handleEvent);

    ref.onDispose(() {
      _eventSubscription.cancel();
    });

    return _fetchCart();
  }

  Future<void> addToWisList(ProductDetailsCart product) async {
    await _updateWishListState(() async {
      await _actionCartRepository.postActionCartAddProductDetails(
        product.copyWith(shoppingCartTypeId: ShoppingCartType.wishlist),
      );
      return await _fetchCart();
    });
  }

  Future<void> updateWishlistItem(ProductDetailsCart product) async {
    await _updateWishListState(() async {
      await _actionCartRepository.postActionCartUpdateItemCart(
        product.copyWith(shoppingCartTypeId: ShoppingCartType.wishlist),
      );
      return await _fetchCart();
    });
  }

  Future<void> updateQuantity(UpdateQuantityModel quantityModel) async {
    await _updateWishListState(() async {
      await _wishlistRepository.postWishlistUpdateQuantity(quantityModel);
      return await _fetchCart();
    });
  }

  Future<void> addToCartFromWishlist(String shoppingCartId) async {
    await _updateWishListState(() async {
      var addToCartResponse = await _wishlistRepository
          .postWishlistAddItemToCartFromWishlist(
            AddCartFromWishlistModel(shoppingCartId: shoppingCartId),
          );
      if (addToCartResponse.success && addToCartResponse!.data!.success!) {
        getIt.get<EventBus>().publish(
          EntityCreatedEvent<shopping_cart_item_model.ShoppingCartItemModel>(
            entity: shopping_cart_item_model.ShoppingCartItemModel(
              productId: addToCartResponse.data!.model?.id,
            ),
          ),
        );
      }
      return await _fetchCart();
    });
  }

  Future<void> removeFromWishListByProductId(String productId) async {
    if (state.isLoading ||
        state.hasError ||
        !state.hasValue ||
        !state.requireValue.wishListItems.containsKey(productId)) {
      return;
    }
    await _updateWishListState(() async {
      var response = await _wishlistRepository
          .getWishlistDeleteItemFromWishlist(
            state.requireValue.wishListItems[productId]!.id!,
          );
      if (response?.data == null || response!.data!.success == false) {
        return state.requireValue;
      }
      return _fetchCart();
    });
  }

  Future<WishListState> _fetchCart() async {
    try {
      final cart = await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _wishlistRepository.getWishlistIndex(),
      );
      if (cart == null || cart.data == null || cart.isRedirectResponse) {
        return WishListState(wisListEnabled: false);
      }

      return WishListState(
        wishList: cart.data!,
        wishListItems: {
          for (var e in cart.data!.items ?? <ShoppingCartItemModel>[])
            e.productId!: e,
        },
        wisListEnabled: true,
      );
    } catch (e) {
      return WishListState(error: e.toString());
    }
  }

  void handleEvent(EntityEvent event) async {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        if (event.oldTokens != null && event.oldTokens!.isGuest) {
          _updateWishListState(_fetchCart);
        }
      }
    }
  }

  Future<void> refresh() async {
    await _updateWishListState(_fetchCart);
  }

  Future<void> _updateWishListState(
    Future<WishListState> Function() action,
  ) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var cacheKeys = await correlationService.getCacheKeysForCorrelation(
      correlationId,
    );
    if (cacheKeys.isEmpty) {
      try {
        state = await AsyncValue.guard(action);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }

    var actionState = await action();
    for (var key in cacheKeys) {
      await cacheFreshness(key, CacheInvalidateType.key);
    }
  }

  Future<WishlistEmailAFriendModel> getEmailAFriendModel() async {
    var componentRepository = await getIt.getAsync<ComponentRepository>();
    var response = await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await componentRepository.getComponentWishlistEmailAFriend(),
    );
    return response ?? WishlistEmailAFriendModel();
  }

  Future<WishlistEmailAFriendModel> emailWishlist(
    WishlistEmailAFriendModel model,
  ) async {
    var response = await _wishlistRepository.postWishlistEmailWishlist(model);
    if (response.success) return response!.data!;

    return model.copyWith(successfullySent: false);
  }

  Future<ProductDetailsModel> getItemCart(String shoppingCartId) async {
    var response = await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async =>
          await _actionCartRepository.getActionCartGetItemCart(shoppingCartId),
    );

    if (response.success && response!.data!.success!) {
      return response.data!.model!;
    }

    throw Exception('Failed to get item cart');
  }
}
