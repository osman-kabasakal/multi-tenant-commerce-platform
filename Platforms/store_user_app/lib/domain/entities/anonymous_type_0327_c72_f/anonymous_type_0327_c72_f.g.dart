// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_0327_c72_f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_0327C72FImpl _$$AnonymousType_0327C72FImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_0327C72FImpl(
  gtin: json['gtin'] as String?,
  mpn: json['mpn'] as String?,
  sku: json['sku'] as String?,
  price: json['price'] as String?,
  stockAvailability: json['stockAvailability'] as String?,
  outOfStockSubscription: json['outOfStockSubscription'] as bool? ?? false,
  buttonTextOutOfStockSubscription:
      json['buttonTextOutOfStockSubscription'] as String?,
  enabledattributemappingids:
      (json['enabledattributemappingids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  disabledattributemappingids:
      (json['disabledattributemappingids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notAvailableAttributeMappingids:
      (json['notAvailableAttributeMappingids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  pictureFullSizeUrl: json['pictureFullSizeUrl'] as String?,
  pictureDefaultSizeUrl: json['pictureDefaultSizeUrl'] as String?,
);

Map<String, dynamic> _$$AnonymousType_0327C72FImplToJson(
  _$AnonymousType_0327C72FImpl instance,
) => <String, dynamic>{
  if (instance.gtin case final value?) 'gtin': value,
  if (instance.mpn case final value?) 'mpn': value,
  if (instance.sku case final value?) 'sku': value,
  if (instance.price case final value?) 'price': value,
  if (instance.stockAvailability case final value?) 'stockAvailability': value,
  if (instance.outOfStockSubscription case final value?)
    'outOfStockSubscription': value,
  if (instance.buttonTextOutOfStockSubscription case final value?)
    'buttonTextOutOfStockSubscription': value,
  if (instance.enabledattributemappingids case final value?)
    'enabledattributemappingids': value,
  if (instance.disabledattributemappingids case final value?)
    'disabledattributemappingids': value,
  if (instance.notAvailableAttributeMappingids case final value?)
    'notAvailableAttributeMappingids': value,
  if (instance.pictureFullSizeUrl case final value?)
    'pictureFullSizeUrl': value,
  if (instance.pictureDefaultSizeUrl case final value?)
    'pictureDefaultSizeUrl': value,
};
