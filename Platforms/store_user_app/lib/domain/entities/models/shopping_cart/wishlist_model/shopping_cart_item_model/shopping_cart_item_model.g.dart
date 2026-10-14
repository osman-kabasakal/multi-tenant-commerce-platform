// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingCartItemModelImpl _$$ShoppingCartItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingCartItemModelImpl(
  sku: json['Sku'] as String?,
  picture:
      json['Picture'] == null
          ? null
          : PictureModel.fromJson(json['Picture'] as Map<String, dynamic>),
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  productUrl: json['ProductUrl'] as String?,
  unitPrice: json['UnitPrice'] as String?,
  subTotal: json['SubTotal'] as String?,
  discount: json['Discount'] as String?,
  quantity: (json['Quantity'] as num?)?.toInt(),
  allowedQuantities:
      (json['AllowedQuantities'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attributeInfo: json['AttributeInfo'] as String?,
  recurringInfo: json['RecurringInfo'] as String?,
  rentalInfo: json['RentalInfo'] as String?,
  allowItemEditing: json['AllowItemEditing'] as bool? ?? false,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShoppingCartItemModelImplToJson(
  _$ShoppingCartItemModelImpl instance,
) => <String, dynamic>{
  if (instance.sku case final value?) 'Sku': value,
  if (instance.picture case final value?) 'Picture': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.productUrl case final value?) 'ProductUrl': value,
  if (instance.unitPrice case final value?) 'UnitPrice': value,
  if (instance.subTotal case final value?) 'SubTotal': value,
  if (instance.discount case final value?) 'Discount': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.allowedQuantities case final value?) 'AllowedQuantities': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.recurringInfo case final value?) 'RecurringInfo': value,
  if (instance.rentalInfo case final value?) 'RentalInfo': value,
  if (instance.allowItemEditing case final value?) 'AllowItemEditing': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
