import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/shopping_cart/shopping_cart_data_source.dart';
import '../../entities/models/shopping_cart/mini_shopping_cart_model/mini_shopping_cart_model.dart';
import '../../entities/anonymous_type__a25_e79_e1/anonymous_type__a25_e79_e1.dart';
import '../../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../../entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';
import '../../entities/models/shopping_cart/order_totals_model/order_totals_model.dart';
import '../../entities/anonymous_type_6_f488518/anonymous_type_6_f488518.dart';
import '../../entities/anonymous_type_845_badbc/anonymous_type_845_badbc.dart';
import '../../entities/anonymous_type__f96_d6_eb9/anonymous_type__f96_d6_eb9.dart';
import '../../entities/anonymous_type__ef661507/anonymous_type__ef661507.dart';
import '../../entities/models/shopping_cart/checkout_attribute_selected_model/checkout_attribute_selected_model.dart';
import '../../entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import '../../entities/models/shopping_cart/delete_cart_item_model/delete_cart_item_model.dart';
import '../../entities/models/shopping_cart/change_type_cart_item_model/change_type_cart_item_model.dart';
import '../../entities/models/shopping_cart/discount_coupon_model/discount_coupon_model.dart';
import '../../entities/models/shopping_cart/gift_voucher_coupon_model/gift_voucher_coupon_model.dart';
import '../../entities/models/shopping_cart/estimate_shipping_model/estimate_shipping_model.dart';

@lazySingleton
class ShoppingCartRepository extends BaseRepository {
  final ShoppingCartDataSource _dataSource;

  ShoppingCartRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<MiniShoppingCartModel>?>
      getShoppingCartSidebarShoppingCart() async {
    return await decorator.execute<ApiResponse<MiniShoppingCartModel>>(
      operationName: "/ShoppingCart/SidebarShoppingCart",
      cacheKey: generateCacheKey("/ShoppingCart/SidebarShoppingCart", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartSidebarShoppingCart();
      },
    );
  }

  Future<ApiResponse<AnonymousType_A25E79E1>?>
      postShoppingCartCheckoutAttributeChange(
          CheckoutAttributeSelectedModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_A25E79E1>>(
      operationName: "/ShoppingCart/CheckoutAttributeChange",
      cacheKey: null,
      // generateCacheKey("/ShoppingCart/CheckoutAttributeChange", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartCheckoutAttributeChange(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_5F706788>?>
      postShoppingCartUploadFileCheckoutAttribute(
          String attributeId, File file) async {
    return await decorator.execute<ApiResponse<AnonymousType_5F706788>>(
      operationName: "/ShoppingCart/UploadFileCheckoutAttribute",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/UploadFileCheckoutAttribute", [attributeId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartUploadFileCheckoutAttribute(
            attributeId, file);
      },
    );
  }

  Future<ApiResponse<ShoppingCartModel>?> getShoppingCartCart(
      bool checkoutAttributes) async {
    return await decorator.execute<ApiResponse<ShoppingCartModel>>(
      operationName: "/ShoppingCart/Cart",
      cacheKey: generateCacheKey("/ShoppingCart/Cart", [checkoutAttributes]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartCart(checkoutAttributes);
      },
    );
  }

  Future<ApiResponse<ShoppingCartModel>?> getShoppingCartCartSummary() async {
    return await decorator.execute<ApiResponse<ShoppingCartModel>>(
      operationName: "/ShoppingCart/CartSummary",
      cacheKey: generateCacheKey("/ShoppingCart/CartSummary", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartCartSummary();
      },
    );
  }

  Future<ApiResponse<OrderTotalsModel>?> getShoppingCartCartTotal() async {
    return await decorator.execute<ApiResponse<OrderTotalsModel>>(
      operationName: "/ShoppingCart/CartTotal",
      cacheKey: generateCacheKey("/ShoppingCart/CartTotal", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartCartTotal();
      },
    );
  }

  Future<ApiResponse<AnonymousType_6F488518>?> postShoppingCartUpdateQuantity(
      UpdateQuantityModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_6F488518>>(
      operationName: "/ShoppingCart/UpdateQuantity",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/UpdateQuantity", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartUpdateQuantity(model);
      },
    );
  }

  Future<dynamic> getShoppingCartClearCart() async {
    return await decorator.execute<dynamic>(
      operationName: "/ShoppingCart/ClearCart",
      cacheKey: null, //generateCacheKey("/ShoppingCart/ClearCart", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartClearCart();
      },
    );
  }

  Future<ApiResponse<AnonymousType_845BADBC>?> postShoppingCartDeleteCartItem(
      DeleteCartItemModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_845BADBC>>(
      operationName: "/ShoppingCart/DeleteCartItem",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/DeleteCartItem", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartDeleteCartItem(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_F96D6EB9>?>
      postShoppingCartChangeTypeCartItem(ChangeTypeCartItemModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_F96D6EB9>>(
      operationName: "/ShoppingCart/ChangeTypeCartItem",
      cacheKey: generateCacheKey("/ShoppingCart/ChangeTypeCartItem", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartChangeTypeCartItem(model);
      },
    );
  }

  Future<ApiResponse<bool>?> postShoppingCartStartCheckout(
      CheckoutAttributeSelectedModel model) async {
    return await decorator.execute<ApiResponse<bool>>(
      operationName: "/ShoppingCart/StartCheckout",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/StartCheckout", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartStartCheckout(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_EF661507>?>
      postShoppingCartApplyDiscountCoupon(DiscountCouponModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_EF661507>>(
      operationName: "/ShoppingCart/ApplyDiscountCoupon",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/ApplyDiscountCoupon", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartApplyDiscountCoupon(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_EF661507>?> postShoppingCartApplyGiftVoucher(
      GiftVoucherCouponModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_EF661507>>(
      operationName: "/ShoppingCart/ApplyGiftVoucher",
      cacheKey:
          null, // generateCacheKey("/ShoppingCart/ApplyGiftVoucher", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartApplyGiftVoucher(model);
      },
    );
  }

  Future<dynamic> postShoppingCartGetEstimateShipping(
      EstimateShippingModel model) async {
    return await decorator.execute<dynamic>(
      operationName: "/ShoppingCart/GetEstimateShipping",
      cacheKey: generateCacheKey("/ShoppingCart/GetEstimateShipping", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postShoppingCartGetEstimateShipping(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_EF661507>?>
      getShoppingCartRemoveDiscountCoupon(String discountId) async {
    return await decorator.execute<ApiResponse<AnonymousType_EF661507>>(
      operationName: "/ShoppingCart/RemoveDiscountCoupon",
      cacheKey: null,
      // generateCacheKey("/ShoppingCart/RemoveDiscountCoupon", [discountId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getShoppingCartRemoveDiscountCoupon(discountId);
      },
    );
  }

  Future<ApiResponse<AnonymousType_EF661507>?>
      getShoppingCartRemoveGiftVoucherCode(String giftVoucherId) async {
    return await decorator.execute<ApiResponse<AnonymousType_EF661507>>(
      operationName: "/ShoppingCart/RemoveGiftVoucherCode",
      cacheKey:
          null, //generateCacheKey("/ShoppingCart/RemoveGiftVoucherCode", [giftVoucherId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getShoppingCartRemoveGiftVoucherCode(giftVoucherId);
      },
    );
  }
}
