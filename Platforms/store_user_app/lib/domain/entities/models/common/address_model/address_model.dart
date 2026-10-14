import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../address_attribute_model/address_attribute_model.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

import '../../../common/user_field/user_field.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel extends StoreJsonSerializable<AddressModel>
    with _$AddressModel {
  factory AddressModel(
      {@JsonKey(name: 'NameEnabled', includeIfNull: false)
      @Default(false)
      bool? nameEnabled,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
      @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
      @Default(false)
      bool? companyEnabled,
      @JsonKey(name: 'CompanyRequired', includeIfNull: false)
      @Default(false)
      bool? companyRequired,
      @JsonKey(name: 'Company', includeIfNull: false) String? company,
      @JsonKey(name: 'VatNumberEnabled', includeIfNull: false)
      @Default(false)
      bool? vatNumberEnabled,
      @JsonKey(name: 'VatNumberRequired', includeIfNull: false)
      @Default(false)
      bool? vatNumberRequired,
      @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
      @JsonKey(name: 'CountryEnabled', includeIfNull: false)
      @Default(false)
      bool? countryEnabled,
      @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
      @JsonKey(name: 'CountryName', includeIfNull: false) String? countryName,
      @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
      @Default(false)
      bool? stateProvinceEnabled,
      @JsonKey(name: 'StateProvinceId', includeIfNull: false)
      String? stateProvinceId,
      @JsonKey(name: 'StateProvinceName', includeIfNull: false)
      String? stateProvinceName,
      @JsonKey(name: 'CityEnabled', includeIfNull: false)
      @Default(false)
      bool? cityEnabled,
      @JsonKey(name: 'CityRequired', includeIfNull: false)
      @Default(false)
      bool? cityRequired,
      @JsonKey(name: 'City', includeIfNull: false) String? city,
      @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
      @Default(false)
      bool? streetAddressEnabled,
      @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
      @Default(false)
      bool? streetAddressRequired,
      @JsonKey(name: 'Address1', includeIfNull: false) String? address1,
      @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
      @Default(false)
      bool? streetAddress2Enabled,
      @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
      @Default(false)
      bool? streetAddress2Required,
      @JsonKey(name: 'Address2', includeIfNull: false) String? address2,
      @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
      @Default(false)
      bool? zipPostalCodeEnabled,
      @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
      @Default(false)
      bool? zipPostalCodeRequired,
      @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
      String? zipPostalCode,
      @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
      @Default(false)
      bool? phoneEnabled,
      @JsonKey(name: 'PhoneRequired', includeIfNull: false)
      @Default(false)
      bool? phoneRequired,
      @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
      @JsonKey(name: 'FaxEnabled', includeIfNull: false)
      @Default(false)
      bool? faxEnabled,
      @JsonKey(name: 'FaxRequired', includeIfNull: false)
      @Default(false)
      bool? faxRequired,
      @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
      @JsonKey(name: 'NoteEnabled', includeIfNull: false)
      @Default(false)
      bool? noteEnabled,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'AvailableCountries', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCountries,
      @JsonKey(name: 'AvailableStates', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableStates,
      @JsonKey(name: 'FormattedCustomAddressAttributes', includeIfNull: false)
      String? formattedCustomAddressAttributes,
      @JsonKey(name: 'CustomAddressAttributes', includeIfNull: false)
      @Default([])
      List<AddressAttributeModel>? customAddressAttributes,
      @JsonKey(name: 'SelectedAttributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? selectedAttributes,
      @JsonKey(name: 'AddressTypeEnabled', includeIfNull: false)
      @Default(false)
      bool? addressTypeEnabled,
      @JsonKey(name: 'AddressTypeId', includeIfNull: false) int? addressTypeId,
      @JsonKey(name: 'HideAddressType', includeIfNull: false)
      @Default(false)
      bool? hideAddressType,
      @JsonKey(name: 'DisallowUsersToChangeEmail', includeIfNull: false)
      @Default(false)
      bool? disallowUsersToChangeEmail,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}
