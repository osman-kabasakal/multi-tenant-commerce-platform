import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_ask_question_simple_model.freezed.dart';
part 'product_ask_question_simple_model.g.dart';

@freezed
class ProductAskQuestionSimpleModel
    extends StoreJsonSerializable<ProductAskQuestionSimpleModel>
    with _$ProductAskQuestionSimpleModel {
  factory ProductAskQuestionSimpleModel(
      {@JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
      String? askQuestionEmail,
      @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
      String? askQuestionFullName,
      @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
      String? askQuestionPhone,
      @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
      String? askQuestionMessage,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductAskQuestionSimpleModel;

  factory ProductAskQuestionSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAskQuestionSimpleModelFromJson(json);
}
