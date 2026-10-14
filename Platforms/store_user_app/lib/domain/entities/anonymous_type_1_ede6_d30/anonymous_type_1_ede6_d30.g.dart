// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_1_ede6_d30.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_1EDE6D30Impl _$$AnonymousType_1EDE6D30ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_1EDE6D30Impl(
  result: json['Result'] as String?,
  totalYes: (json['TotalYes'] as num?)?.toInt(),
  totalNo: (json['TotalNo'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AnonymousType_1EDE6D30ImplToJson(
  _$AnonymousType_1EDE6D30Impl instance,
) => <String, dynamic>{
  if (instance.result case final value?) 'Result': value,
  if (instance.totalYes case final value?) 'TotalYes': value,
  if (instance.totalNo case final value?) 'TotalNo': value,
};
