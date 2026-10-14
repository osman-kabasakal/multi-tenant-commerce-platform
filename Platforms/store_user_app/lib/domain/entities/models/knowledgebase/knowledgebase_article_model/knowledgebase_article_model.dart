import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../knowledgebase_category_model/knowledgebase_category_model.dart';

import '../add_knowledgebase_article_comment_model/add_knowledgebase_article_comment_model.dart';

import '../knowledgebase_article_comment_model/knowledgebase_article_comment_model.dart';

import '../../../common/user_field/user_field.dart';

part 'knowledgebase_article_model.freezed.dart';
part 'knowledgebase_article_model.g.dart';

@freezed
class KnowledgebaseArticleModel
    extends StoreJsonSerializable<KnowledgebaseArticleModel>
    with _$KnowledgebaseArticleModel {
  factory KnowledgebaseArticleModel(
      {@JsonKey(name: 'ArticleId', includeIfNull: false) String? articleId,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Content', includeIfNull: false) String? content,
      @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
      String? parentCategoryId,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'AllowComments', includeIfNull: false)
      @Default(false)
      bool? allowComments,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'RelatedArticles', includeIfNull: false)
      @Default([])
      List<KnowledgebaseArticleModel>? relatedArticles,
      @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
      @Default([])
      List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
      @JsonKey(name: 'AddNewComment', includeIfNull: false)
      AddKnowledgebaseArticleCommentModel? addNewComment,
      @JsonKey(name: 'Comments', includeIfNull: false)
      @Default([])
      List<KnowledgebaseArticleCommentModel>? comments,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _KnowledgebaseArticleModel;

  factory KnowledgebaseArticleModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgebaseArticleModelFromJson(json);
}
