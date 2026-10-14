// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_knowledgebase_article_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddKnowledgebaseArticleCommentModelImpl
_$$AddKnowledgebaseArticleCommentModelImplFromJson(Map<String, dynamic> json) =>
    _$AddKnowledgebaseArticleCommentModelImpl(
      commentText: json['CommentText'] as String?,
      displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AddKnowledgebaseArticleCommentModelImplToJson(
  _$AddKnowledgebaseArticleCommentModelImpl instance,
) => <String, dynamic>{
  if (instance.commentText case final value?) 'CommentText': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
