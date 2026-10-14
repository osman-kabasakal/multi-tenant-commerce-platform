import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'password_recovery_model.freezed.dart';
part 'password_recovery_model.g.dart';

@freezed
class PasswordRecoveryModel extends StoreJsonSerializable<PasswordRecoveryModel>
    with _$PasswordRecoveryModel {
  factory PasswordRecoveryModel(
      {@JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'Send', includeIfNull: false) @Default(false) bool? send,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PasswordRecoveryModel;

  factory PasswordRecoveryModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordRecoveryModelFromJson(json);
}
