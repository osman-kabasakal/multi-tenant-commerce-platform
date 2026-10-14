import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'user_field.freezed.dart';
part 'user_field.g.dart';

@freezed
class UserField extends StoreJsonSerializable<UserField> with _$UserField {
  factory UserField(
          {@JsonKey(name: 'Key', includeIfNull: false) String? key,
          @JsonKey(name: 'Value', includeIfNull: false) String? value,
          @JsonKey(name: 'StoreId', includeIfNull: false) String? storeId}) =
      _UserField;

  factory UserField.fromJson(Map<String, dynamic> json) =>
      _$UserFieldFromJson(json);
}
