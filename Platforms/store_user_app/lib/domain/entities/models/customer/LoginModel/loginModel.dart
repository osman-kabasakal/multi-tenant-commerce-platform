import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';
import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

part 'loginModel.freezed.dart';

part 'loginModel.g.dart';

@freezed
class LoginModel extends StoreJsonSerializable<LoginModel> with _$LoginModel {
  factory LoginModel(
      {@JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
      @Default(false)
      bool? checkoutAsGuest,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
      @Default(false)
      bool? usernamesEnabled,
      @JsonKey(name: 'Username', includeIfNull: false) String? username,
      @JsonKey(name: 'Password', includeIfNull: false) String? password,
      @JsonKey(name: 'RememberMe', includeIfNull: false)
      @Default(false)
      bool? rememberMe,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}
