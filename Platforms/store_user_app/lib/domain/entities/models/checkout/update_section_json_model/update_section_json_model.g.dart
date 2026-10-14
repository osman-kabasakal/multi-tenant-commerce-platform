// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_section_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateSectionJsonModelImpl _$$UpdateSectionJsonModelImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateSectionJsonModelImpl(
  name: json['name'] as String?,
  model: json['model'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$UpdateSectionJsonModelImplToJson(
  _$UpdateSectionJsonModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'name': value,
  if (instance.model case final value?) 'model': value,
};
