// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_voucher_coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GiftVoucherCouponModel _$GiftVoucherCouponModelFromJson(
  Map<String, dynamic> json,
) {
  return _GiftVoucherCouponModel.fromJson(json);
}

/// @nodoc
mixin _$GiftVoucherCouponModel {
  @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
  String? get giftVoucherCouponCode => throw _privateConstructorUsedError;

  /// Serializes this GiftVoucherCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftVoucherCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftVoucherCouponModelCopyWith<GiftVoucherCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftVoucherCouponModelCopyWith<$Res> {
  factory $GiftVoucherCouponModelCopyWith(
    GiftVoucherCouponModel value,
    $Res Function(GiftVoucherCouponModel) then,
  ) = _$GiftVoucherCouponModelCopyWithImpl<$Res, GiftVoucherCouponModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
    String? giftVoucherCouponCode,
  });
}

/// @nodoc
class _$GiftVoucherCouponModelCopyWithImpl<
  $Res,
  $Val extends GiftVoucherCouponModel
>
    implements $GiftVoucherCouponModelCopyWith<$Res> {
  _$GiftVoucherCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftVoucherCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? giftVoucherCouponCode = freezed}) {
    return _then(
      _value.copyWith(
            giftVoucherCouponCode:
                freezed == giftVoucherCouponCode
                    ? _value.giftVoucherCouponCode
                    : giftVoucherCouponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GiftVoucherCouponModelImplCopyWith<$Res>
    implements $GiftVoucherCouponModelCopyWith<$Res> {
  factory _$$GiftVoucherCouponModelImplCopyWith(
    _$GiftVoucherCouponModelImpl value,
    $Res Function(_$GiftVoucherCouponModelImpl) then,
  ) = __$$GiftVoucherCouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
    String? giftVoucherCouponCode,
  });
}

/// @nodoc
class __$$GiftVoucherCouponModelImplCopyWithImpl<$Res>
    extends
        _$GiftVoucherCouponModelCopyWithImpl<$Res, _$GiftVoucherCouponModelImpl>
    implements _$$GiftVoucherCouponModelImplCopyWith<$Res> {
  __$$GiftVoucherCouponModelImplCopyWithImpl(
    _$GiftVoucherCouponModelImpl _value,
    $Res Function(_$GiftVoucherCouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GiftVoucherCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? giftVoucherCouponCode = freezed}) {
    return _then(
      _$GiftVoucherCouponModelImpl(
        giftVoucherCouponCode:
            freezed == giftVoucherCouponCode
                ? _value.giftVoucherCouponCode
                : giftVoucherCouponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GiftVoucherCouponModelImpl implements _GiftVoucherCouponModel {
  _$GiftVoucherCouponModelImpl({
    @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
    this.giftVoucherCouponCode,
  });

  factory _$GiftVoucherCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftVoucherCouponModelImplFromJson(json);

  @override
  @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
  final String? giftVoucherCouponCode;

  @override
  String toString() {
    return 'GiftVoucherCouponModel(giftVoucherCouponCode: $giftVoucherCouponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftVoucherCouponModelImpl &&
            (identical(other.giftVoucherCouponCode, giftVoucherCouponCode) ||
                other.giftVoucherCouponCode == giftVoucherCouponCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, giftVoucherCouponCode);

  /// Create a copy of GiftVoucherCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftVoucherCouponModelImplCopyWith<_$GiftVoucherCouponModelImpl>
  get copyWith =>
      __$$GiftVoucherCouponModelImplCopyWithImpl<_$GiftVoucherCouponModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftVoucherCouponModelImplToJson(this);
  }
}

abstract class _GiftVoucherCouponModel implements GiftVoucherCouponModel {
  factory _GiftVoucherCouponModel({
    @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
    final String? giftVoucherCouponCode,
  }) = _$GiftVoucherCouponModelImpl;

  factory _GiftVoucherCouponModel.fromJson(Map<String, dynamic> json) =
      _$GiftVoucherCouponModelImpl.fromJson;

  @override
  @JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
  String? get giftVoucherCouponCode;

  /// Create a copy of GiftVoucherCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftVoucherCouponModelImplCopyWith<_$GiftVoucherCouponModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
