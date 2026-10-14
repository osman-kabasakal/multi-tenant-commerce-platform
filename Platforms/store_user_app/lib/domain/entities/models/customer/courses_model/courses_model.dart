import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'course/course.dart';

import '../../../common/user_field/user_field.dart';

part 'courses_model.freezed.dart';
part 'courses_model.g.dart';

@freezed
class CoursesModel extends StoreJsonSerializable<CoursesModel>
    with _$CoursesModel {
  factory CoursesModel(
      {@JsonKey(name: 'CourseList', includeIfNull: false)
      @Default([])
      List<Course>? courseList,
      @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CoursesModel;

  factory CoursesModel.fromJson(Map<String, dynamic> json) =>
      _$CoursesModelFromJson(json);
}
