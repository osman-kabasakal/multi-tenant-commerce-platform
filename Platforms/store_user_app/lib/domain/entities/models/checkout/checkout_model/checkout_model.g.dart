// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutModelImpl _$$CheckoutModelImplFromJson(Map<String, dynamic> json) =>
    _$CheckoutModelImpl(
      shippingRequired: json['ShippingRequired'] as bool? ?? false,
      billingAddress:
          json['BillingAddress'] == null
              ? null
              : CheckoutBillingAddressModel.fromJson(
                json['BillingAddress'] as Map<String, dynamic>,
              ),
      shippingAddress:
          json['ShippingAddress'] == null
              ? null
              : CheckoutShippingAddressModel.fromJson(
                json['ShippingAddress'] as Map<String, dynamic>,
              ),
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CheckoutModelImplToJson(
  _$CheckoutModelImpl instance,
) => <String, dynamic>{
  if (instance.shippingRequired case final value?) 'ShippingRequired': value,
  if (instance.billingAddress case final value?) 'BillingAddress': value,
  if (instance.shippingAddress case final value?) 'ShippingAddress': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
