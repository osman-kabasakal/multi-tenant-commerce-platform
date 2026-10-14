// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_shipping_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutShippingMethodModelImpl _$$CheckoutShippingMethodModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutShippingMethodModelImpl(
  shippingMethods:
      (json['ShippingMethods'] as List<dynamic>?)
          ?.map((e) => ShippingMethodModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  shippingOption: json['ShippingOption'] as String?,
  data:
      (json['Data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutShippingMethodModelImplToJson(
  _$CheckoutShippingMethodModelImpl instance,
) => <String, dynamic>{
  if (instance.shippingMethods case final value?) 'ShippingMethods': value,
  if (instance.shippingOption case final value?) 'ShippingOption': value,
  if (instance.data case final value?) 'Data': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
