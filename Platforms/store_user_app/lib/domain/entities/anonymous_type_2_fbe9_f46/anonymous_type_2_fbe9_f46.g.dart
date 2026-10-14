// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_2_fbe9_f46.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_2FBE9F46Impl _$$AnonymousType_2FBE9F46ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_2FBE9F46Impl(
  update_section:
      json['update_section'] == null
          ? null
          : UpdateSectionJsonModel.fromJson(
            json['update_section'] as Map<String, dynamic>,
          ),
  goToSection: json['goto_section'] as String?,
  wrong_shipping_address: json['wrong_shipping_address'] as bool? ?? false,
  model_state:
      (json['model_state'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  error: (json['error'] as num?)?.toInt(),
  message: json['message'] as String?,
  success: (json['success'] as num?)?.toInt(),
  redirect: json['redirect'] as String?,
);

Map<String, dynamic> _$$AnonymousType_2FBE9F46ImplToJson(
  _$AnonymousType_2FBE9F46Impl instance,
) => <String, dynamic>{
  if (instance.update_section case final value?) 'update_section': value,
  'goto_section': instance.goToSection,
  if (instance.wrong_shipping_address case final value?)
    'wrong_shipping_address': value,
  'model_state': instance.model_state,
  'error': instance.error,
  'message': instance.message,
  'success': instance.success,
  'redirect': instance.redirect,
};
