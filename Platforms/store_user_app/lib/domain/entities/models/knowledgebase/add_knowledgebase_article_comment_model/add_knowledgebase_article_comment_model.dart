import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'add_knowledgebase_article_comment_model.freezed.dart';
part 'add_knowledgebase_article_comment_model.g.dart';

@freezed
class AddKnowledgebaseArticleCommentModel
    extends StoreJsonSerializable<AddKnowledgebaseArticleCommentModel>
    with _$AddKnowledgebaseArticleCommentModel {
  factory AddKnowledgebaseArticleCommentModel(
      {@JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddKnowledgebaseArticleCommentModel;

  factory AddKnowledgebaseArticleCommentModel.fromJson(
          Map<String, dynamic> json) =>
      _$AddKnowledgebaseArticleCommentModelFromJson(json);
}
