// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_type_cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangeTypeCartItemModelImpl _$$ChangeTypeCartItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ChangeTypeCartItemModelImpl(
  id: json['Id'] as String?,
  status: json['Status'] as bool? ?? false,
);

Map<String, dynamic> _$$ChangeTypeCartItemModelImplToJson(
  _$ChangeTypeCartItemModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.status case final value?) 'Status': value,
};
