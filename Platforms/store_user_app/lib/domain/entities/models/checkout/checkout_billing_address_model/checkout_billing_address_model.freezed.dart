// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_billing_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutBillingAddressModel _$CheckoutBillingAddressModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutBillingAddressModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutBillingAddressModel {
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
  AddressModel? get billingNewAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected => throw _privateConstructorUsedError;
  @JsonKey(name: 'BillingAddressId', includeIfNull: false)
  String? get billingAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutBillingAddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutBillingAddressModelCopyWith<CheckoutBillingAddressModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutBillingAddressModelCopyWith<$Res> {
  factory $CheckoutBillingAddressModelCopyWith(
    CheckoutBillingAddressModel value,
    $Res Function(CheckoutBillingAddressModel) then,
  ) =
      _$CheckoutBillingAddressModelCopyWithImpl<
        $Res,
        CheckoutBillingAddressModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
    AddressModel? billingNewAddress,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'BillingAddressId', includeIfNull: false)
    String? billingAddressId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get billingNewAddress;
}

/// @nodoc
class _$CheckoutBillingAddressModelCopyWithImpl<
  $Res,
  $Val extends CheckoutBillingAddressModel
>
    implements $CheckoutBillingAddressModelCopyWith<$Res> {
  _$CheckoutBillingAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? existingAddresses = freezed,
    Object? billingNewAddress = freezed,
    Object? newAddressPreselected = freezed,
    Object? billingAddressId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            existingAddresses:
                freezed == existingAddresses
                    ? _value.existingAddresses
                    : existingAddresses // ignore: cast_nullable_to_non_nullable
                        as List<AddressModel>?,
            billingNewAddress:
                freezed == billingNewAddress
                    ? _value.billingNewAddress
                    : billingNewAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            newAddressPreselected:
                freezed == newAddressPreselected
                    ? _value.newAddressPreselected
                    : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            billingAddressId:
                freezed == billingAddressId
                    ? _value.billingAddressId
                    : billingAddressId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get billingNewAddress {
    if (_value.billingNewAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.billingNewAddress!, (value) {
      return _then(_value.copyWith(billingNewAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutBillingAddressModelImplCopyWith<$Res>
    implements $CheckoutBillingAddressModelCopyWith<$Res> {
  factory _$$CheckoutBillingAddressModelImplCopyWith(
    _$CheckoutBillingAddressModelImpl value,
    $Res Function(_$CheckoutBillingAddressModelImpl) then,
  ) = __$$CheckoutBillingAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
    AddressModel? billingNewAddress,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'BillingAddressId', includeIfNull: false)
    String? billingAddressId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get billingNewAddress;
}

/// @nodoc
class __$$CheckoutBillingAddressModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutBillingAddressModelCopyWithImpl<
          $Res,
          _$CheckoutBillingAddressModelImpl
        >
    implements _$$CheckoutBillingAddressModelImplCopyWith<$Res> {
  __$$CheckoutBillingAddressModelImplCopyWithImpl(
    _$CheckoutBillingAddressModelImpl _value,
    $Res Function(_$CheckoutBillingAddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? existingAddresses = freezed,
    Object? billingNewAddress = freezed,
    Object? newAddressPreselected = freezed,
    Object? billingAddressId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutBillingAddressModelImpl(
        existingAddresses:
            freezed == existingAddresses
                ? _value._existingAddresses
                : existingAddresses // ignore: cast_nullable_to_non_nullable
                    as List<AddressModel>?,
        billingNewAddress:
            freezed == billingNewAddress
                ? _value.billingNewAddress
                : billingNewAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        newAddressPreselected:
            freezed == newAddressPreselected
                ? _value.newAddressPreselected
                : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        billingAddressId:
            freezed == billingAddressId
                ? _value.billingAddressId
                : billingAddressId // ignore: cast_nullable_to_non_nullable
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
class _$CheckoutBillingAddressModelImpl
    implements _CheckoutBillingAddressModel {
  _$CheckoutBillingAddressModelImpl({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses = const [],
    @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
    this.billingNewAddress,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    this.newAddressPreselected = false,
    @JsonKey(name: 'BillingAddressId', includeIfNull: false)
    this.billingAddressId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _existingAddresses = existingAddresses,
       _userFields = userFields;

  factory _$CheckoutBillingAddressModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutBillingAddressModelImplFromJson(json);

  final List<AddressModel>? _existingAddresses;
  @override
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses {
    final value = _existingAddresses;
    if (value == null) return null;
    if (_existingAddresses is EqualUnmodifiableListView)
      return _existingAddresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
  final AddressModel? billingNewAddress;
  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  final bool? newAddressPreselected;
  @override
  @JsonKey(name: 'BillingAddressId', includeIfNull: false)
  final String? billingAddressId;
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
    return 'CheckoutBillingAddressModel(existingAddresses: $existingAddresses, billingNewAddress: $billingNewAddress, newAddressPreselected: $newAddressPreselected, billingAddressId: $billingAddressId, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutBillingAddressModelImpl &&
            const DeepCollectionEquality().equals(
              other._existingAddresses,
              _existingAddresses,
            ) &&
            (identical(other.billingNewAddress, billingNewAddress) ||
                other.billingNewAddress == billingNewAddress) &&
            (identical(other.newAddressPreselected, newAddressPreselected) ||
                other.newAddressPreselected == newAddressPreselected) &&
            (identical(other.billingAddressId, billingAddressId) ||
                other.billingAddressId == billingAddressId) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_existingAddresses),
    billingNewAddress,
    newAddressPreselected,
    billingAddressId,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutBillingAddressModelImplCopyWith<_$CheckoutBillingAddressModelImpl>
  get copyWith => __$$CheckoutBillingAddressModelImplCopyWithImpl<
    _$CheckoutBillingAddressModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutBillingAddressModelImplToJson(this);
  }
}

abstract class _CheckoutBillingAddressModel
    implements CheckoutBillingAddressModel {
  factory _CheckoutBillingAddressModel({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses,
    @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
    final AddressModel? billingNewAddress,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    final bool? newAddressPreselected,
    @JsonKey(name: 'BillingAddressId', includeIfNull: false)
    final String? billingAddressId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutBillingAddressModelImpl;

  factory _CheckoutBillingAddressModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutBillingAddressModelImpl.fromJson;

  @override
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses;
  @override
  @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
  AddressModel? get billingNewAddress;
  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected;
  @override
  @JsonKey(name: 'BillingAddressId', includeIfNull: false)
  String? get billingAddressId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutBillingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutBillingAddressModelImplCopyWith<_$CheckoutBillingAddressModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
