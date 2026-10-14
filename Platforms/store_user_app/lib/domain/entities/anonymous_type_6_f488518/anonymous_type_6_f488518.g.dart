// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_6_f488518.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_6F488518Impl _$$AnonymousType_6F488518ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_6F488518Impl(
  success: json['success'] as bool? ?? false,
  model:
      json['model'] == null
          ? null
          : ShoppingCartModel.fromJson(json['model'] as Map<String, dynamic>),
  warnings: json['warnings'] as String?,
);

Map<String, dynamic> _$$AnonymousType_6F488518ImplToJson(
  _$AnonymousType_6F488518Impl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'success': value,
  if (instance.model case final value?) 'model': value,
  if (instance.warnings case final value?) 'warnings': value,
};
