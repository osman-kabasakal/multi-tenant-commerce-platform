// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonModelImpl _$$LessonModelImplFromJson(Map<String, dynamic> json) =>
    _$LessonModelImpl(
      name: json['Name'] as String?,
      shortDescription: json['ShortDescription'] as String?,
      description: json['Description'] as String?,
      pictureUrl: json['PictureUrl'] as String?,
      downloadFile: json['DownloadFile'] as bool? ?? false,
      videoFile: json['VideoFile'] as bool? ?? false,
      courseId: json['CourseId'] as String?,
      courseName: json['CourseName'] as String?,
      courseSeName: json['CourseSeName'] as String?,
      courseLevel: json['CourseLevel'] as String?,
      courseDescription: json['CourseDescription'] as String?,
      metaKeywords: json['MetaKeywords'] as String?,
      metaDescription: json['MetaDescription'] as String?,
      metaTitle: json['MetaTitle'] as String?,
      approved: json['Approved'] as bool? ?? false,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LessonModelImplToJson(
  _$LessonModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.pictureUrl case final value?) 'PictureUrl': value,
  if (instance.downloadFile case final value?) 'DownloadFile': value,
  if (instance.videoFile case final value?) 'VideoFile': value,
  if (instance.courseId case final value?) 'CourseId': value,
  if (instance.courseName case final value?) 'CourseName': value,
  if (instance.courseSeName case final value?) 'CourseSeName': value,
  if (instance.courseLevel case final value?) 'CourseLevel': value,
  if (instance.courseDescription case final value?) 'CourseDescription': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.approved case final value?) 'Approved': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
