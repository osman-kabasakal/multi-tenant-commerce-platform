// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'FirstName', includeIfNull: false)
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'LastName', includeIfNull: false)
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'Company', includeIfNull: false)
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  String? get vatNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'City', includeIfNull: false)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address1', includeIfNull: false)
  String? get address1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address2', includeIfNull: false)
  String? get address2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  String? get faxNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttribute>? get attributes => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddressType', includeIfNull: false)
  AddressType? get addressType => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
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
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttribute>? attributes,
    @JsonKey(name: 'AddressType', includeIfNull: false)
    AddressType? addressType,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? company = freezed,
    Object? vatNumber = freezed,
    Object? countryId = freezed,
    Object? stateProvinceId = freezed,
    Object? city = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? zipPostalCode = freezed,
    Object? phoneNumber = freezed,
    Object? faxNumber = freezed,
    Object? note = freezed,
    Object? attributes = freezed,
    Object? addressType = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            firstName:
                freezed == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastName:
                freezed == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            company:
                freezed == company
                    ? _value.company
                    : company // ignore: cast_nullable_to_non_nullable
                        as String?,
            vatNumber:
                freezed == vatNumber
                    ? _value.vatNumber
                    : vatNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            countryId:
                freezed == countryId
                    ? _value.countryId
                    : countryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            stateProvinceId:
                freezed == stateProvinceId
                    ? _value.stateProvinceId
                    : stateProvinceId // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            address1:
                freezed == address1
                    ? _value.address1
                    : address1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            address2:
                freezed == address2
                    ? _value.address2
                    : address2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            zipPostalCode:
                freezed == zipPostalCode
                    ? _value.zipPostalCode
                    : zipPostalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            phoneNumber:
                freezed == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            faxNumber:
                freezed == faxNumber
                    ? _value.faxNumber
                    : faxNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
                        as String?,
            attributes:
                freezed == attributes
                    ? _value.attributes
                    : attributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttribute>?,
            addressType:
                freezed == addressType
                    ? _value.addressType
                    : addressType // ignore: cast_nullable_to_non_nullable
                        as AddressType?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
    _$AddressImpl value,
    $Res Function(_$AddressImpl) then,
  ) = __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
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
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttribute>? attributes,
    @JsonKey(name: 'AddressType', includeIfNull: false)
    AddressType? addressType,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
    _$AddressImpl _value,
    $Res Function(_$AddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? company = freezed,
    Object? vatNumber = freezed,
    Object? countryId = freezed,
    Object? stateProvinceId = freezed,
    Object? city = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? zipPostalCode = freezed,
    Object? phoneNumber = freezed,
    Object? faxNumber = freezed,
    Object? note = freezed,
    Object? attributes = freezed,
    Object? addressType = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _$AddressImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        firstName:
            freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastName:
            freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        company:
            freezed == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                    as String?,
        vatNumber:
            freezed == vatNumber
                ? _value.vatNumber
                : vatNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        countryId:
            freezed == countryId
                ? _value.countryId
                : countryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        stateProvinceId:
            freezed == stateProvinceId
                ? _value.stateProvinceId
                : stateProvinceId // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        address1:
            freezed == address1
                ? _value.address1
                : address1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        address2:
            freezed == address2
                ? _value.address2
                : address2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        zipPostalCode:
            freezed == zipPostalCode
                ? _value.zipPostalCode
                : zipPostalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        phoneNumber:
            freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        faxNumber:
            freezed == faxNumber
                ? _value.faxNumber
                : faxNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                    as String?,
        attributes:
            freezed == attributes
                ? _value._attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttribute>?,
        addressType:
            freezed == addressType
                ? _value.addressType
                : addressType // ignore: cast_nullable_to_non_nullable
                    as AddressType?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressImpl implements _Address {
  _$AddressImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'FirstName', includeIfNull: false) this.firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) this.lastName,
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'Company', includeIfNull: false) this.company,
    @JsonKey(name: 'VatNumber', includeIfNull: false) this.vatNumber,
    @JsonKey(name: 'CountryId', includeIfNull: false) this.countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    this.stateProvinceId,
    @JsonKey(name: 'City', includeIfNull: false) this.city,
    @JsonKey(name: 'Address1', includeIfNull: false) this.address1,
    @JsonKey(name: 'Address2', includeIfNull: false) this.address2,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) this.zipPostalCode,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) this.phoneNumber,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) this.faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttribute>? attributes = const [],
    @JsonKey(name: 'AddressType', includeIfNull: false)
    this.addressType = AddressType.any,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
  }) : _attributes = attributes;

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'FirstName', includeIfNull: false)
  final String? firstName;
  @override
  @JsonKey(name: 'LastName', includeIfNull: false)
  final String? lastName;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'Company', includeIfNull: false)
  final String? company;
  @override
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  final String? vatNumber;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  final String? countryId;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  final String? stateProvinceId;
  @override
  @JsonKey(name: 'City', includeIfNull: false)
  final String? city;
  @override
  @JsonKey(name: 'Address1', includeIfNull: false)
  final String? address1;
  @override
  @JsonKey(name: 'Address2', includeIfNull: false)
  final String? address2;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  final String? zipPostalCode;
  @override
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  final String? phoneNumber;
  @override
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  final String? faxNumber;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  final String? note;
  final List<CustomAttribute>? _attributes;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttribute>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AddressType', includeIfNull: false)
  final AddressType? addressType;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;

  @override
  String toString() {
    return 'Address(name: $name, firstName: $firstName, lastName: $lastName, email: $email, company: $company, vatNumber: $vatNumber, countryId: $countryId, stateProvinceId: $stateProvinceId, city: $city, address1: $address1, address2: $address2, zipPostalCode: $zipPostalCode, phoneNumber: $phoneNumber, faxNumber: $faxNumber, note: $note, attributes: $attributes, addressType: $addressType, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.stateProvinceId, stateProvinceId) ||
                other.stateProvinceId == stateProvinceId) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.zipPostalCode, zipPostalCode) ||
                other.zipPostalCode == zipPostalCode) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.faxNumber, faxNumber) ||
                other.faxNumber == faxNumber) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ) &&
            (identical(other.addressType, addressType) ||
                other.addressType == addressType) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    firstName,
    lastName,
    email,
    company,
    vatNumber,
    countryId,
    stateProvinceId,
    city,
    address1,
    address2,
    zipPostalCode,
    phoneNumber,
    faxNumber,
    note,
    const DeepCollectionEquality().hash(_attributes),
    addressType,
    id,
  );

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(this);
  }
}

