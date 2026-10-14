// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_10783450.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_10783450Impl _$$AnonymousType_10783450ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_10783450Impl(
  authenticated: json['Authenticated'] as bool? ?? false,
  error: json['Error'] as String?,
);

Map<String, dynamic> _$$AnonymousType_10783450ImplToJson(
  _$AnonymousType_10783450Impl instance,
) => <String, dynamic>{
  if (instance.authenticated case final value?) 'Authenticated': value,
  if (instance.error case final value?) 'Error': value,
};
