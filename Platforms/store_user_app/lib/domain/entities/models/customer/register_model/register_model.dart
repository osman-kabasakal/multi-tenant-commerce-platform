import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

import '../customer_attribute_model/customer_attribute_model.dart';

import '../../newsletter/newsletter_simple_category/newsletter_simple_category.dart';

import '../../../common/user_field/user_field.dart';

part 'register_model.freezed.dart';
part 'register_model.g.dart';

@freezed
class RegisterModel extends StoreJsonSerializable<RegisterModel>
    with _$RegisterModel {
  factory RegisterModel(
      {@JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
      @Default(false)
      bool? usernamesEnabled,
      @JsonKey(name: 'Username', includeIfNull: false) String? username,
      @JsonKey(name: 'CheckUsernameAvailabilityEnabled', includeIfNull: false)
      @Default(false)
      bool? checkUsernameAvailabilityEnabled,
      @JsonKey(name: 'Password', includeIfNull: false) String? password,
      @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
      String? confirmPassword,
      @JsonKey(name: 'GenderEnabled', includeIfNull: false)
      @Default(false)
      bool? genderEnabled,
      @JsonKey(name: 'Gender', includeIfNull: false) String? gender,
      @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
      @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
      @JsonKey(name: 'FirstLastNameRequired', includeIfNull: false)
      @Default(false)
      bool? firstLastNameRequired,
      @JsonKey(name: 'DateOfBirthEnabled', includeIfNull: false)
      @Default(false)
      bool? dateOfBirthEnabled,
      @JsonKey(name: 'DateOfBirthDay', includeIfNull: false)
      @Default(null)
      int? dateOfBirthDay,
      @JsonKey(name: 'DateOfBirthMonth', includeIfNull: false)
      @Default(null)
      int? dateOfBirthMonth,
      @JsonKey(name: 'DateOfBirthYear', includeIfNull: false)
      @Default(null)
      int? dateOfBirthYear,
      @JsonKey(name: 'DateOfBirthRequired', includeIfNull: false)
      @Default(false)
      bool? dateOfBirthRequired,
      @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
      @Default(false)
      bool? companyEnabled,
      @JsonKey(name: 'CompanyRequired', includeIfNull: false)
      @Default(false)
      bool? companyRequired,
      @JsonKey(name: 'Company', includeIfNull: false) String? company,
      @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
      @Default(false)
      bool? streetAddressEnabled,
      @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
      @Default(false)
      bool? streetAddressRequired,
      @JsonKey(name: 'StreetAddress', includeIfNull: false)
      String? streetAddress,
      @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
      @Default(false)
      bool? streetAddress2Enabled,
      @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
      @Default(false)
      bool? streetAddress2Required,
      @JsonKey(name: 'StreetAddress2', includeIfNull: false)
      String? streetAddress2,
      @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
      @Default(false)
      bool? zipPostalCodeEnabled,
      @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
      @Default(false)
      bool? zipPostalCodeRequired,
      @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
      String? zipPostalCode,
      @JsonKey(name: 'CityEnabled', includeIfNull: false)
      @Default(false)
      bool? cityEnabled,
      @JsonKey(name: 'CityRequired', includeIfNull: false)
      @Default(false)
      bool? cityRequired,
      @JsonKey(name: 'City', includeIfNull: false) String? city,
      @JsonKey(name: 'CountryEnabled', includeIfNull: false)
      @Default(false)
      bool? countryEnabled,
      @JsonKey(name: 'CountryRequired', includeIfNull: false)
      @Default(false)
      bool? countryRequired,
      @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
      @JsonKey(name: 'AvailableCountries', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCountries,
      @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
      @Default(false)
      bool? stateProvinceEnabled,
      @JsonKey(name: 'StateProvinceRequired', includeIfNull: false)
      @Default(false)
      bool? stateProvinceRequired,
      @JsonKey(name: 'StateProvinceId', includeIfNull: false)
      String? stateProvinceId,
      @JsonKey(name: 'AvailableStates', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableStates,
      @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
      @Default(false)
      bool? phoneEnabled,
      @JsonKey(name: 'PhoneRequired', includeIfNull: false)
      @Default(false)
      bool? phoneRequired,
      @JsonKey(name: 'Phone', includeIfNull: false) String? phone,
      @JsonKey(name: 'FaxEnabled', includeIfNull: false)
      @Default(false)
      bool? faxEnabled,
      @JsonKey(name: 'FaxRequired', includeIfNull: false)
      @Default(false)
      bool? faxRequired,
      @JsonKey(name: 'Fax', includeIfNull: false) String? fax,
      @JsonKey(name: 'NewsletterEnabled', includeIfNull: false)
      @Default(false)
      bool? newsletterEnabled,
      @JsonKey(name: 'Newsletter', includeIfNull: false)
      @Default(false)
      bool? newsletter,
      @JsonKey(name: 'SelectedNewsletterCategory', includeIfNull: false)
      @Default([])
      List<String>? selectedNewsletterCategory,
      @JsonKey(name: 'AcceptPrivacyPolicyEnabled', includeIfNull: false)
      @Default(false)
      bool? acceptPrivacyPolicyEnabled,
      @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
      @JsonKey(name: 'DisplayVatNumber', includeIfNull: false)
      @Default(false)
      bool? displayVatNumber,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'SelectedAttributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? selectedAttributes,
      @JsonKey(name: 'CustomerAttributes', includeIfNull: false)
      @Default([])
      List<CustomerAttributeModel>? customerAttributes,
      @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
      @Default([])
      List<NewsletterSimpleCategory>? newsletterCategories,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _RegisterModel;

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);
}
