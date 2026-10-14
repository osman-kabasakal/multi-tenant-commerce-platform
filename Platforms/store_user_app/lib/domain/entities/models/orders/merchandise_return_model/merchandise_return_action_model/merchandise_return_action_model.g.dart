// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnActionModelImpl _$$MerchandiseReturnActionModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnActionModelImpl(
  name: json['Name'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnActionModelImplToJson(
  _$MerchandiseReturnActionModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
