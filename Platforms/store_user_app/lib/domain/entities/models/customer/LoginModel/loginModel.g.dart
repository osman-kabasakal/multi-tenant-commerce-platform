// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loginModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginModelImpl _$$LoginModelImplFromJson(Map<String, dynamic> json) =>
    _$LoginModelImpl(
      checkoutAsGuest: json['CheckoutAsGuest'] as bool? ?? false,
      email: json['Email'] as String?,
      usernamesEnabled: json['UsernamesEnabled'] as bool? ?? false,
      username: json['Username'] as String?,
      password: json['Password'] as String?,
      rememberMe: json['RememberMe'] as bool? ?? false,
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

Map<String, dynamic> _$$LoginModelImplToJson(
  _$LoginModelImpl instance,
) => <String, dynamic>{
  if (instance.checkoutAsGuest case final value?) 'CheckoutAsGuest': value,
  if (instance.email case final value?) 'Email': value,
  if (instance.usernamesEnabled case final value?) 'UsernamesEnabled': value,
  if (instance.username case final value?) 'Username': value,
  if (instance.password case final value?) 'Password': value,
  if (instance.rememberMe case final value?) 'RememberMe': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
