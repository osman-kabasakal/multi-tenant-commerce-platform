// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      orderNumber: (json['OrderNumber'] as num?)?.toInt(),
      orderCode: json['OrderCode'] as String?,
      shippingMethod: json['ShippingMethod'] as String?,
      pickUpInStore: json['PickUpInStore'] as bool? ?? false,
      pickupAddress:
          json['PickupAddress'] == null
              ? null
              : AddressModel.fromJson(
                json['PickupAddress'] as Map<String, dynamic>,
              ),
      shippingAddress:
          json['ShippingAddress'] == null
              ? null
              : AddressModel.fromJson(
                json['ShippingAddress'] as Map<String, dynamic>,
              ),
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      if (instance.orderNumber case final value?) 'OrderNumber': value,
      if (instance.orderCode case final value?) 'OrderCode': value,
      if (instance.shippingMethod case final value?) 'ShippingMethod': value,
      if (instance.pickUpInStore case final value?) 'PickUpInStore': value,
      if (instance.pickupAddress case final value?) 'PickupAddress': value,
      if (instance.shippingAddress case final value?) 'ShippingAddress': value,
      if (instance.id case final value?) 'Id': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
