// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerAddressEditModelImpl _$$CustomerAddressEditModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerAddressEditModelImpl(
  address:
      json['Address'] == null
          ? null
          : AddressModel.fromJson(json['Address'] as Map<String, dynamic>),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerAddressEditModelImplToJson(
  _$CustomerAddressEditModelImpl instance,
) => <String, dynamic>{
  if (instance.address case final value?) 'Address': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
