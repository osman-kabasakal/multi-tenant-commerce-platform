// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_quantity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateQuantityModelImpl _$$UpdateQuantityModelImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateQuantityModelImpl(
  shoppingCartId: json['ShoppingCartId'] as String?,
  quantity: (json['Quantity'] as num?)?.toInt(),
  shoppingCartType:
      $enumDecodeNullable(
        _$ShoppingCartTypeEnumMap,
        json['ShoppingCartType'],
      ) ??
      ShoppingCartType.onHoldCart,
);

Map<String, dynamic> _$$UpdateQuantityModelImplToJson(
  _$UpdateQuantityModelImpl instance,
) => <String, dynamic>{
  if (instance.shoppingCartId case final value?) 'ShoppingCartId': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (_$ShoppingCartTypeEnumMap[instance.shoppingCartType] case final value?)
    'ShoppingCartType': value,
};

const _$ShoppingCartTypeEnumMap = {
  ShoppingCartType.onHoldCart: 0,
  ShoppingCartType.shoppingCart: 1,
  ShoppingCartType.wishlist: 2,
  ShoppingCartType.auctions: 3,
};
