// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorAddressModel _$VendorAddressModelFromJson(Map<String, dynamic> json) {
  return _VendorAddressModel.fromJson(json);
}

/// @nodoc
mixin _$VendorAddressModel {
  @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
  bool? get companyEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'CompanyRequired', includeIfNull: false)
  bool? get companyRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'Company', includeIfNull: false)
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'CountryEnabled', includeIfNull: false)
  bool? get countryEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CountryName', includeIfNull: false)
  String? get countryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
  bool? get stateProvinceEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateProvinceName', includeIfNull: false)
  String? get stateProvinceName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CityEnabled', includeIfNull: false)
  bool? get cityEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'CityRequired', includeIfNull: false)
  bool? get cityRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'City', includeIfNull: false)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
  bool? get streetAddressEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
  bool? get streetAddressRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address1', includeIfNull: false)
  String? get address1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
  bool? get streetAddress2Enabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
  bool? get streetAddress2Required => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address2', includeIfNull: false)
  String? get address2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
  bool? get zipPostalCodeEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
  bool? get zipPostalCodeRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
  bool? get phoneEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'PhoneRequired', includeIfNull: false)
  bool? get phoneRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'FaxEnabled', includeIfNull: false)
  bool? get faxEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'FaxRequired', includeIfNull: false)
  bool? get faxRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  String? get faxNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableCountries', includeIfNull: false)
  List<SelectListItem>? get availableCountries =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableStates', includeIfNull: false)
  List<SelectListItem>? get availableStates =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorAddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorAddressModelCopyWith<VendorAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorAddressModelCopyWith<$Res> {
  factory $VendorAddressModelCopyWith(
    VendorAddressModel value,
    $Res Function(VendorAddressModel) then,
  ) = _$VendorAddressModelCopyWithImpl<$Res, VendorAddressModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CompanyEnabled', includeIfNull: false) bool? companyEnabled,
    @JsonKey(name: 'CompanyRequired', includeIfNull: false)
    bool? companyRequired,
    @JsonKey(name: 'Company', includeIfNull: false) String? company,
    @JsonKey(name: 'CountryEnabled', includeIfNull: false) bool? countryEnabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
    @JsonKey(name: 'CountryName', includeIfNull: false) String? countryName,
    @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
    bool? stateProvinceEnabled,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    String? stateProvinceId,
    @JsonKey(name: 'StateProvinceName', includeIfNull: false)
    String? stateProvinceName,
    @JsonKey(name: 'CityEnabled', includeIfNull: false) bool? cityEnabled,
    @JsonKey(name: 'CityRequired', includeIfNull: false) bool? cityRequired,
    @JsonKey(name: 'City', includeIfNull: false) String? city,
    @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
    bool? streetAddressEnabled,
    @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
    bool? streetAddressRequired,
    @JsonKey(name: 'Address1', includeIfNull: false) String? address1,
    @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
    bool? streetAddress2Enabled,
    @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
    bool? streetAddress2Required,
    @JsonKey(name: 'Address2', includeIfNull: false) String? address2,
    @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
    bool? zipPostalCodeEnabled,
    @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
    bool? zipPostalCodeRequired,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'PhoneEnabled', includeIfNull: false) bool? phoneEnabled,
    @JsonKey(name: 'PhoneRequired', includeIfNull: false) bool? phoneRequired,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
    @JsonKey(name: 'FaxEnabled', includeIfNull: false) bool? faxEnabled,
    @JsonKey(name: 'FaxRequired', includeIfNull: false) bool? faxRequired,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    List<SelectListItem>? availableStates,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$VendorAddressModelCopyWithImpl<$Res, $Val extends VendorAddressModel>
    implements $VendorAddressModelCopyWith<$Res> {
  _$VendorAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyEnabled = freezed,
    Object? companyRequired = freezed,
    Object? company = freezed,
    Object? countryEnabled = freezed,
    Object? countryId = freezed,
    Object? countryName = freezed,
    Object? stateProvinceEnabled = freezed,
    Object? stateProvinceId = freezed,
    Object? stateProvinceName = freezed,
    Object? cityEnabled = freezed,
    Object? cityRequired = freezed,
    Object? city = freezed,
    Object? streetAddressEnabled = freezed,
    Object? streetAddressRequired = freezed,
    Object? address1 = freezed,
    Object? streetAddress2Enabled = freezed,
    Object? streetAddress2Required = freezed,
    Object? address2 = freezed,
    Object? zipPostalCodeEnabled = freezed,
    Object? zipPostalCodeRequired = freezed,
    Object? zipPostalCode = freezed,
    Object? phoneEnabled = freezed,
    Object? phoneRequired = freezed,
    Object? phoneNumber = freezed,
    Object? faxEnabled = freezed,
    Object? faxRequired = freezed,
    Object? faxNumber = freezed,
    Object? note = freezed,
    Object? availableCountries = freezed,
    Object? availableStates = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            companyEnabled:
                freezed == companyEnabled
                    ? _value.companyEnabled
                    : companyEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            companyRequired:
                freezed == companyRequired
                    ? _value.companyRequired
                    : companyRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            company:
                freezed == company
                    ? _value.company
                    : company // ignore: cast_nullable_to_non_nullable
                        as String?,
            countryEnabled:
                freezed == countryEnabled
                    ? _value.countryEnabled
                    : countryEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            countryId:
                freezed == countryId
                    ? _value.countryId
                    : countryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            countryName:
                freezed == countryName
                    ? _value.countryName
                    : countryName // ignore: cast_nullable_to_non_nullable
                        as String?,
            stateProvinceEnabled:
                freezed == stateProvinceEnabled
                    ? _value.stateProvinceEnabled
                    : stateProvinceEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            stateProvinceId:
                freezed == stateProvinceId
                    ? _value.stateProvinceId
                    : stateProvinceId // ignore: cast_nullable_to_non_nullable
                        as String?,
            stateProvinceName:
                freezed == stateProvinceName
                    ? _value.stateProvinceName
                    : stateProvinceName // ignore: cast_nullable_to_non_nullable
                        as String?,
            cityEnabled:
                freezed == cityEnabled
                    ? _value.cityEnabled
                    : cityEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            cityRequired:
                freezed == cityRequired
                    ? _value.cityRequired
                    : cityRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            streetAddressEnabled:
                freezed == streetAddressEnabled
                    ? _value.streetAddressEnabled
                    : streetAddressEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            streetAddressRequired:
                freezed == streetAddressRequired
                    ? _value.streetAddressRequired
                    : streetAddressRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            address1:
                freezed == address1
                    ? _value.address1
                    : address1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            streetAddress2Enabled:
                freezed == streetAddress2Enabled
                    ? _value.streetAddress2Enabled
                    : streetAddress2Enabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            streetAddress2Required:
                freezed == streetAddress2Required
                    ? _value.streetAddress2Required
                    : streetAddress2Required // ignore: cast_nullable_to_non_nullable
                        as bool?,
            address2:
                freezed == address2
                    ? _value.address2
                    : address2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            zipPostalCodeEnabled:
                freezed == zipPostalCodeEnabled
                    ? _value.zipPostalCodeEnabled
                    : zipPostalCodeEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            zipPostalCodeRequired:
                freezed == zipPostalCodeRequired
                    ? _value.zipPostalCodeRequired
                    : zipPostalCodeRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            zipPostalCode:
                freezed == zipPostalCode
                    ? _value.zipPostalCode
                    : zipPostalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            phoneEnabled:
                freezed == phoneEnabled
                    ? _value.phoneEnabled
                    : phoneEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            phoneRequired:
                freezed == phoneRequired
                    ? _value.phoneRequired
                    : phoneRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            phoneNumber:
                freezed == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            faxEnabled:
                freezed == faxEnabled
                    ? _value.faxEnabled
                    : faxEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            faxRequired:
                freezed == faxRequired
                    ? _value.faxRequired
                    : faxRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
            availableCountries:
                freezed == availableCountries
                    ? _value.availableCountries
                    : availableCountries // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            availableStates:
                freezed == availableStates
                    ? _value.availableStates
                    : availableStates // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VendorAddressModelImplCopyWith<$Res>
    implements $VendorAddressModelCopyWith<$Res> {
  factory _$$VendorAddressModelImplCopyWith(
    _$VendorAddressModelImpl value,
    $Res Function(_$VendorAddressModelImpl) then,
  ) = __$$VendorAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CompanyEnabled', includeIfNull: false) bool? companyEnabled,
    @JsonKey(name: 'CompanyRequired', includeIfNull: false)
    bool? companyRequired,
    @JsonKey(name: 'Company', includeIfNull: false) String? company,
    @JsonKey(name: 'CountryEnabled', includeIfNull: false) bool? countryEnabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
    @JsonKey(name: 'CountryName', includeIfNull: false) String? countryName,
    @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
    bool? stateProvinceEnabled,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    String? stateProvinceId,
    @JsonKey(name: 'StateProvinceName', includeIfNull: false)
    String? stateProvinceName,
    @JsonKey(name: 'CityEnabled', includeIfNull: false) bool? cityEnabled,
    @JsonKey(name: 'CityRequired', includeIfNull: false) bool? cityRequired,
    @JsonKey(name: 'City', includeIfNull: false) String? city,
    @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
    bool? streetAddressEnabled,
    @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
    bool? streetAddressRequired,
    @JsonKey(name: 'Address1', includeIfNull: false) String? address1,
    @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
    bool? streetAddress2Enabled,
    @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
    bool? streetAddress2Required,
    @JsonKey(name: 'Address2', includeIfNull: false) String? address2,
    @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
    bool? zipPostalCodeEnabled,
    @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
    bool? zipPostalCodeRequired,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'PhoneEnabled', includeIfNull: false) bool? phoneEnabled,
    @JsonKey(name: 'PhoneRequired', includeIfNull: false) bool? phoneRequired,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) String? phoneNumber,
    @JsonKey(name: 'FaxEnabled', includeIfNull: false) bool? faxEnabled,
    @JsonKey(name: 'FaxRequired', includeIfNull: false) bool? faxRequired,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    List<SelectListItem>? availableStates,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$VendorAddressModelImplCopyWithImpl<$Res>
    extends _$VendorAddressModelCopyWithImpl<$Res, _$VendorAddressModelImpl>
    implements _$$VendorAddressModelImplCopyWith<$Res> {
  __$$VendorAddressModelImplCopyWithImpl(
    _$VendorAddressModelImpl _value,
    $Res Function(_$VendorAddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyEnabled = freezed,
    Object? companyRequired = freezed,
    Object? company = freezed,
    Object? countryEnabled = freezed,
    Object? countryId = freezed,
    Object? countryName = freezed,
    Object? stateProvinceEnabled = freezed,
    Object? stateProvinceId = freezed,
    Object? stateProvinceName = freezed,
    Object? cityEnabled = freezed,
    Object? cityRequired = freezed,
    Object? city = freezed,
    Object? streetAddressEnabled = freezed,
    Object? streetAddressRequired = freezed,
    Object? address1 = freezed,
    Object? streetAddress2Enabled = freezed,
    Object? streetAddress2Required = freezed,
    Object? address2 = freezed,
    Object? zipPostalCodeEnabled = freezed,
    Object? zipPostalCodeRequired = freezed,
    Object? zipPostalCode = freezed,
    Object? phoneEnabled = freezed,
    Object? phoneRequired = freezed,
    Object? phoneNumber = freezed,
    Object? faxEnabled = freezed,
    Object? faxRequired = freezed,
    Object? faxNumber = freezed,
    Object? note = freezed,
    Object? availableCountries = freezed,
    Object? availableStates = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorAddressModelImpl(
        companyEnabled:
            freezed == companyEnabled
                ? _value.companyEnabled
                : companyEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        companyRequired:
            freezed == companyRequired
                ? _value.companyRequired
                : companyRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        company:
            freezed == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                    as String?,
        countryEnabled:
            freezed == countryEnabled
                ? _value.countryEnabled
                : countryEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        countryId:
            freezed == countryId
                ? _value.countryId
                : countryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        countryName:
            freezed == countryName
                ? _value.countryName
                : countryName // ignore: cast_nullable_to_non_nullable
                    as String?,
        stateProvinceEnabled:
            freezed == stateProvinceEnabled
                ? _value.stateProvinceEnabled
                : stateProvinceEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        stateProvinceId:
            freezed == stateProvinceId
                ? _value.stateProvinceId
                : stateProvinceId // ignore: cast_nullable_to_non_nullable
                    as String?,
        stateProvinceName:
            freezed == stateProvinceName
                ? _value.stateProvinceName
                : stateProvinceName // ignore: cast_nullable_to_non_nullable
                    as String?,
        cityEnabled:
            freezed == cityEnabled
                ? _value.cityEnabled
                : cityEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        cityRequired:
            freezed == cityRequired
                ? _value.cityRequired
                : cityRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        streetAddressEnabled:
            freezed == streetAddressEnabled
                ? _value.streetAddressEnabled
                : streetAddressEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        streetAddressRequired:
            freezed == streetAddressRequired
                ? _value.streetAddressRequired
                : streetAddressRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        address1:
            freezed == address1
                ? _value.address1
                : address1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        streetAddress2Enabled:
            freezed == streetAddress2Enabled
                ? _value.streetAddress2Enabled
                : streetAddress2Enabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        streetAddress2Required:
            freezed == streetAddress2Required
                ? _value.streetAddress2Required
                : streetAddress2Required // ignore: cast_nullable_to_non_nullable
                    as bool?,
        address2:
            freezed == address2
                ? _value.address2
                : address2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        zipPostalCodeEnabled:
            freezed == zipPostalCodeEnabled
                ? _value.zipPostalCodeEnabled
                : zipPostalCodeEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        zipPostalCodeRequired:
            freezed == zipPostalCodeRequired
                ? _value.zipPostalCodeRequired
                : zipPostalCodeRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        zipPostalCode:
            freezed == zipPostalCode
                ? _value.zipPostalCode
                : zipPostalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        phoneEnabled:
            freezed == phoneEnabled
                ? _value.phoneEnabled
                : phoneEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        phoneRequired:
            freezed == phoneRequired
                ? _value.phoneRequired
                : phoneRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        phoneNumber:
            freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        faxEnabled:
            freezed == faxEnabled
                ? _value.faxEnabled
                : faxEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        faxRequired:
            freezed == faxRequired
                ? _value.faxRequired
                : faxRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
        availableCountries:
            freezed == availableCountries
                ? _value._availableCountries
                : availableCountries // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        availableStates:
            freezed == availableStates
                ? _value._availableStates
                : availableStates // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorAddressModelImpl implements _VendorAddressModel {
  _$VendorAddressModelImpl({
    @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
    this.companyEnabled = false,
    @JsonKey(name: 'CompanyRequired', includeIfNull: false)
    this.companyRequired = false,
    @JsonKey(name: 'Company', includeIfNull: false) this.company,
    @JsonKey(name: 'CountryEnabled', includeIfNull: false)
    this.countryEnabled = false,
    @JsonKey(name: 'CountryId', includeIfNull: false) this.countryId,
    @JsonKey(name: 'CountryName', includeIfNull: false) this.countryName,
    @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
    this.stateProvinceEnabled = false,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    this.stateProvinceId,
    @JsonKey(name: 'StateProvinceName', includeIfNull: false)
    this.stateProvinceName,
    @JsonKey(name: 'CityEnabled', includeIfNull: false)
    this.cityEnabled = false,
    @JsonKey(name: 'CityRequired', includeIfNull: false)
    this.cityRequired = false,
    @JsonKey(name: 'City', includeIfNull: false) this.city,
    @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
    this.streetAddressEnabled = false,
    @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
    this.streetAddressRequired = false,
    @JsonKey(name: 'Address1', includeIfNull: false) this.address1,
    @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
    this.streetAddress2Enabled = false,
    @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
    this.streetAddress2Required = false,
    @JsonKey(name: 'Address2', includeIfNull: false) this.address2,
    @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
    this.zipPostalCodeEnabled = false,
    @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
    this.zipPostalCodeRequired = false,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) this.zipPostalCode,
    @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
    this.phoneEnabled = false,
    @JsonKey(name: 'PhoneRequired', includeIfNull: false)
    this.phoneRequired = false,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false) this.phoneNumber,
    @JsonKey(name: 'FaxEnabled', includeIfNull: false) this.faxEnabled = false,
    @JsonKey(name: 'FaxRequired', includeIfNull: false)
    this.faxRequired = false,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) this.faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    final List<SelectListItem>? availableCountries = const [],
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    final List<SelectListItem>? availableStates = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _availableCountries = availableCountries,
       _availableStates = availableStates,
       _userFields = userFields;

  factory _$VendorAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorAddressModelImplFromJson(json);

  @override
  @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
  final bool? companyEnabled;
  @override
  @JsonKey(name: 'CompanyRequired', includeIfNull: false)
  final bool? companyRequired;
  @override
  @JsonKey(name: 'Company', includeIfNull: false)
  final String? company;
  @override
  @JsonKey(name: 'CountryEnabled', includeIfNull: false)
  final bool? countryEnabled;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  final String? countryId;
  @override
  @JsonKey(name: 'CountryName', includeIfNull: false)
  final String? countryName;
  @override
  @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
  final bool? stateProvinceEnabled;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  final String? stateProvinceId;
  @override
  @JsonKey(name: 'StateProvinceName', includeIfNull: false)
  final String? stateProvinceName;
  @override
  @JsonKey(name: 'CityEnabled', includeIfNull: false)
  final bool? cityEnabled;
  @override
  @JsonKey(name: 'CityRequired', includeIfNull: false)
  final bool? cityRequired;
  @override
  @JsonKey(name: 'City', includeIfNull: false)
  final String? city;
  @override
  @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
  final bool? streetAddressEnabled;
  @override
  @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
  final bool? streetAddressRequired;
  @override
  @JsonKey(name: 'Address1', includeIfNull: false)
  final String? address1;
  @override
  @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
  final bool? streetAddress2Enabled;
  @override
  @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
  final bool? streetAddress2Required;
  @override
  @JsonKey(name: 'Address2', includeIfNull: false)
  final String? address2;
  @override
  @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
  final bool? zipPostalCodeEnabled;
  @override
  @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
  final bool? zipPostalCodeRequired;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  final String? zipPostalCode;
  @override
  @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
  final bool? phoneEnabled;
  @override
  @JsonKey(name: 'PhoneRequired', includeIfNull: false)
  final bool? phoneRequired;
  @override
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  final String? phoneNumber;
  @override
  @JsonKey(name: 'FaxEnabled', includeIfNull: false)
  final bool? faxEnabled;
  @override
  @JsonKey(name: 'FaxRequired', includeIfNull: false)
  final bool? faxRequired;
  @override
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  final String? faxNumber;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  final String? note;
  final List<SelectListItem>? _availableCountries;
  @override
  @JsonKey(name: 'AvailableCountries', includeIfNull: false)
  List<SelectListItem>? get availableCountries {
    final value = _availableCountries;
    if (value == null) return null;
    if (_availableCountries is EqualUnmodifiableListView)
      return _availableCountries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectListItem>? _availableStates;
  @override
  @JsonKey(name: 'AvailableStates', includeIfNull: false)
  List<SelectListItem>? get availableStates {
    final value = _availableStates;
    if (value == null) return null;
    if (_availableStates is EqualUnmodifiableListView) return _availableStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VendorAddressModel(companyEnabled: $companyEnabled, companyRequired: $companyRequired, company: $company, countryEnabled: $countryEnabled, countryId: $countryId, countryName: $countryName, stateProvinceEnabled: $stateProvinceEnabled, stateProvinceId: $stateProvinceId, stateProvinceName: $stateProvinceName, cityEnabled: $cityEnabled, cityRequired: $cityRequired, city: $city, streetAddressEnabled: $streetAddressEnabled, streetAddressRequired: $streetAddressRequired, address1: $address1, streetAddress2Enabled: $streetAddress2Enabled, streetAddress2Required: $streetAddress2Required, address2: $address2, zipPostalCodeEnabled: $zipPostalCodeEnabled, zipPostalCodeRequired: $zipPostalCodeRequired, zipPostalCode: $zipPostalCode, phoneEnabled: $phoneEnabled, phoneRequired: $phoneRequired, phoneNumber: $phoneNumber, faxEnabled: $faxEnabled, faxRequired: $faxRequired, faxNumber: $faxNumber, note: $note, availableCountries: $availableCountries, availableStates: $availableStates, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorAddressModelImpl &&
            (identical(other.companyEnabled, companyEnabled) ||
                other.companyEnabled == companyEnabled) &&
            (identical(other.companyRequired, companyRequired) ||
                other.companyRequired == companyRequired) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.countryEnabled, countryEnabled) ||
                other.countryEnabled == countryEnabled) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.stateProvinceEnabled, stateProvinceEnabled) ||
                other.stateProvinceEnabled == stateProvinceEnabled) &&
            (identical(other.stateProvinceId, stateProvinceId) ||
                other.stateProvinceId == stateProvinceId) &&
            (identical(other.stateProvinceName, stateProvinceName) ||
                other.stateProvinceName == stateProvinceName) &&
            (identical(other.cityEnabled, cityEnabled) ||
                other.cityEnabled == cityEnabled) &&
            (identical(other.cityRequired, cityRequired) ||
                other.cityRequired == cityRequired) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.streetAddressEnabled, streetAddressEnabled) ||
                other.streetAddressEnabled == streetAddressEnabled) &&
            (identical(other.streetAddressRequired, streetAddressRequired) ||
                other.streetAddressRequired == streetAddressRequired) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.streetAddress2Enabled, streetAddress2Enabled) ||
                other.streetAddress2Enabled == streetAddress2Enabled) &&
            (identical(other.streetAddress2Required, streetAddress2Required) ||
                other.streetAddress2Required == streetAddress2Required) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.zipPostalCodeEnabled, zipPostalCodeEnabled) ||
                other.zipPostalCodeEnabled == zipPostalCodeEnabled) &&
            (identical(other.zipPostalCodeRequired, zipPostalCodeRequired) ||
                other.zipPostalCodeRequired == zipPostalCodeRequired) &&
            (identical(other.zipPostalCode, zipPostalCode) ||
                other.zipPostalCode == zipPostalCode) &&
            (identical(other.phoneEnabled, phoneEnabled) ||
                other.phoneEnabled == phoneEnabled) &&
            (identical(other.phoneRequired, phoneRequired) ||
                other.phoneRequired == phoneRequired) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.faxEnabled, faxEnabled) ||
                other.faxEnabled == faxEnabled) &&
            (identical(other.faxRequired, faxRequired) ||
                other.faxRequired == faxRequired) &&
            (identical(other.faxNumber, faxNumber) ||
                other.faxNumber == faxNumber) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(
              other._availableCountries,
              _availableCountries,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableStates,
              _availableStates,
            ) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    companyEnabled,
    companyRequired,
    company,
    countryEnabled,
    countryId,
    countryName,
    stateProvinceEnabled,
    stateProvinceId,
    stateProvinceName,
    cityEnabled,
    cityRequired,
    city,
    streetAddressEnabled,
    streetAddressRequired,
    address1,
    streetAddress2Enabled,
    streetAddress2Required,
    address2,
    zipPostalCodeEnabled,
    zipPostalCodeRequired,
    zipPostalCode,
    phoneEnabled,
    phoneRequired,
    phoneNumber,
    faxEnabled,
    faxRequired,
    faxNumber,
    note,
    const DeepCollectionEquality().hash(_availableCountries),
    const DeepCollectionEquality().hash(_availableStates),
    id,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of VendorAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorAddressModelImplCopyWith<_$VendorAddressModelImpl> get copyWith =>
      __$$VendorAddressModelImplCopyWithImpl<_$VendorAddressModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorAddressModelImplToJson(this);
  }
}

