import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'change_password_model.freezed.dart';
part 'change_password_model.g.dart';

@freezed
class ChangePasswordModel extends StoreJsonSerializable<ChangePasswordModel>
    with _$ChangePasswordModel {
  factory ChangePasswordModel(
      {@JsonKey(name: 'OldPassword', includeIfNull: false) String? oldPassword,
      @JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
      @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
      String? confirmNewPassword,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
      @Default(false)
      bool? passwordIsExpired,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ChangePasswordModel;

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);
}
