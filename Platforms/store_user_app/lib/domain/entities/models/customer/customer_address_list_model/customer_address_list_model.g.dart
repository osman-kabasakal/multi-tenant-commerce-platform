// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerAddressListModelImpl _$$CustomerAddressListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerAddressListModelImpl(
  addresses:
      (json['Addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerAddressListModelImplToJson(
  _$CustomerAddressListModelImpl instance,
) => <String, dynamic>{
  if (instance.addresses case final value?) 'Addresses': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
