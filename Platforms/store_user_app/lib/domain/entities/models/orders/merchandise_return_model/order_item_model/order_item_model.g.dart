// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      productId: json['ProductId'] as String?,
      productName: json['ProductName'] as String?,
      vendorId: json['VendorId'] as String?,
      vendorName: json['VendorName'] as String?,
      productSeName: json['ProductSeName'] as String?,
      attributeInfo: json['AttributeInfo'] as String?,
      unitPrice: json['UnitPrice'] as String?,
      includingTax: json['IncludingTax'] as bool? ?? false,
      quantity: (json['Quantity'] as num?)?.toInt(),
      merchandiseReturnReasonId: json['MerchandiseReturnReasonId'] as String?,
      merchandiseReturnActionId: json['MerchandiseReturnActionId'] as String?,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.vendorName case final value?) 'VendorName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.unitPrice case final value?) 'UnitPrice': value,
  if (instance.includingTax case final value?) 'IncludingTax': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.merchandiseReturnReasonId case final value?)
    'MerchandiseReturnReasonId': value,
  if (instance.merchandiseReturnActionId case final value?)
    'MerchandiseReturnActionId': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
