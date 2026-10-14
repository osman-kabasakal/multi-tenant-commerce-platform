// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_5_f706788.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_5F706788Impl _$$AnonymousType_5F706788ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_5F706788Impl(
  success: json['success'] as bool? ?? false,
  downloadGuid: json['downloadGuid'] as String?,
  downloadUrl: json['downloadUrl'] as String? ?? null,
  message: json['message'] as String? ?? null,
);

Map<String, dynamic> _$$AnonymousType_5F706788ImplToJson(
  _$AnonymousType_5F706788Impl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'success': value,
  if (instance.downloadGuid case final value?) 'downloadGuid': value,
  'downloadUrl': instance.downloadUrl,
  'message': instance.message,
};
