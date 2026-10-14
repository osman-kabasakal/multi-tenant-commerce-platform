// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  shortDescription: json['ShortDescription'] as String?,
  level: json['Level'] as String?,
  approved: json['Approved'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CourseImplToJson(
  _$CourseImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.level case final value?) 'Level': value,
  if (instance.approved case final value?) 'Approved': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
