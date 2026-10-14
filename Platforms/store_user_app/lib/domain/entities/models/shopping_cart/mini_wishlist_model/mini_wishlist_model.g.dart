// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MiniWishlistModelImpl _$$MiniWishlistModelImplFromJson(
  Map<String, dynamic> json,
) => _$MiniWishlistModelImpl(
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalProducts: (json['TotalProducts'] as num?)?.toInt(),
  showProductImages: json['ShowProductImages'] as bool? ?? false,
  emailWishlistEnabled: json['EmailWishlistEnabled'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MiniWishlistModelImplToJson(
  _$MiniWishlistModelImpl instance,
) => <String, dynamic>{
  if (instance.items case final value?) 'Items': value,
  if (instance.totalProducts case final value?) 'TotalProducts': value,
  if (instance.showProductImages case final value?) 'ShowProductImages': value,
  if (instance.emailWishlistEnabled case final value?)
    'EmailWishlistEnabled': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
