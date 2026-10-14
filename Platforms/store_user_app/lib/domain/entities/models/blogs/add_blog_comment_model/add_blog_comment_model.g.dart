// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_blog_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddBlogCommentModelImpl _$$AddBlogCommentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddBlogCommentModelImpl(
  commentText: json['CommentText'] as String?,
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AddBlogCommentModelImplToJson(
  _$AddBlogCommentModelImpl instance,
) => <String, dynamic>{
  if (instance.commentText case final value?) 'CommentText': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
