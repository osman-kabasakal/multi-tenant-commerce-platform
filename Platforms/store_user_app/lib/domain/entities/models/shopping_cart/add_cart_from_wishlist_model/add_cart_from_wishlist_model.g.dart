// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cart_from_wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddCartFromWishlistModelImpl _$$AddCartFromWishlistModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddCartFromWishlistModelImpl(
  customerGuid: json['CustomerGuid'] as String? ?? null,
  shoppingCartId: json['ShoppingCartId'] as String?,
);

Map<String, dynamic> _$$AddCartFromWishlistModelImplToJson(
  _$AddCartFromWishlistModelImpl instance,
) => <String, dynamic>{
  if (instance.customerGuid case final value?) 'CustomerGuid': value,
  if (instance.shoppingCartId case final value?) 'ShoppingCartId': value,
};
