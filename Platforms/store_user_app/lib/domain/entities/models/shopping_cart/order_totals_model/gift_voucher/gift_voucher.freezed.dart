// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_voucher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GiftVoucher _$GiftVoucherFromJson(Map<String, dynamic> json) {
  return _GiftVoucher.fromJson(json);
}

/// @nodoc
mixin _$GiftVoucher {
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Amount', includeIfNull: false)
  String? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Remaining', includeIfNull: false)
  String? get remaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this GiftVoucher to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftVoucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftVoucherCopyWith<GiftVoucher> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftVoucherCopyWith<$Res> {
  factory $GiftVoucherCopyWith(
    GiftVoucher value,
    $Res Function(GiftVoucher) then,
  ) = _$GiftVoucherCopyWithImpl<$Res, GiftVoucher>;
  @useResult
  $Res call({
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'Amount', includeIfNull: false) String? amount,
    @JsonKey(name: 'Remaining', includeIfNull: false) String? remaining,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$GiftVoucherCopyWithImpl<$Res, $Val extends GiftVoucher>
    implements $GiftVoucherCopyWith<$Res> {
  _$GiftVoucherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftVoucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponCode = freezed,
    Object? amount = freezed,
    Object? remaining = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            couponCode:
                freezed == couponCode
                    ? _value.couponCode
                    : couponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            amount:
                freezed == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as String?,
            remaining:
                freezed == remaining
                    ? _value.remaining
                    : remaining // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$GiftVoucherImplCopyWith<$Res>
    implements $GiftVoucherCopyWith<$Res> {
  factory _$$GiftVoucherImplCopyWith(
    _$GiftVoucherImpl value,
    $Res Function(_$GiftVoucherImpl) then,
  ) = __$$GiftVoucherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'Amount', includeIfNull: false) String? amount,
    @JsonKey(name: 'Remaining', includeIfNull: false) String? remaining,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$GiftVoucherImplCopyWithImpl<$Res>
    extends _$GiftVoucherCopyWithImpl<$Res, _$GiftVoucherImpl>
    implements _$$GiftVoucherImplCopyWith<$Res> {
  __$$GiftVoucherImplCopyWithImpl(
    _$GiftVoucherImpl _value,
    $Res Function(_$GiftVoucherImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GiftVoucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponCode = freezed,
    Object? amount = freezed,
    Object? remaining = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$GiftVoucherImpl(
        couponCode:
            freezed == couponCode
                ? _value.couponCode
                : couponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        amount:
            freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as String?,
        remaining:
            freezed == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$GiftVoucherImpl implements _GiftVoucher {
  _$GiftVoucherImpl({
    @JsonKey(name: 'CouponCode', includeIfNull: false) this.couponCode,
    @JsonKey(name: 'Amount', includeIfNull: false) this.amount,
    @JsonKey(name: 'Remaining', includeIfNull: false) this.remaining,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$GiftVoucherImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftVoucherImplFromJson(json);

  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  final String? couponCode;
  @override
  @JsonKey(name: 'Amount', includeIfNull: false)
  final String? amount;
  @override
  @JsonKey(name: 'Remaining', includeIfNull: false)
  final String? remaining;
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
    return 'GiftVoucher(couponCode: $couponCode, amount: $amount, remaining: $remaining, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftVoucherImpl &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    couponCode,
    amount,
    remaining,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of GiftVoucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftVoucherImplCopyWith<_$GiftVoucherImpl> get copyWith =>
      __$$GiftVoucherImplCopyWithImpl<_$GiftVoucherImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftVoucherImplToJson(this);
  }
}

abstract class _GiftVoucher implements GiftVoucher {
  factory _GiftVoucher({
    @JsonKey(name: 'CouponCode', includeIfNull: false) final String? couponCode,
    @JsonKey(name: 'Amount', includeIfNull: false) final String? amount,
    @JsonKey(name: 'Remaining', includeIfNull: false) final String? remaining,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$GiftVoucherImpl;

  factory _GiftVoucher.fromJson(Map<String, dynamic> json) =
      _$GiftVoucherImpl.fromJson;

  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode;
  @override
  @JsonKey(name: 'Amount', includeIfNull: false)
  String? get amount;
  @override
  @JsonKey(name: 'Remaining', includeIfNull: false)
  String? get remaining;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of GiftVoucher
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftVoucherImplCopyWith<_$GiftVoucherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
