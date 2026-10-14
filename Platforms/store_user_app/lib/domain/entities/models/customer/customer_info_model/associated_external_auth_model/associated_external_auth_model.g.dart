// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'associated_external_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssociatedExternalAuthModelImpl _$$AssociatedExternalAuthModelImplFromJson(
  Map<String, dynamic> json,
) => _$AssociatedExternalAuthModelImpl(
  email: json['Email'] as String?,
  externalIdentifier: json['ExternalIdentifier'] as String?,
  authMethodName: json['AuthMethodName'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AssociatedExternalAuthModelImplToJson(
  _$AssociatedExternalAuthModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.externalIdentifier case final value?)
    'ExternalIdentifier': value,
  if (instance.authMethodName case final value?) 'AuthMethodName': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
