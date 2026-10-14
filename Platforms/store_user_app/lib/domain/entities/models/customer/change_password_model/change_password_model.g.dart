// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangePasswordModelImpl _$$ChangePasswordModelImplFromJson(
  Map<String, dynamic> json,
) => _$ChangePasswordModelImpl(
  oldPassword: json['OldPassword'] as String?,
  newPassword: json['NewPassword'] as String?,
  confirmNewPassword: json['ConfirmNewPassword'] as String?,
  result: json['Result'] as String?,
  passwordIsExpired: json['PasswordIsExpired'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ChangePasswordModelImplToJson(
  _$ChangePasswordModelImpl instance,
) => <String, dynamic>{
  if (instance.oldPassword case final value?) 'OldPassword': value,
  if (instance.newPassword case final value?) 'NewPassword': value,
  if (instance.confirmNewPassword case final value?)
    'ConfirmNewPassword': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.passwordIsExpired case final value?) 'PasswordIsExpired': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
