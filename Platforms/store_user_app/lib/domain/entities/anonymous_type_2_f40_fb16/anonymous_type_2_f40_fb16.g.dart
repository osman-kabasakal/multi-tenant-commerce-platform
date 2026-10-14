// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_2_f40_fb16.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_2F40FB16Impl _$$AnonymousType_2F40FB16ImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_2F40FB16Impl(
  model: json['model'],
  showcategories: json['Showcategories'],
);

Map<String, dynamic> _$$AnonymousType_2F40FB16ImplToJson(
  _$AnonymousType_2F40FB16Impl instance,
) => <String, dynamic>{
  if (instance.model case final value?) 'model': value,
  if (instance.showcategories case final value?) 'Showcategories': value,
};

_$AnonymousModelImpl _$$AnonymousModelImplFromJson(Map<String, dynamic> json) =>
    _$AnonymousModelImpl(
      success: json['Success'],
      result: json['Result'],
      resultCategory: json['ResultCategory'],
    );

Map<String, dynamic> _$$AnonymousModelImplToJson(
  _$AnonymousModelImpl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'Success': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.resultCategory case final value?) 'ResultCategory': value,
};
