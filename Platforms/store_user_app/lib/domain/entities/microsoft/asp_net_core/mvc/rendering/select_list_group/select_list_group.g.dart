// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_list_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectListGroupImpl _$$SelectListGroupImplFromJson(
  Map<String, dynamic> json,
) => _$SelectListGroupImpl(
  disabled: json['Disabled'] as bool? ?? false,
  name: json['Name'] as String?,
);

Map<String, dynamic> _$$SelectListGroupImplToJson(
  _$SelectListGroupImpl instance,
) => <String, dynamic>{
  if (instance.disabled case final value?) 'Disabled': value,
  if (instance.name case final value?) 'Name': value,
};
