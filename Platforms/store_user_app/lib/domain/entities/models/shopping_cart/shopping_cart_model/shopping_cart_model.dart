import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'shopping_cart_item_model/shopping_cart_item_model.dart';

import 'checkout_attribute_model/checkout_attribute_model.dart';

import 'discount_box_model/discount_box_model.dart';

import 'gift_voucher_box_model/gift_voucher_box_model.dart';

import '../../../common/user_field/user_field.dart';

part 'shopping_cart_model.freezed.dart';
part 'shopping_cart_model.g.dart';

@freezed
class ShoppingCartModel extends StoreJsonSerializable<ShoppingCartModel>
    with _$ShoppingCartModel {
  factory ShoppingCartModel(
      {@JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'ShowProductImages', includeIfNull: false)
      @Default(false)
      bool? showProductImages,
      @JsonKey(name: 'IsEditable', includeIfNull: false)
      @Default(false)
      bool? isEditable,
      @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
      @Default(false)
      bool? isAllowOnHold,
      @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
      @Default(false)
      bool? termsOfServicePopup,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<ShoppingCartItemModel>? items,
      @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
      String? checkoutAttributeInfo,
      @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
      @Default([])
      List<CheckoutAttributeModel>? checkoutAttributes,
      @JsonKey(name: 'Warnings', includeIfNull: false)
      @Default([])
      List<String>? warnings,
      @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
      String? minOrderSubtotalWarning,
      @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
      @Default(false)
      bool? showCheckoutAsGuestButton,
      @JsonKey(name: 'IsGuest', includeIfNull: false)
      @Default(false)
      bool? isGuest,
      @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
      @Default(false)
      bool? termsOfServiceOnShoppingCartPage,
      @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
      @Default(false)
      bool? termsOfServiceOnOrderConfirmPage,
      @JsonKey(name: 'DiscountBox', includeIfNull: false)
      DiscountBoxModel? discountBox,
      @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
      GiftVoucherBoxModel? giftVoucherBox,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShoppingCartModel;

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingCartModelFromJson(json);
}
