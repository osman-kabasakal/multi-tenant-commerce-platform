// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeleteCartItemModelImpl _$$DeleteCartItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeleteCartItemModelImpl(
  id: json['Id'] as String?,
  shoppingCartPage: json['ShoppingCartPage'] as bool? ?? false,
);

Map<String, dynamic> _$$DeleteCartItemModelImplToJson(
  _$DeleteCartItemModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.shoppingCartPage case final value?) 'ShoppingCartPage': value,
};
