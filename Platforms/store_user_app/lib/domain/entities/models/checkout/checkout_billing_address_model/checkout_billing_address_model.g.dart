// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_billing_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutBillingAddressModelImpl _$$CheckoutBillingAddressModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutBillingAddressModelImpl(
  existingAddresses:
      (json['ExistingAddresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  billingNewAddress:
      json['BillingNewAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['BillingNewAddress'] as Map<String, dynamic>,
          ),
  newAddressPreselected: json['NewAddressPreselected'] as bool? ?? false,
  billingAddressId: json['BillingAddressId'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutBillingAddressModelImplToJson(
  _$CheckoutBillingAddressModelImpl instance,
) => <String, dynamic>{
  if (instance.existingAddresses case final value?) 'ExistingAddresses': value,
  if (instance.billingNewAddress case final value?) 'BillingNewAddress': value,
  if (instance.newAddressPreselected case final value?)
    'NewAddressPreselected': value,
  if (instance.billingAddressId case final value?) 'BillingAddressId': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
