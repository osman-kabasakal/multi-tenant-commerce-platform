// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutModel _$CheckoutModelFromJson(Map<String, dynamic> json) {
  return _CheckoutModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutModel {
  @JsonKey(name: 'ShippingRequired', includeIfNull: false)
  bool? get shippingRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  CheckoutBillingAddressModel? get billingAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  CheckoutShippingAddressModel? get shippingAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutModelCopyWith<CheckoutModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutModelCopyWith<$Res> {
  factory $CheckoutModelCopyWith(
    CheckoutModel value,
    $Res Function(CheckoutModel) then,
  ) = _$CheckoutModelCopyWithImpl<$Res, CheckoutModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRequired', includeIfNull: false)
    bool? shippingRequired,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    CheckoutBillingAddressModel? billingAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    CheckoutShippingAddressModel? shippingAddress,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $CheckoutBillingAddressModelCopyWith<$Res>? get billingAddress;
  $CheckoutShippingAddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$CheckoutModelCopyWithImpl<$Res, $Val extends CheckoutModel>
    implements $CheckoutModelCopyWith<$Res> {
  _$CheckoutModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRequired = freezed,
    Object? billingAddress = freezed,
    Object? shippingAddress = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            shippingRequired:
                freezed == shippingRequired
                    ? _value.shippingRequired
                    : shippingRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            billingAddress:
                freezed == billingAddress
                    ? _value.billingAddress
                    : billingAddress // ignore: cast_nullable_to_non_nullable
                        as CheckoutBillingAddressModel?,
            shippingAddress:
                freezed == shippingAddress
                    ? _value.shippingAddress
                    : shippingAddress // ignore: cast_nullable_to_non_nullable
                        as CheckoutShippingAddressModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutBillingAddressModelCopyWith<$Res>? get billingAddress {
    if (_value.billingAddress == null) {
      return null;
    }

    return $CheckoutBillingAddressModelCopyWith<$Res>(_value.billingAddress!, (
      value,
    ) {
      return _then(_value.copyWith(billingAddress: value) as $Val);
    });
  }

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutShippingAddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $CheckoutShippingAddressModelCopyWith<$Res>(
      _value.shippingAddress!,
      (value) {
        return _then(_value.copyWith(shippingAddress: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$CheckoutModelImplCopyWith<$Res>
    implements $CheckoutModelCopyWith<$Res> {
  factory _$$CheckoutModelImplCopyWith(
    _$CheckoutModelImpl value,
    $Res Function(_$CheckoutModelImpl) then,
  ) = __$$CheckoutModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRequired', includeIfNull: false)
    bool? shippingRequired,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    CheckoutBillingAddressModel? billingAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    CheckoutShippingAddressModel? shippingAddress,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $CheckoutBillingAddressModelCopyWith<$Res>? get billingAddress;
  @override
  $CheckoutShippingAddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$CheckoutModelImplCopyWithImpl<$Res>
    extends _$CheckoutModelCopyWithImpl<$Res, _$CheckoutModelImpl>
    implements _$$CheckoutModelImplCopyWith<$Res> {
  __$$CheckoutModelImplCopyWithImpl(
    _$CheckoutModelImpl _value,
    $Res Function(_$CheckoutModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRequired = freezed,
    Object? billingAddress = freezed,
    Object? shippingAddress = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutModelImpl(
        shippingRequired:
            freezed == shippingRequired
                ? _value.shippingRequired
                : shippingRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        billingAddress:
            freezed == billingAddress
                ? _value.billingAddress
                : billingAddress // ignore: cast_nullable_to_non_nullable
                    as CheckoutBillingAddressModel?,
        shippingAddress:
            freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                    as CheckoutShippingAddressModel?,
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
class _$CheckoutModelImpl implements _CheckoutModel {
  _$CheckoutModelImpl({
    @JsonKey(name: 'ShippingRequired', includeIfNull: false)
    this.shippingRequired = false,
    @JsonKey(name: 'BillingAddress', includeIfNull: false) this.billingAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    this.shippingAddress,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CheckoutModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutModelImplFromJson(json);

  @override
  @JsonKey(name: 'ShippingRequired', includeIfNull: false)
  final bool? shippingRequired;
  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  final CheckoutBillingAddressModel? billingAddress;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  final CheckoutShippingAddressModel? shippingAddress;
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
    return 'CheckoutModel(shippingRequired: $shippingRequired, billingAddress: $billingAddress, shippingAddress: $shippingAddress, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutModelImpl &&
            (identical(other.shippingRequired, shippingRequired) ||
                other.shippingRequired == shippingRequired) &&
            (identical(other.billingAddress, billingAddress) ||
                other.billingAddress == billingAddress) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    shippingRequired,
    billingAddress,
    shippingAddress,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutModelImplCopyWith<_$CheckoutModelImpl> get copyWith =>
      __$$CheckoutModelImplCopyWithImpl<_$CheckoutModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutModelImplToJson(this);
  }
}

abstract class _CheckoutModel implements CheckoutModel {
  factory _CheckoutModel({
    @JsonKey(name: 'ShippingRequired', includeIfNull: false)
    final bool? shippingRequired,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    final CheckoutBillingAddressModel? billingAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    final CheckoutShippingAddressModel? shippingAddress,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutModelImpl;

  factory _CheckoutModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShippingRequired', includeIfNull: false)
  bool? get shippingRequired;
  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  CheckoutBillingAddressModel? get billingAddress;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  CheckoutShippingAddressModel? get shippingAddress;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutModelImplCopyWith<_$CheckoutModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
