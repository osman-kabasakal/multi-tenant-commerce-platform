import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'wishlist_email_afriend_model.freezed.dart';
part 'wishlist_email_afriend_model.g.dart';

@freezed
class WishlistEmailAFriendModel
    extends StoreJsonSerializable<WishlistEmailAFriendModel>
    with _$WishlistEmailAFriendModel {
  factory WishlistEmailAFriendModel(
      {@JsonKey(name: 'FriendEmail', includeIfNull: false) String? friendEmail,
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
      List<UserField>? userFields}) = _WishlistEmailAFriendModel;

  factory WishlistEmailAFriendModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistEmailAFriendModelFromJson(json);
}
