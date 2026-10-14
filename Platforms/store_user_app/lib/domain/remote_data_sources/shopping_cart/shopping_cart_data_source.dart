import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
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

part 'shopping_cart_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ShoppingCartDataSource {
  @factoryMethod
  factory ShoppingCartDataSource(Dio dio) {
    return _ShoppingCartDataSource(dio);
  }

  @GET('/ShoppingCart/SidebarShoppingCart')
  @Extra({'responseType': ApiResponse<MiniShoppingCartModel>()})
  Future<ApiResponse<MiniShoppingCartModel>>
  getShoppingCartSidebarShoppingCart();

  @POST('/ShoppingCart/CheckoutAttributeChange')
  @Extra({'responseType': ApiResponse<AnonymousType_A25E79E1>()})
  Future<ApiResponse<AnonymousType_A25E79E1>>
  postShoppingCartCheckoutAttributeChange(
    @Body() CheckoutAttributeSelectedModel model,
  );

  @POST('/ShoppingCart/UploadFileCheckoutAttribute')
  @Extra({'responseType': ApiResponse<AnonymousType_5F706788>()})
  Future<ApiResponse<AnonymousType_5F706788>>
  postShoppingCartUploadFileCheckoutAttribute(
    @Query('attributeId') String attributeId,
    @Part() File file,
  );

  @GET('/ShoppingCart/Cart')
  @Extra({'responseType': ApiResponse<ShoppingCartModel>()})
  Future<ApiResponse<ShoppingCartModel>> getShoppingCartCart(
    @Query('checkoutAttributes') bool checkoutAttributes,
  );

  @GET('/ShoppingCart/CartSummary')
  @Extra({'responseType': ApiResponse<ShoppingCartModel>()})
  Future<ApiResponse<ShoppingCartModel>> getShoppingCartCartSummary();

  @GET('/ShoppingCart/CartTotal')
  @Extra({'responseType': ApiResponse<OrderTotalsModel>()})
  Future<ApiResponse<OrderTotalsModel>> getShoppingCartCartTotal();

  @POST('/ShoppingCart/UpdateQuantity')
  @Extra({'responseType': ApiResponse<AnonymousType_6F488518>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_6F488518>> postShoppingCartUpdateQuantity(
    @Body() UpdateQuantityModel model,
  );

  @GET('/ShoppingCart/ClearCart')
  Future<dynamic> getShoppingCartClearCart();

  @POST('/ShoppingCart/DeleteCartItem')
  @Extra({'responseType': ApiResponse<AnonymousType_845BADBC>()})
  Future<ApiResponse<AnonymousType_845BADBC>> postShoppingCartDeleteCartItem(
    @Body() DeleteCartItemModel model,
  );

  @POST('/ShoppingCart/ChangeTypeCartItem')
  @Extra({'responseType': ApiResponse<AnonymousType_F96D6EB9>()})
  Future<ApiResponse<AnonymousType_F96D6EB9>>
  postShoppingCartChangeTypeCartItem(@Body() ChangeTypeCartItemModel model);

  @POST('/ShoppingCart/StartCheckout')
  @Extra({'responseType': ApiResponse<AnonymousType_EF661507>()})
  Future<ApiResponse<bool>?> postShoppingCartStartCheckout(
    @Body() CheckoutAttributeSelectedModel model,
  );

  @POST('/ShoppingCart/ApplyDiscountCoupon')
  @Extra({'responseType': ApiResponse<AnonymousType_EF661507>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_EF661507>>
  postShoppingCartApplyDiscountCoupon(@Body() DiscountCouponModel model);

  @POST('/ShoppingCart/ApplyGiftVoucher')
  @Extra({'responseType': ApiResponse<AnonymousType_EF661507>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_EF661507>> postShoppingCartApplyGiftVoucher(
    @Body() GiftVoucherCouponModel model,
  );

  @POST('/ShoppingCart/GetEstimateShipping')
  @Extra({'csrf': true})
  Future<dynamic> postShoppingCartGetEstimateShipping(
    @Body() EstimateShippingModel model,
  );

  @GET('/ShoppingCart/RemoveDiscountCoupon')
  @Extra({'responseType': ApiResponse<AnonymousType_EF661507>()})
  Future<ApiResponse<AnonymousType_EF661507>>
  getShoppingCartRemoveDiscountCoupon(@Query('discountId') String discountId);

  @GET('/ShoppingCart/RemoveGiftVoucherCode')
  @Extra({'responseType': ApiResponse<AnonymousType_EF661507>()})
  Future<ApiResponse<AnonymousType_EF661507>>
  getShoppingCartRemoveGiftVoucherCode(
    @Query('giftVoucherId') String giftVoucherId,
  );
}
