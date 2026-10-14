// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_catalog_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductCatalogCartImpl _$$ProductCatalogCartImplFromJson(
  Map<String, dynamic> json,
) => _$ProductCatalogCartImpl(
  productId: json['ProductId'] as String?,
  shoppingCartTypeId:
      $enumDecodeNullable(
        _$ShoppingCartTypeEnumMap,
        json['ShoppingCartTypeId'],
      ) ??
      ShoppingCartType.onHoldCart,
  quantity: (json['Quantity'] as num?)?.toInt(),
  forceRedirection: json['ForceRedirection'] as bool? ?? false,
);

Map<String, dynamic> _$$ProductCatalogCartImplToJson(
  _$ProductCatalogCartImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (_$ShoppingCartTypeEnumMap[instance.shoppingCartTypeId] case final value?)
    'ShoppingCartTypeId': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.forceRedirection case final value?) 'ForceRedirection': value,
};

const _$ShoppingCartTypeEnumMap = {
  ShoppingCartType.onHoldCart: 0,
  ShoppingCartType.shoppingCart: 1,
  ShoppingCartType.wishlist: 2,
  ShoppingCartType.auctions: 3,
};
