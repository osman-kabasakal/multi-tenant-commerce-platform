import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'subject/subject.dart';

import 'lesson/lesson.dart';

import '../../../common/user_field/user_field.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class CourseModel extends StoreJsonSerializable<CourseModel>
    with _$CourseModel {
  factory CourseModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Level', includeIfNull: false) String? level,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
      @JsonKey(name: 'Subjects', includeIfNull: false)
      @Default([])
      List<Subject>? subjects,
      @JsonKey(name: 'Lessons', includeIfNull: false)
      @Default([])
      List<Lesson>? lessons,
      @JsonKey(name: 'Approved', includeIfNull: false)
      @Default(false)
      bool? approved,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}
