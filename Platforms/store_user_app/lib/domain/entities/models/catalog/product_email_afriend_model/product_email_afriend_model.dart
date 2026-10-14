import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_email_afriend_model.freezed.dart';
part 'product_email_afriend_model.g.dart';

@freezed
class ProductEmailAFriendModel
    extends StoreJsonSerializable<ProductEmailAFriendModel>
    with _$ProductEmailAFriendModel {
  factory ProductEmailAFriendModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'FriendEmail', includeIfNull: false) String? friendEmail,
      @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
      String? yourEmailAddress,
      @JsonKey(name: 'PersonalMessage', includeIfNull: false)
      String? personalMessage,
      @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
      @Default(false)
      bool? successfullySent,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductEmailAFriendModel;

  factory ProductEmailAFriendModel.fromJson(Map<String, dynamic> json) =>
      _$ProductEmailAFriendModelFromJson(json);
}
