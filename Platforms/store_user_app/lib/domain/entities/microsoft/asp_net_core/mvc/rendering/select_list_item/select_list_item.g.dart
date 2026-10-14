// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectListItemImpl _$$SelectListItemImplFromJson(Map<String, dynamic> json) =>
    _$SelectListItemImpl(
      disabled: json['Disabled'] as bool? ?? false,
      group:
          json['Group'] == null
              ? null
              : SelectListGroup.fromJson(json['Group'] as Map<String, dynamic>),
      selected: json['Selected'] as bool? ?? false,
      text: json['Text'] as String?,
      value: json['Value'] as String?,
    );

Map<String, dynamic> _$$SelectListItemImplToJson(
  _$SelectListItemImpl instance,
) => <String, dynamic>{
  if (instance.disabled case final value?) 'Disabled': value,
  if (instance.group case final value?) 'Group': value,
  if (instance.selected case final value?) 'Selected': value,
  if (instance.text case final value?) 'Text': value,
  if (instance.value case final value?) 'Value': value,
};
