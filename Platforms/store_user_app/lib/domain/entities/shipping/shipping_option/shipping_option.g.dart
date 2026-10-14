// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShippingOptionImpl _$$ShippingOptionImplFromJson(Map<String, dynamic> json) =>
    _$ShippingOptionImpl(
      shippingRateProviderSystemName:
          json['ShippingRateProviderSystemName'] as String?,
      rate: (json['Rate'] as num?)?.toDouble(),
      name: json['Name'] as String?,
      description: json['Description'] as String?,
    );

Map<String, dynamic> _$$ShippingOptionImplToJson(
  _$ShippingOptionImpl instance,
) => <String, dynamic>{
  if (instance.shippingRateProviderSystemName case final value?)
    'ShippingRateProviderSystemName': value,
  if (instance.rate case final value?) 'Rate': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
};
