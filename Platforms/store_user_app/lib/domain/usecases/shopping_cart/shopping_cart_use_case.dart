import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
import 'package:store_user_app/core/models/errors/api_exceptions.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/gift_voucher_coupon_model/gift_voucher_coupon_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_catalog_cart/product_catalog_cart.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';
import 'package:store_user_app/domain/repositories/action_cart/action_cart_repository.dart';
import 'package:store_user_app/domain/repositories/shopping_cart/shopping_cart_info_repository.dart';
import 'package:store_user_app/domain/repositories/shopping_cart/shopping_cart_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';

import '../../../core/data/events/entity_event.dart';
import '../../../core/data/events/event_bus.dart';
import '../../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../../entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import '../../entities/catalog/attribute_control_type/attribute_control_type.dart';
import '../../entities/common/custom_attribute/custom_attribute.dart';
import '../../entities/models/custom_attribute_model/custom_attribute_model.dart';
import '../../entities/models/shopping_cart/checkout_attribute_selected_model/checkout_attribute_selected_model.dart';
import '../../entities/models/shopping_cart/delete_cart_item_model/delete_cart_item_model.dart';
import '../../entities/models/shopping_cart/discount_coupon_model/discount_coupon_model.dart';
import '../../entities/models/shopping_cart/order_totals_model/order_totals_model.dart';
import '../../entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import '../../entities/models/shopping_cart/shopping_cart_model/checkout_attribute_model/checkout_attribute_model.dart';
import '../../entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import '../../entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'cart_state.dart';

part 'shopping_cart_use_case.g.dart';

