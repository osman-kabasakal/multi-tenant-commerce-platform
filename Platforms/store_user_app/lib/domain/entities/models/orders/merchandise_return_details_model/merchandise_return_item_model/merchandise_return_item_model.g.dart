// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnItemModelImpl _$$MerchandiseReturnItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnItemModelImpl(
  orderItemId: json['OrderItemId'] as String?,
  reasonForReturn: json['ReasonForReturn'] as String?,
  quantity: (json['Quantity'] as num?)?.toInt(),
  requestedAction: json['RequestedAction'] as String?,
  productSeName: json['ProductSeName'] as String?,
  productName: json['ProductName'] as String?,
  productPrice: json['ProductPrice'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnItemModelImplToJson(
  _$MerchandiseReturnItemModelImpl instance,
) => <String, dynamic>{
  if (instance.orderItemId case final value?) 'OrderItemId': value,
  if (instance.reasonForReturn case final value?) 'ReasonForReturn': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.requestedAction case final value?) 'RequestedAction': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productPrice case final value?) 'ProductPrice': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
