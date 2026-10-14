// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_activation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountActivationModelImpl _$$AccountActivationModelImplFromJson(
  Map<String, dynamic> json,
) => _$AccountActivationModelImpl(
  result: json['Result'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AccountActivationModelImplToJson(
  _$AccountActivationModelImpl instance,
) => <String, dynamic>{
  if (instance.result case final value?) 'Result': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
