// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_account_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubAccountCreateModelImpl _$$SubAccountCreateModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubAccountCreateModelImpl(
  email: json['Email'] as String?,
  firstName: json['FirstName'] as String?,
  lastName: json['LastName'] as String?,
  active: json['Active'] as bool? ?? false,
  password: json['Password'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SubAccountCreateModelImplToJson(
  _$SubAccountCreateModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.firstName case final value?) 'FirstName': value,
  if (instance.lastName case final value?) 'LastName': value,
  if (instance.active case final value?) 'Active': value,
  if (instance.password case final value?) 'Password': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
