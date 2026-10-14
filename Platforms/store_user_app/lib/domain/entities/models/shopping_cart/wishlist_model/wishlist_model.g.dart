// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistModelImpl _$$WishlistModelImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistModelImpl(
  customerGuid: json['CustomerGuid'] as String?,
  customerFullname: json['CustomerFullname'] as String?,
  emailWishlistEnabled: json['EmailWishlistEnabled'] as bool? ?? false,
  showSku: json['ShowSku'] as bool? ?? false,
  showProductImages: json['ShowProductImages'] as bool? ?? false,
  isEditable: json['IsEditable'] as bool? ?? false,
  displayAddToCart: json['DisplayAddToCart'] as bool? ?? false,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map(
            (e) => ShoppingCartItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WishlistModelImplToJson(
  _$WishlistModelImpl instance,
) => <String, dynamic>{
  if (instance.customerGuid case final value?) 'CustomerGuid': value,
  if (instance.customerFullname case final value?) 'CustomerFullname': value,
  if (instance.emailWishlistEnabled case final value?)
    'EmailWishlistEnabled': value,
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.showProductImages case final value?) 'ShowProductImages': value,
  if (instance.isEditable case final value?) 'IsEditable': value,
  if (instance.displayAddToCart case final value?) 'DisplayAddToCart': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
