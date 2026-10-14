// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeleteAccountModelImpl _$$DeleteAccountModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeleteAccountModelImpl(
  password: json['Password'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DeleteAccountModelImplToJson(
  _$DeleteAccountModelImpl instance,
) => <String, dynamic>{
  if (instance.password case final value?) 'Password': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
