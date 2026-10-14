// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_loyalty_points_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerLoyaltyPointsModel _$CustomerLoyaltyPointsModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerLoyaltyPointsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerLoyaltyPointsModel {
  @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
  List<LoyaltyPointsHistoryModel>? get loyaltyPoints =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  int? get loyaltyPointsBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  String? get loyaltyPointsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
  int? get minimumLoyaltyPointsBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
  String? get minimumLoyaltyPointsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerLoyaltyPointsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerLoyaltyPointsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerLoyaltyPointsModelCopyWith<CustomerLoyaltyPointsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerLoyaltyPointsModelCopyWith<$Res> {
  factory $CustomerLoyaltyPointsModelCopyWith(
    CustomerLoyaltyPointsModel value,
    $Res Function(CustomerLoyaltyPointsModel) then,
  ) =
      _$CustomerLoyaltyPointsModelCopyWithImpl<
        $Res,
        CustomerLoyaltyPointsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
    List<LoyaltyPointsHistoryModel>? loyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    String? loyaltyPointsAmount,
    @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
    int? minimumLoyaltyPointsBalance,
    @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
    String? minimumLoyaltyPointsAmount,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerLoyaltyPointsModelCopyWithImpl<
  $Res,
  $Val extends CustomerLoyaltyPointsModel
>
    implements $CustomerLoyaltyPointsModelCopyWith<$Res> {
  _$CustomerLoyaltyPointsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerLoyaltyPointsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loyaltyPoints = freezed,
    Object? loyaltyPointsBalance = freezed,
    Object? loyaltyPointsAmount = freezed,
    Object? minimumLoyaltyPointsBalance = freezed,
    Object? minimumLoyaltyPointsAmount = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            loyaltyPoints:
                freezed == loyaltyPoints
                    ? _value.loyaltyPoints
                    : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as List<LoyaltyPointsHistoryModel>?,
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
            minimumLoyaltyPointsBalance:
                freezed == minimumLoyaltyPointsBalance
                    ? _value.minimumLoyaltyPointsBalance
                    : minimumLoyaltyPointsBalance // ignore: cast_nullable_to_non_nullable
                        as int?,
            minimumLoyaltyPointsAmount:
                freezed == minimumLoyaltyPointsAmount
                    ? _value.minimumLoyaltyPointsAmount
                    : minimumLoyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerLoyaltyPointsModelImplCopyWith<$Res>
    implements $CustomerLoyaltyPointsModelCopyWith<$Res> {
  factory _$$CustomerLoyaltyPointsModelImplCopyWith(
    _$CustomerLoyaltyPointsModelImpl value,
    $Res Function(_$CustomerLoyaltyPointsModelImpl) then,
  ) = __$$CustomerLoyaltyPointsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
    List<LoyaltyPointsHistoryModel>? loyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    String? loyaltyPointsAmount,
    @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
    int? minimumLoyaltyPointsBalance,
    @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
    String? minimumLoyaltyPointsAmount,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerLoyaltyPointsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerLoyaltyPointsModelCopyWithImpl<
          $Res,
          _$CustomerLoyaltyPointsModelImpl
        >
    implements _$$CustomerLoyaltyPointsModelImplCopyWith<$Res> {
  __$$CustomerLoyaltyPointsModelImplCopyWithImpl(
    _$CustomerLoyaltyPointsModelImpl _value,
    $Res Function(_$CustomerLoyaltyPointsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerLoyaltyPointsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loyaltyPoints = freezed,
    Object? loyaltyPointsBalance = freezed,
    Object? loyaltyPointsAmount = freezed,
    Object? minimumLoyaltyPointsBalance = freezed,
    Object? minimumLoyaltyPointsAmount = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerLoyaltyPointsModelImpl(
        loyaltyPoints:
            freezed == loyaltyPoints
                ? _value._loyaltyPoints
                : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as List<LoyaltyPointsHistoryModel>?,
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
        minimumLoyaltyPointsBalance:
            freezed == minimumLoyaltyPointsBalance
                ? _value.minimumLoyaltyPointsBalance
                : minimumLoyaltyPointsBalance // ignore: cast_nullable_to_non_nullable
                    as int?,
        minimumLoyaltyPointsAmount:
            freezed == minimumLoyaltyPointsAmount
                ? _value.minimumLoyaltyPointsAmount
                : minimumLoyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
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
class _$CustomerLoyaltyPointsModelImpl implements _CustomerLoyaltyPointsModel {
  _$CustomerLoyaltyPointsModelImpl({
    @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
    final List<LoyaltyPointsHistoryModel>? loyaltyPoints = const [],
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    this.loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    this.loyaltyPointsAmount,
    @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
    this.minimumLoyaltyPointsBalance,
    @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
    this.minimumLoyaltyPointsAmount,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _loyaltyPoints = loyaltyPoints,
       _userFields = userFields;

  factory _$CustomerLoyaltyPointsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerLoyaltyPointsModelImplFromJson(json);

  final List<LoyaltyPointsHistoryModel>? _loyaltyPoints;
  @override
  @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
  List<LoyaltyPointsHistoryModel>? get loyaltyPoints {
    final value = _loyaltyPoints;
    if (value == null) return null;
    if (_loyaltyPoints is EqualUnmodifiableListView) return _loyaltyPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  final int? loyaltyPointsBalance;
  @override
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  final String? loyaltyPointsAmount;
  @override
  @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
  final int? minimumLoyaltyPointsBalance;
  @override
  @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
  final String? minimumLoyaltyPointsAmount;
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
    return 'CustomerLoyaltyPointsModel(loyaltyPoints: $loyaltyPoints, loyaltyPointsBalance: $loyaltyPointsBalance, loyaltyPointsAmount: $loyaltyPointsAmount, minimumLoyaltyPointsBalance: $minimumLoyaltyPointsBalance, minimumLoyaltyPointsAmount: $minimumLoyaltyPointsAmount, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerLoyaltyPointsModelImpl &&
            const DeepCollectionEquality().equals(
              other._loyaltyPoints,
              _loyaltyPoints,
            ) &&
            (identical(other.loyaltyPointsBalance, loyaltyPointsBalance) ||
                other.loyaltyPointsBalance == loyaltyPointsBalance) &&
            (identical(other.loyaltyPointsAmount, loyaltyPointsAmount) ||
                other.loyaltyPointsAmount == loyaltyPointsAmount) &&
            (identical(
                  other.minimumLoyaltyPointsBalance,
                  minimumLoyaltyPointsBalance,
                ) ||
                other.minimumLoyaltyPointsBalance ==
                    minimumLoyaltyPointsBalance) &&
            (identical(
                  other.minimumLoyaltyPointsAmount,
                  minimumLoyaltyPointsAmount,
                ) ||
                other.minimumLoyaltyPointsAmount ==
                    minimumLoyaltyPointsAmount) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_loyaltyPoints),
    loyaltyPointsBalance,
    loyaltyPointsAmount,
    minimumLoyaltyPointsBalance,
    minimumLoyaltyPointsAmount,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerLoyaltyPointsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerLoyaltyPointsModelImplCopyWith<_$CustomerLoyaltyPointsModelImpl>
  get copyWith => __$$CustomerLoyaltyPointsModelImplCopyWithImpl<
    _$CustomerLoyaltyPointsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerLoyaltyPointsModelImplToJson(this);
  }
}

abstract class _CustomerLoyaltyPointsModel
    implements CustomerLoyaltyPointsModel {
  factory _CustomerLoyaltyPointsModel({
    @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
    final List<LoyaltyPointsHistoryModel>? loyaltyPoints,
    @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
    final int? loyaltyPointsBalance,
    @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
    final String? loyaltyPointsAmount,
    @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
    final int? minimumLoyaltyPointsBalance,
    @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
    final String? minimumLoyaltyPointsAmount,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerLoyaltyPointsModelImpl;

  factory _CustomerLoyaltyPointsModel.fromJson(Map<String, dynamic> json) =
      _$CustomerLoyaltyPointsModelImpl.fromJson;

  @override
  @JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
  List<LoyaltyPointsHistoryModel>? get loyaltyPoints;
  @override
  @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
  int? get loyaltyPointsBalance;
  @override
  @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
  String? get loyaltyPointsAmount;
  @override
  @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
  int? get minimumLoyaltyPointsBalance;
  @override
  @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
  String? get minimumLoyaltyPointsAmount;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerLoyaltyPointsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerLoyaltyPointsModelImplCopyWith<_$CustomerLoyaltyPointsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
