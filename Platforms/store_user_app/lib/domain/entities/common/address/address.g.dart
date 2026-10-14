// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      name: json['Name'] as String?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      email: json['Email'] as String?,
      company: json['Company'] as String?,
      vatNumber: json['VatNumber'] as String?,
      countryId: json['CountryId'] as String?,
      stateProvinceId: json['StateProvinceId'] as String?,
      city: json['City'] as String?,
      address1: json['Address1'] as String?,
      address2: json['Address2'] as String?,
      zipPostalCode: json['ZipPostalCode'] as String?,
      phoneNumber: json['PhoneNumber'] as String?,
      faxNumber: json['FaxNumber'] as String?,
      note: json['Note'] as String?,
      attributes:
          (json['Attributes'] as List<dynamic>?)
              ?.map((e) => CustomAttribute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      addressType:
          $enumDecodeNullable(_$AddressTypeEnumMap, json['AddressType']) ??
          AddressType.any,
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'Name': value,
      if (instance.firstName case final value?) 'FirstName': value,
      if (instance.lastName case final value?) 'LastName': value,
      if (instance.email case final value?) 'Email': value,
      if (instance.company case final value?) 'Company': value,
      if (instance.vatNumber case final value?) 'VatNumber': value,
      if (instance.countryId case final value?) 'CountryId': value,
      if (instance.stateProvinceId case final value?) 'StateProvinceId': value,
      if (instance.city case final value?) 'City': value,
      if (instance.address1 case final value?) 'Address1': value,
      if (instance.address2 case final value?) 'Address2': value,
      if (instance.zipPostalCode case final value?) 'ZipPostalCode': value,
      if (instance.phoneNumber case final value?) 'PhoneNumber': value,
      if (instance.faxNumber case final value?) 'FaxNumber': value,
      if (instance.note case final value?) 'Note': value,
      if (instance.attributes case final value?) 'Attributes': value,
      if (_$AddressTypeEnumMap[instance.addressType] case final value?)
        'AddressType': value,
      if (instance.id case final value?) 'Id': value,
    };

const _$AddressTypeEnumMap = {
  AddressType.any: 0,
  AddressType.billing: 1,
  AddressType.shipping: 2,
};
