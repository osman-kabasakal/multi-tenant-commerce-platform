// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_brief_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandBriefInfoModelImpl _$$BrandBriefInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$BrandBriefInfoModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BrandBriefInfoModelImplToJson(
  _$BrandBriefInfoModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
