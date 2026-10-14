// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_news_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddNewsCommentModelImpl _$$AddNewsCommentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddNewsCommentModelImpl(
  id: json['Id'] as String?,
  commentTitle: json['CommentTitle'] as String?,
  commentText: json['CommentText'] as String?,
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AddNewsCommentModelImplToJson(
  _$AddNewsCommentModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.commentTitle case final value?) 'CommentTitle': value,
  if (instance.commentText case final value?) 'CommentText': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
