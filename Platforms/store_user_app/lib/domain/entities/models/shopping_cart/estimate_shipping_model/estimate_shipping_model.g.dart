// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimate_shipping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EstimateShippingModelImpl _$$EstimateShippingModelImplFromJson(
  Map<String, dynamic> json,
) => _$EstimateShippingModelImpl(
  enabled: json['Enabled'] as bool? ?? false,
  countryId: json['CountryId'] as String?,
  stateProvinceId: json['StateProvinceId'] as String?,
  zipPostalCode: json['ZipPostalCode'] as String?,
  availableCountries:
      (json['AvailableCountries'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  availableStates:
      (json['AvailableStates'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$EstimateShippingModelImplToJson(
  _$EstimateShippingModelImpl instance,
) => <String, dynamic>{
  if (instance.enabled case final value?) 'Enabled': value,
  if (instance.countryId case final value?) 'CountryId': value,
  if (instance.stateProvinceId case final value?) 'StateProvinceId': value,
  if (instance.zipPostalCode case final value?) 'ZipPostalCode': value,
  if (instance.availableCountries case final value?)
    'AvailableCountries': value,
  if (instance.availableStates case final value?) 'AvailableStates': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
