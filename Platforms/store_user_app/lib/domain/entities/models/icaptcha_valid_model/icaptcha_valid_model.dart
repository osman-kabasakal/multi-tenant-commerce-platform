import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'icaptcha_valid_model.freezed.dart';
part 'icaptcha_valid_model.g.dart';

@freezed
class ICaptchaValidModel extends StoreJsonSerializable<ICaptchaValidModel>
    with _$ICaptchaValidModel {
  factory ICaptchaValidModel(
      {@JsonKey(name: 'ReCaptchaChallengeField', includeIfNull: false)
      String? reCaptchaChallengeField,
      @JsonKey(name: 'ReCaptchaResponseField', includeIfNull: false)
      String? reCaptchaResponseField,
      @JsonKey(name: 'ReCaptchaResponseValue', includeIfNull: false)
      String? reCaptchaResponseValue,
      @JsonKey(name: 'ReCaptchaResponse', includeIfNull: false)
      String? reCaptchaResponse}) = _ICaptchaValidModel;

  factory ICaptchaValidModel.fromJson(Map<String, dynamic> json) =>
      _$ICaptchaValidModelFromJson(json);
}
