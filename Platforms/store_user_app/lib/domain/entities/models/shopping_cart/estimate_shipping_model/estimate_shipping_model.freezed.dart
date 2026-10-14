// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estimate_shipping_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EstimateShippingModel _$EstimateShippingModelFromJson(
  Map<String, dynamic> json,
) {
  return _EstimateShippingModel.fromJson(json);
}

/// @nodoc
mixin _$EstimateShippingModel {
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableCountries', includeIfNull: false)
  List<SelectListItem>? get availableCountries =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableStates', includeIfNull: false)
  List<SelectListItem>? get availableStates =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this EstimateShippingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EstimateShippingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstimateShippingModelCopyWith<EstimateShippingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstimateShippingModelCopyWith<$Res> {
  factory $EstimateShippingModelCopyWith(
    EstimateShippingModel value,
    $Res Function(EstimateShippingModel) then,
  ) = _$EstimateShippingModelCopyWithImpl<$Res, EstimateShippingModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    String? stateProvinceId,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    List<SelectListItem>? availableStates,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$EstimateShippingModelCopyWithImpl<
  $Res,
  $Val extends EstimateShippingModel
>
    implements $EstimateShippingModelCopyWith<$Res> {
  _$EstimateShippingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstimateShippingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? countryId = freezed,
    Object? stateProvinceId = freezed,
    Object? zipPostalCode = freezed,
    Object? availableCountries = freezed,
    Object? availableStates = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            enabled:
                freezed == enabled
                    ? _value.enabled
                    : enabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
            zipPostalCode:
                freezed == zipPostalCode
                    ? _value.zipPostalCode
                    : zipPostalCode // ignore: cast_nullable_to_non_nullable
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
abstract class _$$EstimateShippingModelImplCopyWith<$Res>
    implements $EstimateShippingModelCopyWith<$Res> {
  factory _$$EstimateShippingModelImplCopyWith(
    _$EstimateShippingModelImpl value,
    $Res Function(_$EstimateShippingModelImpl) then,
  ) = __$$EstimateShippingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    String? stateProvinceId,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) String? zipPostalCode,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    List<SelectListItem>? availableStates,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$EstimateShippingModelImplCopyWithImpl<$Res>
    extends
        _$EstimateShippingModelCopyWithImpl<$Res, _$EstimateShippingModelImpl>
    implements _$$EstimateShippingModelImplCopyWith<$Res> {
  __$$EstimateShippingModelImplCopyWithImpl(
    _$EstimateShippingModelImpl _value,
    $Res Function(_$EstimateShippingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EstimateShippingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? countryId = freezed,
    Object? stateProvinceId = freezed,
    Object? zipPostalCode = freezed,
    Object? availableCountries = freezed,
    Object? availableStates = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$EstimateShippingModelImpl(
        enabled:
            freezed == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
        zipPostalCode:
            freezed == zipPostalCode
                ? _value.zipPostalCode
                : zipPostalCode // ignore: cast_nullable_to_non_nullable
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
class _$EstimateShippingModelImpl implements _EstimateShippingModel {
  _$EstimateShippingModelImpl({
    @JsonKey(name: 'Enabled', includeIfNull: false) this.enabled = false,
    @JsonKey(name: 'CountryId', includeIfNull: false) this.countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    this.stateProvinceId,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false) this.zipPostalCode,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    final List<SelectListItem>? availableCountries = const [],
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    final List<SelectListItem>? availableStates = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _availableCountries = availableCountries,
       _availableStates = availableStates,
       _userFields = userFields;

  factory _$EstimateShippingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstimateShippingModelImplFromJson(json);

  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  final bool? enabled;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  final String? countryId;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  final String? stateProvinceId;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  final String? zipPostalCode;
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
    return 'EstimateShippingModel(enabled: $enabled, countryId: $countryId, stateProvinceId: $stateProvinceId, zipPostalCode: $zipPostalCode, availableCountries: $availableCountries, availableStates: $availableStates, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstimateShippingModelImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.stateProvinceId, stateProvinceId) ||
                other.stateProvinceId == stateProvinceId) &&
            (identical(other.zipPostalCode, zipPostalCode) ||
                other.zipPostalCode == zipPostalCode) &&
            const DeepCollectionEquality().equals(
              other._availableCountries,
              _availableCountries,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableStates,
              _availableStates,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    enabled,
    countryId,
    stateProvinceId,
    zipPostalCode,
    const DeepCollectionEquality().hash(_availableCountries),
    const DeepCollectionEquality().hash(_availableStates),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of EstimateShippingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstimateShippingModelImplCopyWith<_$EstimateShippingModelImpl>
  get copyWith =>
      __$$EstimateShippingModelImplCopyWithImpl<_$EstimateShippingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EstimateShippingModelImplToJson(this);
  }
}

abstract class _EstimateShippingModel implements EstimateShippingModel {
  factory _EstimateShippingModel({
    @JsonKey(name: 'Enabled', includeIfNull: false) final bool? enabled,
    @JsonKey(name: 'CountryId', includeIfNull: false) final String? countryId,
    @JsonKey(name: 'StateProvinceId', includeIfNull: false)
    final String? stateProvinceId,
    @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
    final String? zipPostalCode,
    @JsonKey(name: 'AvailableCountries', includeIfNull: false)
    final List<SelectListItem>? availableCountries,
    @JsonKey(name: 'AvailableStates', includeIfNull: false)
    final List<SelectListItem>? availableStates,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$EstimateShippingModelImpl;

  factory _EstimateShippingModel.fromJson(Map<String, dynamic> json) =
      _$EstimateShippingModelImpl.fromJson;

  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled;
  @override
  @JsonKey(name: 'CountryId', includeIfNull: false)
  String? get countryId;
  @override
  @JsonKey(name: 'StateProvinceId', includeIfNull: false)
  String? get stateProvinceId;
  @override
  @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
  String? get zipPostalCode;
  @override
  @JsonKey(name: 'AvailableCountries', includeIfNull: false)
  List<SelectListItem>? get availableCountries;
  @override
  @JsonKey(name: 'AvailableStates', includeIfNull: false)
  List<SelectListItem>? get availableStates;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of EstimateShippingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstimateShippingModelImplCopyWith<_$EstimateShippingModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
