// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_shipping_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutShippingAddressModelImpl _$$CheckoutShippingAddressModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutShippingAddressModelImpl(
  existingAddresses:
      (json['ExistingAddresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  shippingNewAddress:
      json['ShippingNewAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['ShippingNewAddress'] as Map<String, dynamic>,
          ),
  shippingAddressId: json['ShippingAddressId'] as String?,
  pickupPointId: json['PickupPointId'] as String?,
  newAddressPreselected: json['NewAddressPreselected'] as bool? ?? false,
  pickupPoints:
      (json['PickupPoints'] as List<dynamic>?)
          ?.map(
            (e) => CheckoutPickupPointModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  billToTheSameAddress: json['BillToTheSameAddress'] as bool? ?? false,
  allowPickUpInStore: json['AllowPickUpInStore'] as bool? ?? false,
  pickUpInStore: json['PickUpInStore'] as bool? ?? false,
  pickUpInStoreOnly: json['PickUpInStoreOnly'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutShippingAddressModelImplToJson(
  _$CheckoutShippingAddressModelImpl instance,
) => <String, dynamic>{
  if (instance.existingAddresses case final value?) 'ExistingAddresses': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.shippingNewAddress case final value?)
    'ShippingNewAddress': value,
  if (instance.shippingAddressId case final value?) 'ShippingAddressId': value,
  if (instance.pickupPointId case final value?) 'PickupPointId': value,
  if (instance.newAddressPreselected case final value?)
    'NewAddressPreselected': value,
  if (instance.pickupPoints case final value?) 'PickupPoints': value,
  if (instance.billToTheSameAddress case final value?)
    'BillToTheSameAddress': value,
  if (instance.allowPickUpInStore case final value?)
    'AllowPickUpInStore': value,
  if (instance.pickUpInStore case final value?) 'PickUpInStore': value,
  if (instance.pickUpInStoreOnly case final value?) 'PickUpInStoreOnly': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
