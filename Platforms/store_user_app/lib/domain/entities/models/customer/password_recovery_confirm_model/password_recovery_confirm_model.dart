import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'password_recovery_confirm_model.freezed.dart';
part 'password_recovery_confirm_model.g.dart';

@freezed
class PasswordRecoveryConfirmModel
    extends StoreJsonSerializable<PasswordRecoveryConfirmModel>
    with _$PasswordRecoveryConfirmModel {
  factory PasswordRecoveryConfirmModel(
      {@JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
      @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
      String? confirmNewPassword,
      @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
      @Default(false)
      bool? disablePasswordChanging,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'Token', includeIfNull: false) String? token,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PasswordRecoveryConfirmModel;

  factory PasswordRecoveryConfirmModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordRecoveryConfirmModelFromJson(json);
}
