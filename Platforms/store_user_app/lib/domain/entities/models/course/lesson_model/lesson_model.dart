import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel extends StoreJsonSerializable<LessonModel>
    with _$LessonModel {
  factory LessonModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
      @JsonKey(name: 'DownloadFile', includeIfNull: false)
      @Default(false)
      bool? downloadFile,
      @JsonKey(name: 'VideoFile', includeIfNull: false)
      @Default(false)
      bool? videoFile,
      @JsonKey(name: 'CourseId', includeIfNull: false) String? courseId,
      @JsonKey(name: 'CourseName', includeIfNull: false) String? courseName,
      @JsonKey(name: 'CourseSeName', includeIfNull: false) String? courseSeName,
      @JsonKey(name: 'CourseLevel', includeIfNull: false) String? courseLevel,
      @JsonKey(name: 'CourseDescription', includeIfNull: false)
      String? courseDescription,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'Approved', includeIfNull: false)
      @Default(false)
      bool? approved,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}
