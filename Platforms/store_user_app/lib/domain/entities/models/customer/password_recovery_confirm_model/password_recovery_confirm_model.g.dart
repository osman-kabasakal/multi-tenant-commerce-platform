// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_confirm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordRecoveryConfirmModelImpl _$$PasswordRecoveryConfirmModelImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordRecoveryConfirmModelImpl(
  newPassword: json['NewPassword'] as String?,
  confirmNewPassword: json['ConfirmNewPassword'] as String?,
  disablePasswordChanging: json['DisablePasswordChanging'] as bool? ?? false,
  result: json['Result'] as String?,
  token: json['Token'] as String?,
  email: json['Email'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PasswordRecoveryConfirmModelImplToJson(
  _$PasswordRecoveryConfirmModelImpl instance,
) => <String, dynamic>{
  if (instance.newPassword case final value?) 'NewPassword': value,
  if (instance.confirmNewPassword case final value?)
    'ConfirmNewPassword': value,
  if (instance.disablePasswordChanging case final value?)
    'DisablePasswordChanging': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.token case final value?) 'Token': value,
  if (instance.email case final value?) 'Email': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
