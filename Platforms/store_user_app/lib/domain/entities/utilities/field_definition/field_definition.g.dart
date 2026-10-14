// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FieldDefinitionImpl _$$FieldDefinitionImplFromJson(
  Map<String, dynamic> json,
) => _$FieldDefinitionImpl(
  type: json['Type'] as String?,
  label: json['Label'] as String?,
  value: json['Value'],
  required: json['Required'] as bool? ?? false,
  validations:
      (json['Validations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      ) ??
      const {},
  validationMessages:
      (json['ValidationMessages'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$$FieldDefinitionImplToJson(
  _$FieldDefinitionImpl instance,
) => <String, dynamic>{
  if (instance.type case final value?) 'Type': value,
  if (instance.label case final value?) 'Label': value,
  if (instance.value case final value?) 'Value': value,
  if (instance.required case final value?) 'Required': value,
  if (instance.validations case final value?) 'Validations': value,
  if (instance.validationMessages case final value?)
    'ValidationMessages': value,
};
