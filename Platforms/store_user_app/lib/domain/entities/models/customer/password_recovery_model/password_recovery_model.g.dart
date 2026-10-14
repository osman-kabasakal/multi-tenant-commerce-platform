// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordRecoveryModelImpl _$$PasswordRecoveryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordRecoveryModelImpl(
  email: json['Email'] as String?,
  result: json['Result'] as String?,
  send: json['Send'] as bool? ?? false,
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

Map<String, dynamic> _$$PasswordRecoveryModelImplToJson(
  _$PasswordRecoveryModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.send case final value?) 'Send': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
