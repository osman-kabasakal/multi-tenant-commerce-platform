// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_shipping_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutShippingAddressModel _$CheckoutShippingAddressModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutShippingAddressModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutShippingAddressModel {
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
  AddressModel? get shippingNewAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
  String? get shippingAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupPointId', includeIfNull: false)
  String? get pickupPointId => throw _privateConstructorUsedError;
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupPoints', includeIfNull: false)
  List<CheckoutPickupPointModel>? get pickupPoints =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
  bool? get billToTheSameAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
  bool? get allowPickUpInStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
  bool? get pickUpInStoreOnly => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutShippingAddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutShippingAddressModelCopyWith<CheckoutShippingAddressModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutShippingAddressModelCopyWith<$Res> {
  factory $CheckoutShippingAddressModelCopyWith(
    CheckoutShippingAddressModel value,
    $Res Function(CheckoutShippingAddressModel) then,
  ) =
      _$CheckoutShippingAddressModelCopyWithImpl<
        $Res,
        CheckoutShippingAddressModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
    AddressModel? shippingNewAddress,
    @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
    String? shippingAddressId,
    @JsonKey(name: 'PickupPointId', includeIfNull: false) String? pickupPointId,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'PickupPoints', includeIfNull: false)
    List<CheckoutPickupPointModel>? pickupPoints,
    @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
    bool? billToTheSameAddress,
    @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
    bool? allowPickUpInStore,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
    @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
    bool? pickUpInStoreOnly,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get shippingNewAddress;
}

/// @nodoc
class _$CheckoutShippingAddressModelCopyWithImpl<
  $Res,
  $Val extends CheckoutShippingAddressModel
