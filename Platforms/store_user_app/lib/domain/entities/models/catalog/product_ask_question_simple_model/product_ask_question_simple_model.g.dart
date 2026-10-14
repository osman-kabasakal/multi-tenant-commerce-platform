// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_ask_question_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductAskQuestionSimpleModelImpl
_$$ProductAskQuestionSimpleModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductAskQuestionSimpleModelImpl(
      askQuestionEmail: json['AskQuestionEmail'] as String?,
      askQuestionFullName: json['AskQuestionFullName'] as String?,
      askQuestionPhone: json['AskQuestionPhone'] as String?,
      askQuestionMessage: json['AskQuestionMessage'] as String?,
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

Map<String, dynamic> _$$ProductAskQuestionSimpleModelImplToJson(
  _$ProductAskQuestionSimpleModelImpl instance,
) => <String, dynamic>{
  if (instance.askQuestionEmail case final value?) 'AskQuestionEmail': value,
  if (instance.askQuestionFullName case final value?)
    'AskQuestionFullName': value,
  if (instance.askQuestionPhone case final value?) 'AskQuestionPhone': value,
  if (instance.askQuestionMessage case final value?)
    'AskQuestionMessage': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
