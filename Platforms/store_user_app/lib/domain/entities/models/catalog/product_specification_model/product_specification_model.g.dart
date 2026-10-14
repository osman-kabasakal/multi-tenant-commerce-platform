// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_specification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSpecificationModelImpl _$$ProductSpecificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductSpecificationModelImpl(
  specificationAttributeId: json['SpecificationAttributeId'] as String?,
  specificationAttributeName: json['SpecificationAttributeName'] as String?,
  valueRaw: json['ValueRaw'] as String?,
  colorSquaresRgb: json['ColorSquaresRgb'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductSpecificationModelImplToJson(
  _$ProductSpecificationModelImpl instance,
) => <String, dynamic>{
  if (instance.specificationAttributeId case final value?)
    'SpecificationAttributeId': value,
  if (instance.specificationAttributeName case final value?)
    'SpecificationAttributeName': value,
  if (instance.valueRaw case final value?) 'ValueRaw': value,
  if (instance.colorSquaresRgb case final value?) 'ColorSquaresRgb': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