>
    implements $CheckoutShippingAddressModelCopyWith<$Res> {
  _$CheckoutShippingAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? existingAddresses = freezed,
    Object? warnings = freezed,
    Object? shippingNewAddress = freezed,
    Object? shippingAddressId = freezed,
    Object? pickupPointId = freezed,
    Object? newAddressPreselected = freezed,
    Object? pickupPoints = freezed,
    Object? billToTheSameAddress = freezed,
    Object? allowPickUpInStore = freezed,
    Object? pickUpInStore = freezed,
    Object? pickUpInStoreOnly = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            existingAddresses:
                freezed == existingAddresses
                    ? _value.existingAddresses
                    : existingAddresses // ignore: cast_nullable_to_non_nullable
                        as List<AddressModel>?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            shippingNewAddress:
                freezed == shippingNewAddress
                    ? _value.shippingNewAddress
                    : shippingNewAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            shippingAddressId:
                freezed == shippingAddressId
                    ? _value.shippingAddressId
                    : shippingAddressId // ignore: cast_nullable_to_non_nullable
                        as String?,
            pickupPointId:
                freezed == pickupPointId
                    ? _value.pickupPointId
                    : pickupPointId // ignore: cast_nullable_to_non_nullable
                        as String?,
            newAddressPreselected:
                freezed == newAddressPreselected
                    ? _value.newAddressPreselected
                    : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupPoints:
                freezed == pickupPoints
                    ? _value.pickupPoints
                    : pickupPoints // ignore: cast_nullable_to_non_nullable
                        as List<CheckoutPickupPointModel>?,
            billToTheSameAddress:
                freezed == billToTheSameAddress
                    ? _value.billToTheSameAddress
                    : billToTheSameAddress // ignore: cast_nullable_to_non_nullable
                        as bool?,
            allowPickUpInStore:
                freezed == allowPickUpInStore
                    ? _value.allowPickUpInStore
                    : allowPickUpInStore // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickUpInStore:
                freezed == pickUpInStore
                    ? _value.pickUpInStore
                    : pickUpInStore // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickUpInStoreOnly:
                freezed == pickUpInStoreOnly
                    ? _value.pickUpInStoreOnly
                    : pickUpInStoreOnly // ignore: cast_nullable_to_non_nullable
                        as bool?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get shippingNewAddress {
    if (_value.shippingNewAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.shippingNewAddress!, (value) {
      return _then(_value.copyWith(shippingNewAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutShippingAddressModelImplCopyWith<$Res>
    implements $CheckoutShippingAddressModelCopyWith<$Res> {
  factory _$$CheckoutShippingAddressModelImplCopyWith(
    _$CheckoutShippingAddressModelImpl value,
    $Res Function(_$CheckoutShippingAddressModelImpl) then,
  ) = __$$CheckoutShippingAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
    AddressModel? shippingNewAddress,
    @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
    String? shippingAddressId,
    @JsonKey(name: 'PickupPointId', includeIfNull: false) String? pickupPointId,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'PickupPoints', includeIfNull: false)
    List<CheckoutPickupPointModel>? pickupPoints,
    @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
    bool? billToTheSameAddress,
    @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
    bool? allowPickUpInStore,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
    @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
    bool? pickUpInStoreOnly,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get shippingNewAddress;
}

/// @nodoc
class __$$CheckoutShippingAddressModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutShippingAddressModelCopyWithImpl<
          $Res,
          _$CheckoutShippingAddressModelImpl
        >
    implements _$$CheckoutShippingAddressModelImplCopyWith<$Res> {
  __$$CheckoutShippingAddressModelImplCopyWithImpl(
    _$CheckoutShippingAddressModelImpl _value,
    $Res Function(_$CheckoutShippingAddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? existingAddresses = freezed,
    Object? warnings = freezed,
    Object? shippingNewAddress = freezed,
    Object? shippingAddressId = freezed,
    Object? pickupPointId = freezed,
    Object? newAddressPreselected = freezed,
    Object? pickupPoints = freezed,
    Object? billToTheSameAddress = freezed,
    Object? allowPickUpInStore = freezed,
    Object? pickUpInStore = freezed,
    Object? pickUpInStoreOnly = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutShippingAddressModelImpl(
        existingAddresses:
            freezed == existingAddresses
                ? _value._existingAddresses
                : existingAddresses // ignore: cast_nullable_to_non_nullable
                    as List<AddressModel>?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        shippingNewAddress:
            freezed == shippingNewAddress
                ? _value.shippingNewAddress
                : shippingNewAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        shippingAddressId:
            freezed == shippingAddressId
                ? _value.shippingAddressId
                : shippingAddressId // ignore: cast_nullable_to_non_nullable
                    as String?,
        pickupPointId:
            freezed == pickupPointId
                ? _value.pickupPointId
                : pickupPointId // ignore: cast_nullable_to_non_nullable
                    as String?,
        newAddressPreselected:
            freezed == newAddressPreselected
                ? _value.newAddressPreselected
                : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupPoints:
            freezed == pickupPoints
                ? _value._pickupPoints
                : pickupPoints // ignore: cast_nullable_to_non_nullable
                    as List<CheckoutPickupPointModel>?,
        billToTheSameAddress:
            freezed == billToTheSameAddress
                ? _value.billToTheSameAddress
                : billToTheSameAddress // ignore: cast_nullable_to_non_nullable
                    as bool?,
        allowPickUpInStore:
            freezed == allowPickUpInStore
                ? _value.allowPickUpInStore
                : allowPickUpInStore // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickUpInStore:
            freezed == pickUpInStore
                ? _value.pickUpInStore
                : pickUpInStore // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickUpInStoreOnly:
            freezed == pickUpInStoreOnly
                ? _value.pickUpInStoreOnly
                : pickUpInStoreOnly // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$CheckoutShippingAddressModelImpl
    implements _CheckoutShippingAddressModel {
  _$CheckoutShippingAddressModelImpl({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses = const [],
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
    this.shippingNewAddress,
    @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
    this.shippingAddressId,
    @JsonKey(name: 'PickupPointId', includeIfNull: false) this.pickupPointId,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    this.newAddressPreselected = false,
    @JsonKey(name: 'PickupPoints', includeIfNull: false)
    final List<CheckoutPickupPointModel>? pickupPoints = const [],
    @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
    this.billToTheSameAddress = false,
    @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
    this.allowPickUpInStore = false,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    this.pickUpInStore = false,
    @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
    this.pickUpInStoreOnly = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _existingAddresses = existingAddresses,
       _warnings = warnings,
       _pickupPoints = pickupPoints,
       _userFields = userFields;

  factory _$CheckoutShippingAddressModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutShippingAddressModelImplFromJson(json);

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

  final List<String>? _warnings;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
  final AddressModel? shippingNewAddress;
  @override
  @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
  final String? shippingAddressId;
  @override
  @JsonKey(name: 'PickupPointId', includeIfNull: false)
  final String? pickupPointId;
  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  final bool? newAddressPreselected;
  final List<CheckoutPickupPointModel>? _pickupPoints;
  @override
  @JsonKey(name: 'PickupPoints', includeIfNull: false)
  List<CheckoutPickupPointModel>? get pickupPoints {
    final value = _pickupPoints;
    if (value == null) return null;
    if (_pickupPoints is EqualUnmodifiableListView) return _pickupPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
  final bool? billToTheSameAddress;
  @override
  @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
  final bool? allowPickUpInStore;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  final bool? pickUpInStore;
  @override
  @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
  final bool? pickUpInStoreOnly;
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
    return 'CheckoutShippingAddressModel(existingAddresses: $existingAddresses, warnings: $warnings, shippingNewAddress: $shippingNewAddress, shippingAddressId: $shippingAddressId, pickupPointId: $pickupPointId, newAddressPreselected: $newAddressPreselected, pickupPoints: $pickupPoints, billToTheSameAddress: $billToTheSameAddress, allowPickUpInStore: $allowPickUpInStore, pickUpInStore: $pickUpInStore, pickUpInStoreOnly: $pickUpInStoreOnly, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutShippingAddressModelImpl &&
            const DeepCollectionEquality().equals(
              other._existingAddresses,
              _existingAddresses,
            ) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.shippingNewAddress, shippingNewAddress) ||
                other.shippingNewAddress == shippingNewAddress) &&
            (identical(other.shippingAddressId, shippingAddressId) ||
                other.shippingAddressId == shippingAddressId) &&
            (identical(other.pickupPointId, pickupPointId) ||
                other.pickupPointId == pickupPointId) &&
            (identical(other.newAddressPreselected, newAddressPreselected) ||
                other.newAddressPreselected == newAddressPreselected) &&
            const DeepCollectionEquality().equals(
              other._pickupPoints,
              _pickupPoints,
            ) &&
            (identical(other.billToTheSameAddress, billToTheSameAddress) ||
                other.billToTheSameAddress == billToTheSameAddress) &&
            (identical(other.allowPickUpInStore, allowPickUpInStore) ||
                other.allowPickUpInStore == allowPickUpInStore) &&
            (identical(other.pickUpInStore, pickUpInStore) ||
                other.pickUpInStore == pickUpInStore) &&
            (identical(other.pickUpInStoreOnly, pickUpInStoreOnly) ||
                other.pickUpInStoreOnly == pickUpInStoreOnly) &&
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
    const DeepCollectionEquality().hash(_warnings),
    shippingNewAddress,
    shippingAddressId,
    pickupPointId,
    newAddressPreselected,
    const DeepCollectionEquality().hash(_pickupPoints),
    billToTheSameAddress,
    allowPickUpInStore,
    pickUpInStore,
    pickUpInStoreOnly,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutShippingAddressModelImplCopyWith<
    _$CheckoutShippingAddressModelImpl
  >
  get copyWith => __$$CheckoutShippingAddressModelImplCopyWithImpl<
    _$CheckoutShippingAddressModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutShippingAddressModelImplToJson(this);
  }
}

abstract class _CheckoutShippingAddressModel
    implements CheckoutShippingAddressModel {
  factory _CheckoutShippingAddressModel({
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
    final AddressModel? shippingNewAddress,
    @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
    final String? shippingAddressId,
    @JsonKey(name: 'PickupPointId', includeIfNull: false)
    final String? pickupPointId,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    final bool? newAddressPreselected,
    @JsonKey(name: 'PickupPoints', includeIfNull: false)
    final List<CheckoutPickupPointModel>? pickupPoints,
    @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
    final bool? billToTheSameAddress,
    @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
    final bool? allowPickUpInStore,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    final bool? pickUpInStore,
    @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
    final bool? pickUpInStoreOnly,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutShippingAddressModelImpl;

  factory _CheckoutShippingAddressModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutShippingAddressModelImpl.fromJson;

  @override
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
  @override
  @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
  AddressModel? get shippingNewAddress;
  @override
  @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
  String? get shippingAddressId;
  @override
  @JsonKey(name: 'PickupPointId', includeIfNull: false)
  String? get pickupPointId;
  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected;
  @override
  @JsonKey(name: 'PickupPoints', includeIfNull: false)
  List<CheckoutPickupPointModel>? get pickupPoints;
  @override
  @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
  bool? get billToTheSameAddress;
  @override
  @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
  bool? get allowPickUpInStore;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore;
  @override
  @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
  bool? get pickUpInStoreOnly;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutShippingAddressModelImplCopyWith<
    _$CheckoutShippingAddressModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
