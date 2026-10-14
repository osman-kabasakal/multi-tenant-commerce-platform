import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course extends StoreJsonSerializable<Course> with _$Course {
  factory Course(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'Level', includeIfNull: false) String? level,
      @JsonKey(name: 'Approved', includeIfNull: false)
      @Default(false)
      bool? approved,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
