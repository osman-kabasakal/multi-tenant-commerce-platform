// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoModelImpl _$$CustomerInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerInfoModelImpl(
  email: json['Email'] as String?,
  allowUsersToChangeEmail: json['AllowUsersToChangeEmail'] as bool? ?? false,
  checkUsernameAvailabilityEnabled:
      json['CheckUsernameAvailabilityEnabled'] as bool? ?? false,
  allowUsersToChangeUsernames:
      json['AllowUsersToChangeUsernames'] as bool? ?? false,
  usernamesEnabled: json['UsernamesEnabled'] as bool? ?? false,
  username: json['Username'] as String?,
  genderEnabled: json['GenderEnabled'] as bool? ?? false,
  gender: json['Gender'] as String?,
  firstName: json['FirstName'] as String?,
  lastName: json['LastName'] as String?,
  firstLastNameRequired: json['FirstLastNameRequired'] as bool? ?? false,
  dateOfBirthEnabled: json['DateOfBirthEnabled'] as bool? ?? false,
  dateOfBirthDay: (json['DateOfBirthDay'] as num?)?.toInt() ?? null,
  dateOfBirthMonth: (json['DateOfBirthMonth'] as num?)?.toInt() ?? null,
  dateOfBirthYear: (json['DateOfBirthYear'] as num?)?.toInt() ?? null,
  dateOfBirthRequired: json['DateOfBirthRequired'] as bool? ?? false,
  companyEnabled: json['CompanyEnabled'] as bool? ?? false,
  companyRequired: json['CompanyRequired'] as bool? ?? false,
  company: json['Company'] as String?,
  streetAddressEnabled: json['StreetAddressEnabled'] as bool? ?? false,
  streetAddressRequired: json['StreetAddressRequired'] as bool? ?? false,
  streetAddress: json['StreetAddress'] as String?,
  streetAddress2Enabled: json['StreetAddress2Enabled'] as bool? ?? false,
  streetAddress2Required: json['StreetAddress2Required'] as bool? ?? false,
  streetAddress2: json['StreetAddress2'] as String?,
  zipPostalCodeEnabled: json['ZipPostalCodeEnabled'] as bool? ?? false,
  zipPostalCodeRequired: json['ZipPostalCodeRequired'] as bool? ?? false,
  zipPostalCode: json['ZipPostalCode'] as String?,
  cityEnabled: json['CityEnabled'] as bool? ?? false,
  cityRequired: json['CityRequired'] as bool? ?? false,
  city: json['City'] as String?,
  countryEnabled: json['CountryEnabled'] as bool? ?? false,
  countryRequired: json['CountryRequired'] as bool? ?? false,
  countryId: json['CountryId'] as String?,
  availableCountries:
      (json['AvailableCountries'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  stateProvinceEnabled: json['StateProvinceEnabled'] as bool? ?? false,
  stateProvinceRequired: json['StateProvinceRequired'] as bool? ?? false,
  stateProvinceId: json['StateProvinceId'] as String?,
  availableStates:
      (json['AvailableStates'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  phoneEnabled: json['PhoneEnabled'] as bool? ?? false,
  phoneRequired: json['PhoneRequired'] as bool? ?? false,
  phone: json['Phone'] as String?,
  faxEnabled: json['FaxEnabled'] as bool? ?? false,
  faxRequired: json['FaxRequired'] as bool? ?? false,
  fax: json['Fax'] as String?,
  newsletterEnabled: json['NewsletterEnabled'] as bool? ?? false,
  newsletter: json['Newsletter'] as bool? ?? false,
  selectedNewsletterCategory:
      (json['SelectedNewsletterCategory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  is2faEnabled: json['Is2faEnabled'] as bool? ?? false,
  vatNumber: json['VatNumber'] as String?,
  vatNumberStatusNote: json['VatNumberStatusNote'] as String?,
  displayVatNumber: json['DisplayVatNumber'] as bool? ?? false,
  associatedExternalAuthRecords:
      (json['AssociatedExternalAuthRecords'] as List<dynamic>?)
          ?.map(
            (e) =>
                AssociatedExternalAuthModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  numberOfExternalAuthenticationProviders:
      (json['NumberOfExternalAuthenticationProviders'] as num?)?.toInt(),
  selectedAttributes:
      (json['SelectedAttributes'] as List<dynamic>?)
          ?.map((e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customerAttributes:
      (json['CustomerAttributes'] as List<dynamic>?)
          ?.map(
            (e) => CustomerAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  newsletterCategories:
      (json['NewsletterCategories'] as List<dynamic>?)
          ?.map(
            (e) => NewsletterSimpleCategory.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerInfoModelImplToJson(
  _$CustomerInfoModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.allowUsersToChangeEmail case final value?)
    'AllowUsersToChangeEmail': value,
  if (instance.checkUsernameAvailabilityEnabled case final value?)
    'CheckUsernameAvailabilityEnabled': value,
  if (instance.allowUsersToChangeUsernames case final value?)
    'AllowUsersToChangeUsernames': value,
  if (instance.usernamesEnabled case final value?) 'UsernamesEnabled': value,
  if (instance.username case final value?) 'Username': value,
  if (instance.genderEnabled case final value?) 'GenderEnabled': value,
  if (instance.gender case final value?) 'Gender': value,
  if (instance.firstName case final value?) 'FirstName': value,
  if (instance.lastName case final value?) 'LastName': value,
  if (instance.firstLastNameRequired case final value?)
    'FirstLastNameRequired': value,
  if (instance.dateOfBirthEnabled case final value?)
    'DateOfBirthEnabled': value,
  if (instance.dateOfBirthDay case final value?) 'DateOfBirthDay': value,
  if (instance.dateOfBirthMonth case final value?) 'DateOfBirthMonth': value,
  if (instance.dateOfBirthYear case final value?) 'DateOfBirthYear': value,
  if (instance.dateOfBirthRequired case final value?)
    'DateOfBirthRequired': value,
  if (instance.companyEnabled case final value?) 'CompanyEnabled': value,
  if (instance.companyRequired case final value?) 'CompanyRequired': value,
  if (instance.company case final value?) 'Company': value,
  if (instance.streetAddressEnabled case final value?)
    'StreetAddressEnabled': value,
  if (instance.streetAddressRequired case final value?)
    'StreetAddressRequired': value,
  if (instance.streetAddress case final value?) 'StreetAddress': value,
  if (instance.streetAddress2Enabled case final value?)
    'StreetAddress2Enabled': value,
  if (instance.streetAddress2Required case final value?)
    'StreetAddress2Required': value,
  if (instance.streetAddress2 case final value?) 'StreetAddress2': value,
  if (instance.zipPostalCodeEnabled case final value?)
    'ZipPostalCodeEnabled': value,
  if (instance.zipPostalCodeRequired case final value?)
    'ZipPostalCodeRequired': value,
  if (instance.zipPostalCode case final value?) 'ZipPostalCode': value,
  if (instance.cityEnabled case final value?) 'CityEnabled': value,
  if (instance.cityRequired case final value?) 'CityRequired': value,
  if (instance.city case final value?) 'City': value,
  if (instance.countryEnabled case final value?) 'CountryEnabled': value,
  if (instance.countryRequired case final value?) 'CountryRequired': value,
  if (instance.countryId case final value?) 'CountryId': value,
  if (instance.availableCountries case final value?)
    'AvailableCountries': value,
  if (instance.stateProvinceEnabled case final value?)
    'StateProvinceEnabled': value,
  if (instance.stateProvinceRequired case final value?)
    'StateProvinceRequired': value,
  if (instance.stateProvinceId case final value?) 'StateProvinceId': value,
  if (instance.availableStates case final value?) 'AvailableStates': value,
  if (instance.phoneEnabled case final value?) 'PhoneEnabled': value,
  if (instance.phoneRequired case final value?) 'PhoneRequired': value,
  if (instance.phone case final value?) 'Phone': value,
  if (instance.faxEnabled case final value?) 'FaxEnabled': value,
  if (instance.faxRequired case final value?) 'FaxRequired': value,
  if (instance.fax case final value?) 'Fax': value,
  if (instance.newsletterEnabled case final value?) 'NewsletterEnabled': value,
  if (instance.newsletter case final value?) 'Newsletter': value,
  if (instance.selectedNewsletterCategory case final value?)
    'SelectedNewsletterCategory': value,
  if (instance.is2faEnabled case final value?) 'Is2faEnabled': value,
  if (instance.vatNumber case final value?) 'VatNumber': value,
  if (instance.vatNumberStatusNote case final value?)
    'VatNumberStatusNote': value,
  if (instance.displayVatNumber case final value?) 'DisplayVatNumber': value,
  if (instance.associatedExternalAuthRecords case final value?)
    'AssociatedExternalAuthRecords': value,
  if (instance.numberOfExternalAuthenticationProviders case final value?)
    'NumberOfExternalAuthenticationProviders': value,
  if (instance.selectedAttributes case final value?)
    'SelectedAttributes': value,
  if (instance.customerAttributes case final value?)
    'CustomerAttributes': value,
  if (instance.newsletterCategories case final value?)
    'NewsletterCategories': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
