// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
  subjectId: json['SubjectId'] as String?,
  name: json['Name'] as String?,
  shortDescription: json['ShortDescription'] as String?,
  displayOrder: (json['DisplayOrder'] as num?)?.toInt(),
  pictureUrl: json['PictureUrl'] as String?,
  approved: json['Approved'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LessonImplToJson(
  _$LessonImpl instance,
) => <String, dynamic>{
  if (instance.subjectId case final value?) 'SubjectId': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.displayOrder case final value?) 'DisplayOrder': value,
  if (instance.pictureUrl case final value?) 'PictureUrl': value,
  if (instance.approved case final value?) 'Approved': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
