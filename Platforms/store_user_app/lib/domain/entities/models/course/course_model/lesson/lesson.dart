import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson extends StoreJsonSerializable<Lesson> with _$Lesson {
  factory Lesson(
      {@JsonKey(name: 'SubjectId', includeIfNull: false) String? subjectId,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
      @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
      @JsonKey(name: 'Approved', includeIfNull: false)
      @Default(false)
      bool? approved,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