abstract class _Address implements Address {
  factory _Address({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'FirstName', includeIfNull: false) final String? firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) final String? lastName,
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'Company', includeIfNull: false) final String? company,
    @JsonKey(name: 'VatNumber', includeIfNull: false) final String? vatNumber,
    @JsonKey(name: 'CountryId', includeIfNull: false) final String? countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    final String? stateProvinceId,
    @JsonKey(name: 'City', includeIfNull: false) final String? city,
    @JsonKey(name: 'Address1', includeIfNull: false) final String? address1,
    @JsonKey(name: 'Address2', includeIfNull: false) final String? address2,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
    final String? zipPostalCode,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false)
    final String? phoneNumber,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) final String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttribute>? attributes,
    @JsonKey(name: 'AddressType', includeIfNull: false)
    final AddressType? addressType,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
  }) = _$AddressImpl;

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'FirstName', includeIfNull: false)
  String? get firstName;
  @override
  @JsonKey(name: 'LastName', includeIfNull: false)
  String? get lastName;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'Company', includeIfNull: false)
  String? get company;
  @override
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  String? get vatNumber;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId;
  @override
  @JsonKey(name: 'City', includeIfNull: false)
  String? get city;
  @override
  @JsonKey(name: 'Address1', includeIfNull: false)
  String? get address1;
  @override
  @JsonKey(name: 'Address2', includeIfNull: false)
  String? get address2;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode;
  @override
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  String? get phoneNumber;
  @override
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  String? get faxNumber;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttribute>? get attributes;
  @override
  @JsonKey(name: 'AddressType', includeIfNull: false)
  AddressType? get addressType;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
