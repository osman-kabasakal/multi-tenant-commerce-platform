// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_account_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubAccountSimpleModelImpl _$$SubAccountSimpleModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubAccountSimpleModelImpl(
  email: json['Email'] as String?,
  firstName: json['FirstName'] as String?,
  lastName: json['LastName'] as String?,
  active: json['Active'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SubAccountSimpleModelImplToJson(
  _$SubAccountSimpleModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.firstName case final value?) 'FirstName': value,
  if (instance.lastName case final value?) 'LastName': value,
  if (instance.active case final value?) 'Active': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
