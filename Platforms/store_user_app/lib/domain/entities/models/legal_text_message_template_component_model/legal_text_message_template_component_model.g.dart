// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_text_message_template_component_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LegalTextMessageTemplateComponentModelImpl
_$$LegalTextMessageTemplateComponentModelImplFromJson(
  Map<String, dynamic> json,
) => _$LegalTextMessageTemplateComponentModelImpl(
  name: json['Name'] as String?,
  templateText: json['TemplateText'] as String?,
  order: (json['Order'] as num?)?.toInt(),
  category: json['Category'] as String?,
  isRequired: json['IsRequired'] as bool? ?? false,
  isActive: json['IsActive'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LegalTextMessageTemplateComponentModelImplToJson(
  _$LegalTextMessageTemplateComponentModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.templateText case final value?) 'TemplateText': value,
  if (instance.order case final value?) 'Order': value,
  if (instance.category case final value?) 'Category': value,
  if (instance.isRequired case final value?) 'IsRequired': value,
  if (instance.isActive case final value?) 'IsActive': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
