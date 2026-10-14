// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_pickup_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutPickupPointModelImpl _$$CheckoutPickupPointModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutPickupPointModelImpl(
  id: json['Id'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  address:
      json['Address'] == null
          ? null
          : Address.fromJson(json['Address'] as Map<String, dynamic>),
  pickupFee: json['PickupFee'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutPickupPointModelImplToJson(
  _$CheckoutPickupPointModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.address case final value?) 'Address': value,
  if (instance.pickupFee case final value?) 'PickupFee': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
