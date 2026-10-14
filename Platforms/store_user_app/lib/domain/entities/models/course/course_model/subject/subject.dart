import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

@freezed
class Subject extends StoreJsonSerializable<Subject> with _$Subject {
  factory Subject(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
