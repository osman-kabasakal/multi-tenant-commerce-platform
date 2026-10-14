// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_completed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutCompletedModelImpl _$$CheckoutCompletedModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutCompletedModelImpl(
  orderId: json['OrderId'] as String?,
  orderNumber: (json['OrderNumber'] as num?)?.toInt(),
  orderCode: json['OrderCode'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutCompletedModelImplToJson(
  _$CheckoutCompletedModelImpl instance,
) => <String, dynamic>{
  if (instance.orderId case final value?) 'OrderId': value,
  if (instance.orderNumber case final value?) 'OrderNumber': value,
  if (instance.orderCode case final value?) 'OrderCode': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
