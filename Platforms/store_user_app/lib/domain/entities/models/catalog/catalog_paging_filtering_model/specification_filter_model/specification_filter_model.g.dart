// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specification_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecificationFilterModelImpl _$$SpecificationFilterModelImplFromJson(
  Map<String, dynamic> json,
) => _$SpecificationFilterModelImpl(
  enabled: json['Enabled'] as bool? ?? false,
  alreadyFilteredItems:
      (json['AlreadyFilteredItems'] as List<dynamic>?)
          ?.map(
            (e) => SpecificationFilterItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  notFilteredItems:
      (json['NotFilteredItems'] as List<dynamic>?)
          ?.map(
            (e) => SpecificationFilterItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  removeFilterUrl: json['RemoveFilterUrl'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SpecificationFilterModelImplToJson(
  _$SpecificationFilterModelImpl instance,
) => <String, dynamic>{
  if (instance.enabled case final value?) 'Enabled': value,
  if (instance.alreadyFilteredItems case final value?)
    'AlreadyFilteredItems': value,
  if (instance.notFilteredItems case final value?) 'NotFilteredItems': value,
  if (instance.removeFilterUrl case final value?) 'RemoveFilterUrl': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
