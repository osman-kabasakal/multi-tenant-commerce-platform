// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_97_c14_fd8.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_97C14FD8Impl _$$AnonymousType_97C14FD8ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_97C14FD8Impl(
  success: json['success'] as bool? ?? false,
  message: json['message'] as String?,
  product: json['product'] as bool?,
  model:
      json['model'] == null
          ? null
          : ProductDetailsModel.fromJson(json['model'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AnonymousType_97C14FD8ImplToJson(
  _$AnonymousType_97C14FD8Impl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'success': value,
  if (instance.message case final value?) 'message': value,
  if (instance.product case final value?) 'product': value,
  if (instance.model case final value?) 'model': value,
};