abstract class _VendorAddressModel implements VendorAddressModel {
  factory _VendorAddressModel({
    @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
    final bool? companyEnabled,
    @JsonKey(name: 'CompanyRequired', includeIfNull: false)
    final bool? companyRequired,
    @JsonKey(name: 'Company', includeIfNull: false) final String? company,
    @JsonKey(name: 'CountryEnabled', includeIfNull: false)
    final bool? countryEnabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) final String? countryId,
    @JsonKey(name: 'CountryName', includeIfNull: false)
    final String? countryName,
    @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
    final bool? stateProvinceEnabled,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    final String? stateProvinceId,
    @JsonKey(name: 'StateProvinceName', includeIfNull: false)
    final String? stateProvinceName,
    @JsonKey(name: 'CityEnabled', includeIfNull: false) final bool? cityEnabled,
    @JsonKey(name: 'CityRequired', includeIfNull: false)
    final bool? cityRequired,
    @JsonKey(name: 'City', includeIfNull: false) final String? city,
    @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
    final bool? streetAddressEnabled,
    @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
    final bool? streetAddressRequired,
    @JsonKey(name: 'Address1', includeIfNull: false) final String? address1,
    @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
    final bool? streetAddress2Enabled,
    @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
    final bool? streetAddress2Required,
    @JsonKey(name: 'Address2', includeIfNull: false) final String? address2,
    @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
    final bool? zipPostalCodeEnabled,
    @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
    final bool? zipPostalCodeRequired,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
    final String? zipPostalCode,
    @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
    final bool? phoneEnabled,
    @JsonKey(name: 'PhoneRequired', includeIfNull: false)
    final bool? phoneRequired,
    @JsonKey(name: 'PhoneNumber', includeIfNull: false)
    final String? phoneNumber,
    @JsonKey(name: 'FaxEnabled', includeIfNull: false) final bool? faxEnabled,
    @JsonKey(name: 'FaxRequired', includeIfNull: false) final bool? faxRequired,
    @JsonKey(name: 'FaxNumber', includeIfNull: false) final String? faxNumber,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    final List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    final List<SelectListItem>? availableStates,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorAddressModelImpl;

  factory _VendorAddressModel.fromJson(Map<String, dynamic> json) =
      _$VendorAddressModelImpl.fromJson;

  @override
  @JsonKey(name: 'CompanyEnabled', includeIfNull: false)
  bool? get companyEnabled;
  @override
  @JsonKey(name: 'CompanyRequired', includeIfNull: false)
  bool? get companyRequired;
  @override
  @JsonKey(name: 'Company', includeIfNull: false)
  String? get company;
  @override
  @JsonKey(name: 'CountryEnabled', includeIfNull: false)
  bool? get countryEnabled;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId;
  @override
  @JsonKey(name: 'CountryName', includeIfNull: false)
  String? get countryName;
  @override
  @JsonKey(name: 'StateProvinceEnabled', includeIfNull: false)
  bool? get stateProvinceEnabled;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId;
  @override
  @JsonKey(name: 'StateProvinceName', includeIfNull: false)
  String? get stateProvinceName;
  @override
  @JsonKey(name: 'CityEnabled', includeIfNull: false)
  bool? get cityEnabled;
  @override
  @JsonKey(name: 'CityRequired', includeIfNull: false)
  bool? get cityRequired;
  @override
  @JsonKey(name: 'City', includeIfNull: false)
  String? get city;
  @override
  @JsonKey(name: 'StreetAddressEnabled', includeIfNull: false)
  bool? get streetAddressEnabled;
  @override
  @JsonKey(name: 'StreetAddressRequired', includeIfNull: false)
  bool? get streetAddressRequired;
  @override
  @JsonKey(name: 'Address1', includeIfNull: false)
  String? get address1;
  @override
  @JsonKey(name: 'StreetAddress2Enabled', includeIfNull: false)
  bool? get streetAddress2Enabled;
  @override
  @JsonKey(name: 'StreetAddress2Required', includeIfNull: false)
  bool? get streetAddress2Required;
  @override
  @JsonKey(name: 'Address2', includeIfNull: false)
  String? get address2;
  @override
  @JsonKey(name: 'ZipPostalCodeEnabled', includeIfNull: false)
  bool? get zipPostalCodeEnabled;
  @override
  @JsonKey(name: 'ZipPostalCodeRequired', includeIfNull: false)
  bool? get zipPostalCodeRequired;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode;
  @override
  @JsonKey(name: 'PhoneEnabled', includeIfNull: false)
  bool? get phoneEnabled;
  @override
  @JsonKey(name: 'PhoneRequired', includeIfNull: false)
  bool? get phoneRequired;
  @override
  @JsonKey(name: 'PhoneNumber', includeIfNull: false)
  String? get phoneNumber;
  @override
  @JsonKey(name: 'FaxEnabled', includeIfNull: false)
  bool? get faxEnabled;
  @override
  @JsonKey(name: 'FaxRequired', includeIfNull: false)
  bool? get faxRequired;
  @override
  @JsonKey(name: 'FaxNumber', includeIfNull: false)
  String? get faxNumber;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note;
  @override
  @JsonKey(name: 'AvailableCountries', includeIfNull: false)
  List<SelectListItem>? get availableCountries;
  @override
  @JsonKey(name: 'AvailableStates', includeIfNull: false)
  List<SelectListItem>? get availableStates;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorAddressModelImplCopyWith<_$VendorAddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