@riverpod
class ShoppingCartUseCase extends _$ShoppingCartUseCase
    with CacheInvalidationBase, CacheAwareAsyncProvider<CartState> {
  late ShoppingCartRepository _shoppingCartRepository;
  late ActionCartRepository _actionCartRepository;
  late ShoppingCartInfoRepository _shoppingCartInfoRepository;
  late StreamSubscription<EntityEvent> _eventSubscription;
  late EventBus _eventBus;

  @override
  FutureOr<CartState> build() async {
    await registerCorrelation();

    _shoppingCartRepository = await getIt.getAsync<ShoppingCartRepository>();
    _actionCartRepository = await getIt.getAsync<ActionCartRepository>();
    _shoppingCartInfoRepository= await getIt.getAsync<ShoppingCartInfoRepository>();
    _eventBus = getIt.get<EventBus>();
    _eventSubscription = _eventBus.stream.listen(handleEvent);
    ref.onDispose(() {
      _eventSubscription.cancel();
    });
    return await _fetchCart();
  }

  Future<void> updateQuantity(String cartId, int quantity) async {
    await _updateCartState(() async {
      final response = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async =>
        await _shoppingCartRepository.postShoppingCartUpdateQuantity(
          UpdateQuantityModel(
            shoppingCartId: cartId,
            quantity: quantity,
            shoppingCartType: ShoppingCartType.shoppingCart,
          ),
        ),
      );
      return state.requireValue.copyWith(
        cart: response!.data!.model!,
        orderTotal: await _fetchTotal(),
          shoppingCartInfo: await _fetchShoppingCartInfo(),
      );
    });
  }

  Future<void> removeItem(String cartId) async {
    await _updateCartState(() async {
      var response = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async =>
        await _shoppingCartRepository.postShoppingCartDeleteCartItem(
          DeleteCartItemModel(id: cartId, shoppingCartPage: true),
        ),
      );

      return state.requireValue.copyWith(
        cart: response!.data!.model!,
        orderTotal: await _fetchTotal(),
          shoppingCartInfo: await _fetchShoppingCartInfo(),
      );
    });
  }

  Future<void> clearCart() async {
    await _updateCartState(() async {
      await _shoppingCartRepository.getShoppingCartClearCart();
      return await _fetchCart();
    });
  }

  Future<void> addToCardCatalog(ProductCatalogCart product) async {
    await _updateCartState(() async {
      var response = await _actionCartRepository
          .postActionCartAddProductCatalog(product);

      if (response != null &&
          response.data != null &&
          !response.data!.success!) {
        if (response.data!.message != null &&
            response.data!.message!.isNotEmpty) {
          toast(response.data!.message!);
        } else {
          toast('Ürününüzü sepete eklerken beklenmedik bir hata oluştu.');
        }
      }
      return await _fetchCart();
    });
  }

  Future<void> addToCart(ProductDetailsCart product) async {
    await _updateCartState(() async {
      ApiResponse<AnonymousType_FA6C6C9F>? addToCartResponse =
      await _actionCartRepository.postActionCartAddProductDetails(product);

      if (addToCartResponse != null &&
          addToCartResponse.data != null &&
          !addToCartResponse.data!.success!) {
        if (addToCartResponse.data!.message != null &&
            addToCartResponse.data!.message!.isNotEmpty) {
          toast(addToCartResponse.data!.message!.join('\n'));
        } else {
          toast('Ürününüzü sepete eklerken beklenmedik bir hata oluştu.');
        }
        throw Exception('Ürün sepete eklenemedi.');
      }
      return await _fetchCart();
    });
  }

  Future<void> applyDiscountCoupon(String couponCode) async {
    await _updateCartState(() async {
      try {
        var response = await _shoppingCartRepository
            .postShoppingCartApplyDiscountCoupon(
          DiscountCouponModel(discountCouponCode: couponCode),
        );
        return state.requireValue.copyWith(
          cart: response!.data!.model!,
          orderTotal: await _fetchTotal(),
            shoppingCartInfo: await _fetchShoppingCartInfo(),
        );
      } catch (e) {
        if(e is DioException){
          if (e.error is BadResponseException) {
            var badResponse = e.error as BadResponseException;
            if (badResponse.data is Map<String, dynamic>) {
              var error = badResponse.data as Map<String, dynamic>;
              var values= error.values.map((vmc)=>(vmc is List)? vmc.map((vmcv)=>vmcv.toString()).toList():List<String>.empty()).toList();
              if (values.isNotEmpty) {
                toast(values.map((vm)=>vm.join('\n')).join('\n'));
              } else {
                toast('Kupon kodu geçersiz.');
              }
            }
          }
        }
        return state.requireValue;
      }
    });
  }

  Future<void> removeDiscountCoupon(String discountId) async {
    await _updateCartState(() async {
      try {
        var response = await _shoppingCartRepository
            .getShoppingCartRemoveDiscountCoupon(discountId);
        return state.requireValue.copyWith(
          cart: response!.data!.model,
          orderTotal: await _fetchTotal(),
            shoppingCartInfo: await _fetchShoppingCartInfo(),
        );
      } catch (e) {
        return state.requireValue;
      }
    });
  }

  Future<void> applyGiftVoucher(String couponCode) async {
    await _updateCartState(() async {
      try {
        var response = await _shoppingCartRepository
            .postShoppingCartApplyGiftVoucher(
          GiftVoucherCouponModel(giftVoucherCouponCode: couponCode),
        );
        return state.requireValue.copyWith(
          cart: response!.data!.model,
          orderTotal: await _fetchTotal(),
            shoppingCartInfo: await _fetchShoppingCartInfo(),
        );
      } catch (e) {
        return state.requireValue;
      }
    });
  }

  Future<void> removeGiftVoucher(String giftVoucherId) async {
    await _updateCartState(() async {
      try {
        var response = await _shoppingCartRepository
            .getShoppingCartRemoveGiftVoucherCode(giftVoucherId);
        return state.requireValue.copyWith(
          cart: response!.data!.model!,
          orderTotal: await _fetchTotal(),
            shoppingCartInfo: await _fetchShoppingCartInfo(),
        );
      } catch (e) {
        return state.requireValue;
      }
    });
  }

  Future<AnonymousType_5F706788?> uploadFileCheckoutAttribute(
      String attributeId,
      File file,
      ) async {
    if (state.isLoading) return null;
    try {
      var response = await _shoppingCartRepository
          .postShoppingCartUploadFileCheckoutAttribute(attributeId, file);

      if (response != null &&
          response.data != null &&
          (response.data!.success ?? false)) {
        await setCheckoutAttribute(
          attributeId,
          response.data!.downloadGuid!.toString(),
        );
      }
      return response!.data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return null;
  }

  Future<void> setCheckoutAttribute(String attributeKey, String? value) async {
    await _updateCartState(() async {
      var definedAttributes = [
        ...state.requireValue.selectedCustomAttributes
            .where((a) => a.key != attributeKey)
            .map((m) => CustomAttributeModel(key: m.key, value: m.value)),
      ];

      if (value != null && value.isNotEmpty) {
        definedAttributes.add(
          CustomAttributeModel(key: attributeKey, value: value),
        );
      }
      await _shoppingCartRepository.postShoppingCartCheckoutAttributeChange(
        CheckoutAttributeSelectedModel(attributes: definedAttributes),
      );

      return await _fetchCart(true);
    });
  }

  Future<void> refreshCart() async {
    await _updateCartState(_fetchCart);
  }

  Future<ApiResponse<bool>?> startCheckout() async {
    if (state.isLoading) return null;
    var allRequiredAttributeIsDefined =
        state.requireValue.cart?.checkoutAttributes
            ?.where((a) => a.isRequired ?? false)
            .every(
              (a) =>
          state.requireValue.selectedCustomAttributes.any(
                (s) => s.key == a.id,
          ) &&
              !(state.requireValue.selectedCustomAttributes
                  .firstWhere((s) => s.key == a.id)
                  .value
                  .isEmptyOrNull),
        ) ??
            false;
    if (!allRequiredAttributeIsDefined) {
      var requiredAttributes = state.requireValue.cart?.checkoutAttributes
          ?.where(
            (a) =>
        (a.isRequired ?? false) &&
            !(state.requireValue.selectedCustomAttributes.any(
                  (s) => s.key == a.id,
            ) &&
                !(state.requireValue.selectedCustomAttributes
                    .firstWhere((s) => s.key == a.id)
                    .value
                    .isEmptyOrNull)),
      )
          .map((a) => a.textPrompt ?? a.name ?? '')
          .join(', ');
      toast(
        'Lütfen gerekli olan $requiredAttributes özellik/özellikleri doldurunuz.',
      );
      return null;
    }

    return _shoppingCartRepository.postShoppingCartStartCheckout(
      CheckoutAttributeSelectedModel(
        attributes:
        state.requireValue.selectedCustomAttributes
            .where((a) => !(a.value.isEmptyOrNull))
            .map((a) => CustomAttributeModel(key: a.key, value: a.value))
            .toList(),
      ),
    );
  }

  Future<CartState> _fetchCart([bool onlyAttribute = false]) async {
    try {
      final cart = await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
            () async => await _shoppingCartRepository.getShoppingCartCart(true),
      );
      if (cart == null || cart.data == null) {
        return CartState();
      }

      if (onlyAttribute) {
        return state.hasValue
            ? state.requireValue.copyWith(
          cart: state.requireValue.cart?.copyWith(
            checkoutAttributes: cart.data!.checkoutAttributes,
            checkoutAttributeInfo: cart.data!.checkoutAttributeInfo,
          ),
          selectedCustomAttributes:
          cart.data!.checkoutAttributes == null
              ? []
              : _mapDefinedCheckoutAttributes(
            cart.data!.checkoutAttributes!,
          ),
          orderTotal: await _fetchTotal(),
          shoppingCartInfo: await _fetchShoppingCartInfo()
        )
            : CartState(
          selectedCustomAttributes:
          cart.data!.checkoutAttributes == null
              ? []
              : _mapDefinedCheckoutAttributes(
            cart.data!.checkoutAttributes!,
          ),
          orderTotal: await _fetchTotal(),
            shoppingCartInfo: await _fetchShoppingCartInfo()
        );
      }

      return state.hasValue
          ? state.requireValue.copyWith(
        cart: cart.data!,
        selectedCustomAttributes:
        cart.data!.checkoutAttributes == null
            ? []
            : _mapDefinedCheckoutAttributes(
          cart.data!.checkoutAttributes!,
        ),
        orderTotal: await _fetchTotal(),
          shoppingCartInfo: await _fetchShoppingCartInfo()
      )
          : CartState(
        cart: cart.data!,
        selectedCustomAttributes:
        cart.data!.checkoutAttributes == null
            ? []
            : _mapDefinedCheckoutAttributes(
          cart.data!.checkoutAttributes!,
        ),
        orderTotal: await _fetchTotal(),
          shoppingCartInfo: await _fetchShoppingCartInfo()
      );
    } catch (e) {
      return CartState(error: e.toString());
    }
  }

  Future<OrderTotalsModel?> _fetchTotal() async {
    try {
      var carTotal = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async =>
        await _shoppingCartRepository.getShoppingCartCartTotal(),
      );
      if (carTotal != null && carTotal.data != null) {
        return carTotal.data!;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ShoppingCartInfoResponse?> _fetchShoppingCartInfo() async {
    try {
      var shoppingCartInfo = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async =>
        await _shoppingCartInfoRepository.getShoppingCartSidebarShoppingCart(),
      );
      if (shoppingCartInfo != null && shoppingCartInfo.data != null) {
        return shoppingCartInfo.data!;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<CustomAttribute> _mapDefinedCheckoutAttributes(
      List<CheckoutAttributeModel> checkoutAttributes,
      ) {
    var defaultValueAttributes =
    checkoutAttributes
        .where(
          (a) =>
      (a.attributeControlType == AttributeControlType.textBox ||
          a.attributeControlType ==
              AttributeControlType.multilineTextbox ||
          a.attributeControlType ==
              AttributeControlType.datepicker ||
          a.attributeControlType ==
              AttributeControlType.fileUpload) &&
          (a.defaultValue != null && a.defaultValue!.isNotEmpty),
    )
        .map((a) => CustomAttribute(key: a.id, value: a.defaultValue))
        .toList();

    var preselectedAttributes = checkoutAttributes
        .where(
          (a) =>
      (a.attributeControlType == AttributeControlType.dropdownList ||
          a.attributeControlType == AttributeControlType.radioList ||
          a.attributeControlType == AttributeControlType.checkboxes ||
          a.attributeControlType ==
              AttributeControlType.readonlyCheckboxes ||
          a.attributeControlType == AttributeControlType.colorSquares ||
          a.attributeControlType ==
              AttributeControlType.imageSquares) &&
          ((a.values?.any((x) => (x.isPreSelected ?? false))) ?? false),
    )
        .map(
          (a) => CustomAttribute(
        key: a.id,
        value: a.values!
            .where((x) => (x.isPreSelected ?? false))
            .map((x) => x.id)
            .join(','),
      ),
    );

    defaultValueAttributes.addAll(preselectedAttributes);
    return defaultValueAttributes;
  }

  void handleEvent(EntityEvent event) async {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        if (event.oldTokens != null) {
          if (event.oldTokens!.isGuest &&
              !state.isLoading &&
              state.hasValue &&
              state.requireValue.cart != null &&
              state.requireValue.cart!.items != null &&
              state.requireValue.cart!.items!.isNotEmpty) {
            // for (var item in state.requireValue.cart!.items!) {
            //   await addToCart(ProductDetailsCart(
            //       productId: item.productId,
            //       shoppingCartTypeId: ShoppingCartType.shoppingCart,
            //       enteredQuantity: item.quantity,
            //       customerEnteredPrice: item.attributeInfo));
            // }
          }
          _updateCartState(_fetchCart);
        }
      }
    }

    if (event is EntityCreatedEvent<CheckoutStepResponse>) {
      if (event.entity.success == 1 || event.entity.error == 1) {
        _updateCartState(_fetchCart);
      }
    }

    if (event is EntityCreatedEvent<ShoppingCartItemModel>) {
      _updateCartState(_fetchCart);
    }
  }

  Future<void> _updateCartState(Future<CartState> Function() action) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    await cacheFreshness(
      _shoppingCartRepository.generateCachePrefixForRemoval('/ShoppingCart'),
      CacheInvalidateType.prefix,
      false,
    );
    try {
      state = await AsyncValue.guard(action);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
