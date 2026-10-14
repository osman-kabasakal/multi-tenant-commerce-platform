// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledgebase_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KnowledgebaseArticleModelImpl _$$KnowledgebaseArticleModelImplFromJson(
  Map<String, dynamic> json,
) => _$KnowledgebaseArticleModelImpl(
  articleId: json['ArticleId'] as String?,
  name: json['Name'] as String?,
  content: json['Content'] as String?,
  parentCategoryId: json['ParentCategoryId'] as String?,
  seName: json['SeName'] as String?,
  metaKeywords: json['MetaKeywords'] as String?,
  metaDescription: json['MetaDescription'] as String?,
  metaTitle: json['MetaTitle'] as String?,
  allowComments: json['AllowComments'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  relatedArticles:
      (json['RelatedArticles'] as List<dynamic>?)
          ?.map(
            (e) =>
                KnowledgebaseArticleModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  categoryBreadcrumb:
      (json['CategoryBreadcrumb'] as List<dynamic>?)
          ?.map(
            (e) =>
                KnowledgebaseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  addNewComment:
      json['AddNewComment'] == null
          ? null
          : AddKnowledgebaseArticleCommentModel.fromJson(
            json['AddNewComment'] as Map<String, dynamic>,
          ),
  comments:
      (json['Comments'] as List<dynamic>?)
          ?.map(
            (e) => KnowledgebaseArticleCommentModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$KnowledgebaseArticleModelImplToJson(
  _$KnowledgebaseArticleModelImpl instance,
) => <String, dynamic>{
  if (instance.articleId case final value?) 'ArticleId': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.content case final value?) 'Content': value,
  if (instance.parentCategoryId case final value?) 'ParentCategoryId': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.allowComments case final value?) 'AllowComments': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.relatedArticles case final value?) 'RelatedArticles': value,
  if (instance.categoryBreadcrumb case final value?)
    'CategoryBreadcrumb': value,
  if (instance.addNewComment case final value?) 'AddNewComment': value,
  if (instance.comments case final value?) 'Comments': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
