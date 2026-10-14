// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specification_filter_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecificationFilterItemImpl _$$SpecificationFilterItemImplFromJson(
  Map<String, dynamic> json,
) => _$SpecificationFilterItemImpl(
  specificationAttributeName: json['SpecificationAttributeName'] as String?,
  specificationAttributeSeName: json['SpecificationAttributeSeName'] as String?,
  specificationAttributeOptionName:
      json['SpecificationAttributeOptionName'] as String?,
  specificationAttributeOptionSeName:
      json['SpecificationAttributeOptionSeName'] as String?,
  specificationAttributeOptionColorRgb:
      json['SpecificationAttributeOptionColorRgb'] as String?,
  filterUrl: json['FilterUrl'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SpecificationFilterItemImplToJson(
  _$SpecificationFilterItemImpl instance,
) => <String, dynamic>{
  if (instance.specificationAttributeName case final value?)
    'SpecificationAttributeName': value,
  if (instance.specificationAttributeSeName case final value?)
    'SpecificationAttributeSeName': value,
  if (instance.specificationAttributeOptionName case final value?)
    'SpecificationAttributeOptionName': value,
  if (instance.specificationAttributeOptionSeName case final value?)
    'SpecificationAttributeOptionSeName': value,
  if (instance.specificationAttributeOptionColorRgb case final value?)
    'SpecificationAttributeOptionColorRgb': value,
  if (instance.filterUrl case final value?) 'FilterUrl': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
