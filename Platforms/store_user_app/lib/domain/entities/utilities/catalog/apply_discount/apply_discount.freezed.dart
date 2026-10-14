// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apply_discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplyDiscount _$ApplyDiscountFromJson(Map<String, dynamic> json) {
  return _ApplyDiscount.fromJson(json);
}

/// @nodoc
mixin _$ApplyDiscount {
  @JsonKey(name: 'DiscountId', includeIfNull: false)
  String? get discountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsCumulative', includeIfNull: false)
  bool? get isCumulative => throw _privateConstructorUsedError;

  /// Serializes this ApplyDiscount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplyDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplyDiscountCopyWith<ApplyDiscount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplyDiscountCopyWith<$Res> {
  factory $ApplyDiscountCopyWith(
    ApplyDiscount value,
    $Res Function(ApplyDiscount) then,
  ) = _$ApplyDiscountCopyWithImpl<$Res, ApplyDiscount>;
  @useResult
  $Res call({
    @JsonKey(name: 'DiscountId', includeIfNull: false) String? discountId,
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'IsCumulative', includeIfNull: false) bool? isCumulative,
  });
}

/// @nodoc
class _$ApplyDiscountCopyWithImpl<$Res, $Val extends ApplyDiscount>
    implements $ApplyDiscountCopyWith<$Res> {
  _$ApplyDiscountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplyDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = freezed,
    Object? couponCode = freezed,
    Object? isCumulative = freezed,
  }) {
    return _then(
      _value.copyWith(
            discountId:
                freezed == discountId
                    ? _value.discountId
                    : discountId // ignore: cast_nullable_to_non_nullable
                        as String?,
            couponCode:
                freezed == couponCode
                    ? _value.couponCode
                    : couponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            isCumulative:
                freezed == isCumulative
                    ? _value.isCumulative
                    : isCumulative // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplyDiscountImplCopyWith<$Res>
    implements $ApplyDiscountCopyWith<$Res> {
  factory _$$ApplyDiscountImplCopyWith(
    _$ApplyDiscountImpl value,
    $Res Function(_$ApplyDiscountImpl) then,
  ) = __$$ApplyDiscountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'DiscountId', includeIfNull: false) String? discountId,
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'IsCumulative', includeIfNull: false) bool? isCumulative,
  });
}

/// @nodoc
class __$$ApplyDiscountImplCopyWithImpl<$Res>
    extends _$ApplyDiscountCopyWithImpl<$Res, _$ApplyDiscountImpl>
    implements _$$ApplyDiscountImplCopyWith<$Res> {
  __$$ApplyDiscountImplCopyWithImpl(
    _$ApplyDiscountImpl _value,
    $Res Function(_$ApplyDiscountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplyDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = freezed,
    Object? couponCode = freezed,
    Object? isCumulative = freezed,
  }) {
    return _then(
      _$ApplyDiscountImpl(
        discountId:
            freezed == discountId
                ? _value.discountId
                : discountId // ignore: cast_nullable_to_non_nullable
                    as String?,
        couponCode:
            freezed == couponCode
                ? _value.couponCode
                : couponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        isCumulative:
            freezed == isCumulative
                ? _value.isCumulative
                : isCumulative // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplyDiscountImpl implements _ApplyDiscount {
  _$ApplyDiscountImpl({
    @JsonKey(name: 'DiscountId', includeIfNull: false) this.discountId,
    @JsonKey(name: 'CouponCode', includeIfNull: false) this.couponCode,
    @JsonKey(name: 'IsCumulative', includeIfNull: false)
    this.isCumulative = false,
  });

  factory _$ApplyDiscountImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplyDiscountImplFromJson(json);

  @override
  @JsonKey(name: 'DiscountId', includeIfNull: false)
  final String? discountId;
  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  final String? couponCode;
  @override
  @JsonKey(name: 'IsCumulative', includeIfNull: false)
  final bool? isCumulative;

  @override
  String toString() {
    return 'ApplyDiscount(discountId: $discountId, couponCode: $couponCode, isCumulative: $isCumulative)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyDiscountImpl &&
            (identical(other.discountId, discountId) ||
                other.discountId == discountId) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.isCumulative, isCumulative) ||
                other.isCumulative == isCumulative));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, discountId, couponCode, isCumulative);

  /// Create a copy of ApplyDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyDiscountImplCopyWith<_$ApplyDiscountImpl> get copyWith =>
      __$$ApplyDiscountImplCopyWithImpl<_$ApplyDiscountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplyDiscountImplToJson(this);
  }
}

abstract class _ApplyDiscount implements ApplyDiscount {
  factory _ApplyDiscount({
    @JsonKey(name: 'DiscountId', includeIfNull: false) final String? discountId,
    @JsonKey(name: 'CouponCode', includeIfNull: false) final String? couponCode,
    @JsonKey(name: 'IsCumulative', includeIfNull: false)
    final bool? isCumulative,
  }) = _$ApplyDiscountImpl;

  factory _ApplyDiscount.fromJson(Map<String, dynamic> json) =
      _$ApplyDiscountImpl.fromJson;

  @override
  @JsonKey(name: 'DiscountId', includeIfNull: false)
  String? get discountId;
  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode;
  @override
  @JsonKey(name: 'IsCumulative', includeIfNull: false)
  bool? get isCumulative;

  /// Create a copy of ApplyDiscount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyDiscountImplCopyWith<_$ApplyDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
