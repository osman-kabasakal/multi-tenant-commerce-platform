// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentItemModelImpl _$$ShipmentItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentItemModelImpl(
  sku: json['Sku'] as String?,
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  attributeInfo: json['AttributeInfo'] as String?,
  rentalInfo: json['RentalInfo'] as String?,
  quantityOrdered: (json['QuantityOrdered'] as num?)?.toInt(),
  quantityShipped: (json['QuantityShipped'] as num?)?.toInt(),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShipmentItemModelImplToJson(
  _$ShipmentItemModelImpl instance,
) => <String, dynamic>{
  if (instance.sku case final value?) 'Sku': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.rentalInfo case final value?) 'RentalInfo': value,
  if (instance.quantityOrdered case final value?) 'QuantityOrdered': value,
  if (instance.quantityShipped case final value?) 'QuantityShipped': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
