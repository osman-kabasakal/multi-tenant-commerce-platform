import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'add_news_comment_model.freezed.dart';
part 'add_news_comment_model.g.dart';

@freezed
class AddNewsCommentModel extends StoreJsonSerializable<AddNewsCommentModel>
    with _$AddNewsCommentModel {
  factory AddNewsCommentModel(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'CommentTitle', includeIfNull: false) String? commentTitle,
      @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddNewsCommentModel;

  factory AddNewsCommentModel.fromJson(Map<String, dynamic> json) =>
      _$AddNewsCommentModelFromJson(json);
}
