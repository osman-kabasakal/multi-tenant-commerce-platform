import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../custom_attribute/custom_attribute.dart';

import '../address_type/address_type.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address extends StoreJsonSerializable<Address> with _$Address {
  factory Address(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
      @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'Company', includeIfNull: false) String? company,
      @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
      @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
      @JsonKey(name: 'StateProvinceId', includeIfNull: false)
      String? stateProvinceId,
      @JsonKey(name: 'City', includeIfNull: false) String? city,
      @JsonKey(name: 'Address1', includeIfNull: false) String? address1,
      @JsonKey(name: 'Address2', includeIfNull: false) String? address2,
      @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
      String? zipPostalCode,
      @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
      @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'Attributes', includeIfNull: false)
      @Default([])
      List<CustomAttribute>? attributes,
      @JsonKey(name: 'AddressType', includeIfNull: false)
      @Default(AddressType.any)
      AddressType? addressType,
      @JsonKey(name: 'Id', includeIfNull: false) String? id}) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
