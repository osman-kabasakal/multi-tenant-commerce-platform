// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscountCouponModel _$DiscountCouponModelFromJson(Map<String, dynamic> json) {
  return _DiscountCouponModel.fromJson(json);
}

/// @nodoc
mixin _$DiscountCouponModel {
  @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
  String? get discountCouponCode => throw _privateConstructorUsedError;

  /// Serializes this DiscountCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscountCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscountCouponModelCopyWith<DiscountCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountCouponModelCopyWith<$Res> {
  factory $DiscountCouponModelCopyWith(
    DiscountCouponModel value,
    $Res Function(DiscountCouponModel) then,
  ) = _$DiscountCouponModelCopyWithImpl<$Res, DiscountCouponModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
    String? discountCouponCode,
  });
}

/// @nodoc
class _$DiscountCouponModelCopyWithImpl<$Res, $Val extends DiscountCouponModel>
    implements $DiscountCouponModelCopyWith<$Res> {
  _$DiscountCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscountCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? discountCouponCode = freezed}) {
    return _then(
      _value.copyWith(
            discountCouponCode:
                freezed == discountCouponCode
                    ? _value.discountCouponCode
                    : discountCouponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscountCouponModelImplCopyWith<$Res>
    implements $DiscountCouponModelCopyWith<$Res> {
  factory _$$DiscountCouponModelImplCopyWith(
    _$DiscountCouponModelImpl value,
    $Res Function(_$DiscountCouponModelImpl) then,
  ) = __$$DiscountCouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
    String? discountCouponCode,
  });
}

/// @nodoc
class __$$DiscountCouponModelImplCopyWithImpl<$Res>
    extends _$DiscountCouponModelCopyWithImpl<$Res, _$DiscountCouponModelImpl>
    implements _$$DiscountCouponModelImplCopyWith<$Res> {
  __$$DiscountCouponModelImplCopyWithImpl(
    _$DiscountCouponModelImpl _value,
    $Res Function(_$DiscountCouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscountCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? discountCouponCode = freezed}) {
    return _then(
      _$DiscountCouponModelImpl(
        discountCouponCode:
            freezed == discountCouponCode
                ? _value.discountCouponCode
                : discountCouponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscountCouponModelImpl implements _DiscountCouponModel {
  _$DiscountCouponModelImpl({
    @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
    this.discountCouponCode,
  });

  factory _$DiscountCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscountCouponModelImplFromJson(json);

  @override
  @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
  final String? discountCouponCode;

  @override
  String toString() {
    return 'DiscountCouponModel(discountCouponCode: $discountCouponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountCouponModelImpl &&
            (identical(other.discountCouponCode, discountCouponCode) ||
                other.discountCouponCode == discountCouponCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, discountCouponCode);

  /// Create a copy of DiscountCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountCouponModelImplCopyWith<_$DiscountCouponModelImpl> get copyWith =>
      __$$DiscountCouponModelImplCopyWithImpl<_$DiscountCouponModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountCouponModelImplToJson(this);
  }
}

abstract class _DiscountCouponModel implements DiscountCouponModel {
  factory _DiscountCouponModel({
    @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
    final String? discountCouponCode,
  }) = _$DiscountCouponModelImpl;

  factory _DiscountCouponModel.fromJson(Map<String, dynamic> json) =
      _$DiscountCouponModelImpl.fromJson;

  @override
  @JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
  String? get discountCouponCode;

  /// Create a copy of DiscountCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscountCouponModelImplCopyWith<_$DiscountCouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
