// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDetailsModelImpl _$$OrderDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderDetailsModelImpl(
  orderTotal: json['OrderTotal'] as String?,
  isMerchandiseReturnAllowed:
      json['IsMerchandiseReturnAllowed'] as bool? ?? false,
  orderStatusId: (json['OrderStatusId'] as num?)?.toInt(),
  orderStatus: json['OrderStatus'] as String?,
  paymentStatus: json['PaymentStatus'] as String?,
  shippingStatus: json['ShippingStatus'] as String?,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  orderNumber: (json['OrderNumber'] as num?)?.toInt(),
  orderCode: json['OrderCode'] as String?,
  customerEmail: json['CustomerEmail'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderDetailsModelImplToJson(
  _$OrderDetailsModelImpl instance,
) => <String, dynamic>{
  if (instance.orderTotal case final value?) 'OrderTotal': value,
  if (instance.isMerchandiseReturnAllowed case final value?)
    'IsMerchandiseReturnAllowed': value,
  if (instance.orderStatusId case final value?) 'OrderStatusId': value,
  if (instance.orderStatus case final value?) 'OrderStatus': value,
  if (instance.paymentStatus case final value?) 'PaymentStatus': value,
  if (instance.shippingStatus case final value?) 'ShippingStatus': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.orderNumber case final value?) 'OrderNumber': value,
  if (instance.orderCode case final value?) 'OrderCode': value,
  if (instance.customerEmail case final value?) 'CustomerEmail': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
