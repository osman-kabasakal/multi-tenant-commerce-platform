// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_payment_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutPaymentMethodModel _$CheckoutPaymentMethodModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutPaymentMethodModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutPaymentMethodModel {
  @JsonKey(name: 'PaymentMethods', includeIfNull: false)
  List<PaymentMethodModel>? get paymentMethods =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
  bool? get displayLoyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  int? get loyaltyPointsBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  String? get loyaltyPointsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
  bool? get loyaltyPointsEnoughToPayForOrder =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
  bool? get useLoyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutPaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutPaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutPaymentMethodModelCopyWith<CheckoutPaymentMethodModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutPaymentMethodModelCopyWith<$Res> {
  factory $CheckoutPaymentMethodModelCopyWith(
    CheckoutPaymentMethodModel value,
    $Res Function(CheckoutPaymentMethodModel) then,
  ) =
      _$CheckoutPaymentMethodModelCopyWithImpl<
        $Res,
        CheckoutPaymentMethodModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentMethods', includeIfNull: false)
    List<PaymentMethodModel>? paymentMethods,
    @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
    bool? displayLoyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    String? loyaltyPointsAmount,
    @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
    bool? loyaltyPointsEnoughToPayForOrder,
    @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
    bool? useLoyaltyPoints,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CheckoutPaymentMethodModelCopyWithImpl<
  $Res,
  $Val extends CheckoutPaymentMethodModel
>
    implements $CheckoutPaymentMethodModelCopyWith<$Res> {
  _$CheckoutPaymentMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutPaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethods = freezed,
    Object? displayLoyaltyPoints = freezed,
    Object? loyaltyPointsBalance = freezed,
    Object? loyaltyPointsAmount = freezed,
    Object? loyaltyPointsEnoughToPayForOrder = freezed,
    Object? useLoyaltyPoints = freezed,
    Object? paymentMethod = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentMethods:
                freezed == paymentMethods
                    ? _value.paymentMethods
                    : paymentMethods // ignore: cast_nullable_to_non_nullable
                        as List<PaymentMethodModel>?,
            displayLoyaltyPoints:
                freezed == displayLoyaltyPoints
                    ? _value.displayLoyaltyPoints
                    : displayLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as bool?,
            loyaltyPointsBalance:
                freezed == loyaltyPointsBalance
                    ? _value.loyaltyPointsBalance
                    : loyaltyPointsBalance // ignore: cast_nullable_to_non_nullable
                        as int?,
            loyaltyPointsAmount:
                freezed == loyaltyPointsAmount
                    ? _value.loyaltyPointsAmount
                    : loyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
            loyaltyPointsEnoughToPayForOrder:
                freezed == loyaltyPointsEnoughToPayForOrder
                    ? _value.loyaltyPointsEnoughToPayForOrder
                    : loyaltyPointsEnoughToPayForOrder // ignore: cast_nullable_to_non_nullable
                        as bool?,
            useLoyaltyPoints:
                freezed == useLoyaltyPoints
                    ? _value.useLoyaltyPoints
                    : useLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as bool?,
            paymentMethod:
                freezed == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CheckoutPaymentMethodModelImplCopyWith<$Res>
    implements $CheckoutPaymentMethodModelCopyWith<$Res> {
  factory _$$CheckoutPaymentMethodModelImplCopyWith(
    _$CheckoutPaymentMethodModelImpl value,
    $Res Function(_$CheckoutPaymentMethodModelImpl) then,
  ) = __$$CheckoutPaymentMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentMethods', includeIfNull: false)
    List<PaymentMethodModel>? paymentMethods,
    @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
    bool? displayLoyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    String? loyaltyPointsAmount,
    @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
    bool? loyaltyPointsEnoughToPayForOrder,
    @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
    bool? useLoyaltyPoints,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CheckoutPaymentMethodModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutPaymentMethodModelCopyWithImpl<
          $Res,
          _$CheckoutPaymentMethodModelImpl
        >
    implements _$$CheckoutPaymentMethodModelImplCopyWith<$Res> {
  __$$CheckoutPaymentMethodModelImplCopyWithImpl(
    _$CheckoutPaymentMethodModelImpl _value,
    $Res Function(_$CheckoutPaymentMethodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutPaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethods = freezed,
    Object? displayLoyaltyPoints = freezed,
    Object? loyaltyPointsBalance = freezed,
    Object? loyaltyPointsAmount = freezed,
    Object? loyaltyPointsEnoughToPayForOrder = freezed,
    Object? useLoyaltyPoints = freezed,
    Object? paymentMethod = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutPaymentMethodModelImpl(
        paymentMethods:
            freezed == paymentMethods
                ? _value._paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                    as List<PaymentMethodModel>?,
        displayLoyaltyPoints:
            freezed == displayLoyaltyPoints
                ? _value.displayLoyaltyPoints
                : displayLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as bool?,
        loyaltyPointsBalance:
            freezed == loyaltyPointsBalance
                ? _value.loyaltyPointsBalance
                : loyaltyPointsBalance // ignore: cast_nullable_to_non_nullable
                    as int?,
        loyaltyPointsAmount:
            freezed == loyaltyPointsAmount
                ? _value.loyaltyPointsAmount
                : loyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
        loyaltyPointsEnoughToPayForOrder:
            freezed == loyaltyPointsEnoughToPayForOrder
                ? _value.loyaltyPointsEnoughToPayForOrder
                : loyaltyPointsEnoughToPayForOrder // ignore: cast_nullable_to_non_nullable
                    as bool?,
        useLoyaltyPoints:
            freezed == useLoyaltyPoints
                ? _value.useLoyaltyPoints
                : useLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as bool?,
        paymentMethod:
            freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
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
class _$CheckoutPaymentMethodModelImpl implements _CheckoutPaymentMethodModel {
  _$CheckoutPaymentMethodModelImpl({
    @JsonKey(name: 'PaymentMethods', includeIfNull: false)
    final List<PaymentMethodModel>? paymentMethods = const [],
    @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
    this.displayLoyaltyPoints = false,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    this.loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    this.loyaltyPointsAmount,
    @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
    this.loyaltyPointsEnoughToPayForOrder = false,
    @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
    this.useLoyaltyPoints = false,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) this.paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _paymentMethods = paymentMethods,
       _userFields = userFields;

  factory _$CheckoutPaymentMethodModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutPaymentMethodModelImplFromJson(json);

  final List<PaymentMethodModel>? _paymentMethods;
  @override
  @JsonKey(name: 'PaymentMethods', includeIfNull: false)
  List<PaymentMethodModel>? get paymentMethods {
    final value = _paymentMethods;
    if (value == null) return null;
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
  final bool? displayLoyaltyPoints;
  @override
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  final int? loyaltyPointsBalance;
  @override
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  final String? loyaltyPointsAmount;
  @override
  @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
  final bool? loyaltyPointsEnoughToPayForOrder;
  @override
  @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
  final bool? useLoyaltyPoints;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  final String? paymentMethod;
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
    return 'CheckoutPaymentMethodModel(paymentMethods: $paymentMethods, displayLoyaltyPoints: $displayLoyaltyPoints, loyaltyPointsBalance: $loyaltyPointsBalance, loyaltyPointsAmount: $loyaltyPointsAmount, loyaltyPointsEnoughToPayForOrder: $loyaltyPointsEnoughToPayForOrder, useLoyaltyPoints: $useLoyaltyPoints, paymentMethod: $paymentMethod, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutPaymentMethodModelImpl &&
            const DeepCollectionEquality().equals(
              other._paymentMethods,
              _paymentMethods,
            ) &&
            (identical(other.displayLoyaltyPoints, displayLoyaltyPoints) ||
                other.displayLoyaltyPoints == displayLoyaltyPoints) &&
            (identical(other.loyaltyPointsBalance, loyaltyPointsBalance) ||
                other.loyaltyPointsBalance == loyaltyPointsBalance) &&
            (identical(other.loyaltyPointsAmount, loyaltyPointsAmount) ||
                other.loyaltyPointsAmount == loyaltyPointsAmount) &&
            (identical(
                  other.loyaltyPointsEnoughToPayForOrder,
                  loyaltyPointsEnoughToPayForOrder,
                ) ||
                other.loyaltyPointsEnoughToPayForOrder ==
                    loyaltyPointsEnoughToPayForOrder) &&
            (identical(other.useLoyaltyPoints, useLoyaltyPoints) ||
                other.useLoyaltyPoints == useLoyaltyPoints) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_paymentMethods),
    displayLoyaltyPoints,
    loyaltyPointsBalance,
    loyaltyPointsAmount,
    loyaltyPointsEnoughToPayForOrder,
    useLoyaltyPoints,
    paymentMethod,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutPaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutPaymentMethodModelImplCopyWith<_$CheckoutPaymentMethodModelImpl>
  get copyWith => __$$CheckoutPaymentMethodModelImplCopyWithImpl<
    _$CheckoutPaymentMethodModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutPaymentMethodModelImplToJson(this);
  }
}

abstract class _CheckoutPaymentMethodModel
    implements CheckoutPaymentMethodModel {
  factory _CheckoutPaymentMethodModel({
    @JsonKey(name: 'PaymentMethods', includeIfNull: false)
    final List<PaymentMethodModel>? paymentMethods,
    @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
    final bool? displayLoyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    final int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    final String? loyaltyPointsAmount,
    @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
    final bool? loyaltyPointsEnoughToPayForOrder,
    @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
    final bool? useLoyaltyPoints,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false)
    final String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutPaymentMethodModelImpl;

  factory _CheckoutPaymentMethodModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutPaymentMethodModelImpl.fromJson;

  @override
  @JsonKey(name: 'PaymentMethods', includeIfNull: false)
  List<PaymentMethodModel>? get paymentMethods;
  @override
  @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
  bool? get displayLoyaltyPoints;
  @override
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  int? get loyaltyPointsBalance;
  @override
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  String? get loyaltyPointsAmount;
  @override
  @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
  bool? get loyaltyPointsEnoughToPayForOrder;
  @override
  @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
  bool? get useLoyaltyPoints;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutPaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutPaymentMethodModelImplCopyWith<_$CheckoutPaymentMethodModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
