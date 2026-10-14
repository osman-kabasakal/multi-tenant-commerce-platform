// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthenticateModelImpl _$$AuthenticateModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthenticateModelImpl(
  id: json['Id'] as String?,
  password: json['Password'] as String?,
);

Map<String, dynamic> _$$AuthenticateModelImplToJson(
  _$AuthenticateModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.password case final value?) 'Password': value,
};
