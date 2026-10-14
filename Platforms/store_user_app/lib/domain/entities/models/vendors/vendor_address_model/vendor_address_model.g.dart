// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorAddressModelImpl _$$VendorAddressModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorAddressModelImpl(
  companyEnabled: json['CompanyEnabled'] as bool? ?? false,
  companyRequired: json['CompanyRequired'] as bool? ?? false,
  company: json['Company'] as String?,
  countryEnabled: json['CountryEnabled'] as bool? ?? false,
  countryId: json['CountryId'] as String?,
  countryName: json['CountryName'] as String?,
  stateProvinceEnabled: json['StateProvinceEnabled'] as bool? ?? false,
  stateProvinceId: json['StateProvinceId'] as String?,
  stateProvinceName: json['StateProvinceName'] as String?,
  cityEnabled: json['CityEnabled'] as bool? ?? false,
  cityRequired: json['CityRequired'] as bool? ?? false,
  city: json['City'] as String?,
  streetAddressEnabled: json['StreetAddressEnabled'] as bool? ?? false,
  streetAddressRequired: json['StreetAddressRequired'] as bool? ?? false,
  address1: json['Address1'] as String?,
  streetAddress2Enabled: json['StreetAddress2Enabled'] as bool? ?? false,
  streetAddress2Required: json['StreetAddress2Required'] as bool? ?? false,
  address2: json['Address2'] as String?,
  zipPostalCodeEnabled: json['ZipPostalCodeEnabled'] as bool? ?? false,
  zipPostalCodeRequired: json['ZipPostalCodeRequired'] as bool? ?? false,
  zipPostalCode: json['ZipPostalCode'] as String?,
  phoneEnabled: json['PhoneEnabled'] as bool? ?? false,
  phoneRequired: json['PhoneRequired'] as bool? ?? false,
  phoneNumber: json['PhoneNumber'] as String?,
  faxEnabled: json['FaxEnabled'] as bool? ?? false,
  faxRequired: json['FaxRequired'] as bool? ?? false,
  faxNumber: json['FaxNumber'] as String?,
  note: json['Note'] as String?,
  availableCountries:
      (json['AvailableCountries'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  availableStates:
      (json['AvailableStates'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorAddressModelImplToJson(
  _$VendorAddressModelImpl instance,
) => <String, dynamic>{
  if (instance.companyEnabled case final value?) 'CompanyEnabled': value,
  if (instance.companyRequired case final value?) 'CompanyRequired': value,
  if (instance.company case final value?) 'Company': value,
  if (instance.countryEnabled case final value?) 'CountryEnabled': value,
  if (instance.countryId case final value?) 'CountryId': value,
  if (instance.countryName case final value?) 'CountryName': value,
  if (instance.stateProvinceEnabled case final value?)
    'StateProvinceEnabled': value,
  if (instance.stateProvinceId case final value?) 'StateProvinceId': value,
  if (instance.stateProvinceName case final value?) 'StateProvinceName': value,
  if (instance.cityEnabled case final value?) 'CityEnabled': value,
  if (instance.cityRequired case final value?) 'CityRequired': value,
  if (instance.city case final value?) 'City': value,
  if (instance.streetAddressEnabled case final value?)
    'StreetAddressEnabled': value,
  if (instance.streetAddressRequired case final value?)
    'StreetAddressRequired': value,
  if (instance.address1 case final value?) 'Address1': value,
  if (instance.streetAddress2Enabled case final value?)
    'StreetAddress2Enabled': value,
  if (instance.streetAddress2Required case final value?)
    'StreetAddress2Required': value,
  if (instance.address2 case final value?) 'Address2': value,
  if (instance.zipPostalCodeEnabled case final value?)
    'ZipPostalCodeEnabled': value,
  if (instance.zipPostalCodeRequired case final value?)
    'ZipPostalCodeRequired': value,
  if (instance.zipPostalCode case final value?) 'ZipPostalCode': value,
  if (instance.phoneEnabled case final value?) 'PhoneEnabled': value,
  if (instance.phoneRequired case final value?) 'PhoneRequired': value,
  if (instance.phoneNumber case final value?) 'PhoneNumber': value,
  if (instance.faxEnabled case final value?) 'FaxEnabled': value,
  if (instance.faxRequired case final value?) 'FaxRequired': value,
  if (instance.faxNumber case final value?) 'FaxNumber': value,
  if (instance.note case final value?) 'Note': value,
  if (instance.availableCountries case final value?)
    'AvailableCountries': value,
  if (instance.availableStates case final value?) 'AvailableStates': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
