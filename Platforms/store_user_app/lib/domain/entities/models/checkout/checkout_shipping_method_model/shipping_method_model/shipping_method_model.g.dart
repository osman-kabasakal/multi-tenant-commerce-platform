// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShippingMethodModelImpl _$$ShippingMethodModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShippingMethodModelImpl(
  shippingRateProviderSystemName:
      json['ShippingRateProviderSystemName'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  fee: json['Fee'] as String?,
  selected: json['Selected'] as bool? ?? false,
  shippingOption:
      json['ShippingOption'] == null
          ? null
          : ShippingOption.fromJson(
            json['ShippingOption'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShippingMethodModelImplToJson(
  _$ShippingMethodModelImpl instance,
) => <String, dynamic>{
  if (instance.shippingRateProviderSystemName case final value?)
    'ShippingRateProviderSystemName': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.fee case final value?) 'Fee': value,
  if (instance.selected case final value?) 'Selected': value,
  if (instance.shippingOption case final value?) 'ShippingOption': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
