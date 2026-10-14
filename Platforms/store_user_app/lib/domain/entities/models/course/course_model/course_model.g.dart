// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseModelImpl _$$CourseModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseModelImpl(
      name: json['Name'] as String?,
      level: json['Level'] as String?,
      shortDescription: json['ShortDescription'] as String?,
      description: json['Description'] as String?,
      metaKeywords: json['MetaKeywords'] as String?,
      metaDescription: json['MetaDescription'] as String?,
      metaTitle: json['MetaTitle'] as String?,
      seName: json['SeName'] as String?,
      pictureUrl: json['PictureUrl'] as String?,
      subjects:
          (json['Subjects'] as List<dynamic>?)
              ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lessons:
          (json['Lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      approved: json['Approved'] as bool? ?? false,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CourseModelImplToJson(
  _$CourseModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.level case final value?) 'Level': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.pictureUrl case final value?) 'PictureUrl': value,
  if (instance.subjects case final value?) 'Subjects': value,
  if (instance.lessons case final value?) 'Lessons': value,
  if (instance.approved case final value?) 'Approved': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
