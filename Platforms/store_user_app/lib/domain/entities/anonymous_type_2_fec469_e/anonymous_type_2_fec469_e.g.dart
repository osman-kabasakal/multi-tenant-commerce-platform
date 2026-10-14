// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_2_fec469_e.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_2FEC469EImpl _$$AnonymousType_2FEC469EImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_2FEC469EImpl(
  success: json['success'] as bool? ?? false,
  warnings: json['warnings'] as String?,
  totalproducts: (json['totalproducts'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AnonymousType_2FEC469EImplToJson(
  _$AnonymousType_2FEC469EImpl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'success': value,
  if (instance.warnings case final value?) 'warnings': value,
  if (instance.totalproducts case final value?) 'totalproducts': value,
};
