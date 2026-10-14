// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemModelImpl _$$WishlistItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistItemModelImpl(
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  productUrl: json['ProductUrl'] as String?,
  sku: json['Sku'] as String?,
  quantity: (json['Quantity'] as num?)?.toInt(),
  unitPrice: json['UnitPrice'] as String?,
  unitPriceValue: (json['UnitPriceValue'] as num?)?.toDouble(),
  taxRate: (json['TaxRate'] as num?)?.toDouble(),
  attributeInfo: json['AttributeInfo'] as String?,
  picture:
      json['Picture'] == null
          ? null
          : PictureModel.fromJson(json['Picture'] as Map<String, dynamic>),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WishlistItemModelImplToJson(
  _$WishlistItemModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.productUrl case final value?) 'ProductUrl': value,
  if (instance.sku case final value?) 'Sku': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.unitPrice case final value?) 'UnitPrice': value,
  if (instance.unitPriceValue case final value?) 'UnitPriceValue': value,
  if (instance.taxRate case final value?) 'TaxRate': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.picture case final value?) 'Picture': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
