// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icaptcha_valid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ICaptchaValidModelImpl _$$ICaptchaValidModelImplFromJson(
  Map<String, dynamic> json,
) => _$ICaptchaValidModelImpl(
  reCaptchaChallengeField: json['ReCaptchaChallengeField'] as String?,
  reCaptchaResponseField: json['ReCaptchaResponseField'] as String?,
  reCaptchaResponseValue: json['ReCaptchaResponseValue'] as String?,
  reCaptchaResponse: json['ReCaptchaResponse'] as String?,
);

Map<String, dynamic> _$$ICaptchaValidModelImplToJson(
  _$ICaptchaValidModelImpl instance,
) => <String, dynamic>{
  if (instance.reCaptchaChallengeField case final value?)
    'ReCaptchaChallengeField': value,
  if (instance.reCaptchaResponseField case final value?)
    'ReCaptchaResponseField': value,
  if (instance.reCaptchaResponseValue case final value?)
    'ReCaptchaResponseValue': value,
  if (instance.reCaptchaResponse case final value?) 'ReCaptchaResponse': value,
};
