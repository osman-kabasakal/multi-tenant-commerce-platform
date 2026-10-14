// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingCartModelImpl _$$ShoppingCartModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingCartModelImpl(
  showSku: json['ShowSku'] as bool? ?? false,
  showProductImages: json['ShowProductImages'] as bool? ?? false,
  isEditable: json['IsEditable'] as bool? ?? false,
  isAllowOnHold: json['IsAllowOnHold'] as bool? ?? false,
  termsOfServicePopup: json['TermsOfServicePopup'] as bool? ?? false,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map(
            (e) => ShoppingCartItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  checkoutAttributeInfo: json['CheckoutAttributeInfo'] as String?,
  checkoutAttributes:
      (json['CheckoutAttributes'] as List<dynamic>?)
          ?.map(
            (e) => CheckoutAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  minOrderSubtotalWarning: json['MinOrderSubtotalWarning'] as String?,
  showCheckoutAsGuestButton:
      json['ShowCheckoutAsGuestButton'] as bool? ?? false,
  isGuest: json['IsGuest'] as bool? ?? false,
  termsOfServiceOnShoppingCartPage:
      json['TermsOfServiceOnShoppingCartPage'] as bool? ?? false,
  termsOfServiceOnOrderConfirmPage:
      json['TermsOfServiceOnOrderConfirmPage'] as bool? ?? false,
  discountBox:
      json['DiscountBox'] == null
          ? null
          : DiscountBoxModel.fromJson(
            json['DiscountBox'] as Map<String, dynamic>,
          ),
  giftVoucherBox:
      json['GiftVoucherBox'] == null
          ? null
          : GiftVoucherBoxModel.fromJson(
            json['GiftVoucherBox'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShoppingCartModelImplToJson(
  _$ShoppingCartModelImpl instance,
) => <String, dynamic>{
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.showProductImages case final value?) 'ShowProductImages': value,
  if (instance.isEditable case final value?) 'IsEditable': value,
  if (instance.isAllowOnHold case final value?) 'IsAllowOnHold': value,
  if (instance.termsOfServicePopup case final value?)
    'TermsOfServicePopup': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.checkoutAttributeInfo case final value?)
    'CheckoutAttributeInfo': value,
  if (instance.checkoutAttributes case final value?)
    'CheckoutAttributes': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.minOrderSubtotalWarning case final value?)
    'MinOrderSubtotalWarning': value,
  if (instance.showCheckoutAsGuestButton case final value?)
    'ShowCheckoutAsGuestButton': value,
  if (instance.isGuest case final value?) 'IsGuest': value,
  if (instance.termsOfServiceOnShoppingCartPage case final value?)
    'TermsOfServiceOnShoppingCartPage': value,
  if (instance.termsOfServiceOnOrderConfirmPage case final value?)
    'TermsOfServiceOnOrderConfirmPage': value,
  if (instance.discountBox case final value?) 'DiscountBox': value,
  if (instance.giftVoucherBox case final value?) 'GiftVoucherBox': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
