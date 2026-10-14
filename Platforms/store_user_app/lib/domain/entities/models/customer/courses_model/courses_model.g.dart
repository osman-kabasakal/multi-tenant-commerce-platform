// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoursesModelImpl _$$CoursesModelImplFromJson(Map<String, dynamic> json) =>
    _$CoursesModelImpl(
      courseList:
          (json['CourseList'] as List<dynamic>?)
              ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      customerId: json['CustomerId'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CoursesModelImplToJson(_$CoursesModelImpl instance) =>
    <String, dynamic>{
      if (instance.courseList case final value?) 'CourseList': value,
      if (instance.customerId case final value?) 'CustomerId': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
