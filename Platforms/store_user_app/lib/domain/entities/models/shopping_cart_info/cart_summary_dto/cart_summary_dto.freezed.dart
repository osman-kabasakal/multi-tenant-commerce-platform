// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartSummaryDto _$CartSummaryDtoFromJson(Map<String, dynamic> json) {
  return _CartSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$CartSummaryDto {
  @JsonKey(name: 'Subtotal', includeIfNull: false)
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
  String? get formattedSubtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'ItemCount', includeIfNull: false)
  int? get itemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode => throw _privateConstructorUsedError;

  /// Serializes this CartSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartSummaryDtoCopyWith<CartSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartSummaryDtoCopyWith<$Res> {
  factory $CartSummaryDtoCopyWith(
    CartSummaryDto value,
    $Res Function(CartSummaryDto) then,
  ) = _$CartSummaryDtoCopyWithImpl<$Res, CartSummaryDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'Subtotal', includeIfNull: false) double? subtotal,
    @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
    String? formattedSubtotal,
    @JsonKey(name: 'ItemCount', includeIfNull: false) int? itemCount,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
  });
}

/// @nodoc
class _$CartSummaryDtoCopyWithImpl<$Res, $Val extends CartSummaryDto>
    implements $CartSummaryDtoCopyWith<$Res> {
  _$CartSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = freezed,
    Object? formattedSubtotal = freezed,
    Object? itemCount = freezed,
    Object? currencyCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            subtotal:
                freezed == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double?,
            formattedSubtotal:
                freezed == formattedSubtotal
                    ? _value.formattedSubtotal
                    : formattedSubtotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemCount:
                freezed == itemCount
                    ? _value.itemCount
                    : itemCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            currencyCode:
                freezed == currencyCode
                    ? _value.currencyCode
                    : currencyCode // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartSummaryDtoImplCopyWith<$Res>
    implements $CartSummaryDtoCopyWith<$Res> {
  factory _$$CartSummaryDtoImplCopyWith(
    _$CartSummaryDtoImpl value,
    $Res Function(_$CartSummaryDtoImpl) then,
  ) = __$$CartSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Subtotal', includeIfNull: false) double? subtotal,
    @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
    String? formattedSubtotal,
    @JsonKey(name: 'ItemCount', includeIfNull: false) int? itemCount,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
  });
}

/// @nodoc
class __$$CartSummaryDtoImplCopyWithImpl<$Res>
    extends _$CartSummaryDtoCopyWithImpl<$Res, _$CartSummaryDtoImpl>
    implements _$$CartSummaryDtoImplCopyWith<$Res> {
  __$$CartSummaryDtoImplCopyWithImpl(
    _$CartSummaryDtoImpl _value,
    $Res Function(_$CartSummaryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = freezed,
    Object? formattedSubtotal = freezed,
    Object? itemCount = freezed,
    Object? currencyCode = freezed,
  }) {
    return _then(
      _$CartSummaryDtoImpl(
        subtotal:
            freezed == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double?,
        formattedSubtotal:
            freezed == formattedSubtotal
                ? _value.formattedSubtotal
                : formattedSubtotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemCount:
            freezed == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        currencyCode:
            freezed == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartSummaryDtoImpl implements _CartSummaryDto {
  _$CartSummaryDtoImpl({
    @JsonKey(name: 'Subtotal', includeIfNull: false) this.subtotal,
    @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
    this.formattedSubtotal,
    @JsonKey(name: 'ItemCount', includeIfNull: false) this.itemCount,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) this.currencyCode,
  });

  factory _$CartSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartSummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'Subtotal', includeIfNull: false)
  final double? subtotal;
  @override
  @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
  final String? formattedSubtotal;
  @override
  @JsonKey(name: 'ItemCount', includeIfNull: false)
  final int? itemCount;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  final String? currencyCode;

  @override
  String toString() {
    return 'CartSummaryDto(subtotal: $subtotal, formattedSubtotal: $formattedSubtotal, itemCount: $itemCount, currencyCode: $currencyCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartSummaryDtoImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.formattedSubtotal, formattedSubtotal) ||
                other.formattedSubtotal == formattedSubtotal) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    subtotal,
    formattedSubtotal,
    itemCount,
    currencyCode,
  );

  /// Create a copy of CartSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartSummaryDtoImplCopyWith<_$CartSummaryDtoImpl> get copyWith =>
      __$$CartSummaryDtoImplCopyWithImpl<_$CartSummaryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CartSummaryDtoImplToJson(this);
  }
}

abstract class _CartSummaryDto implements CartSummaryDto {
  factory _CartSummaryDto({
    @JsonKey(name: 'Subtotal', includeIfNull: false) final double? subtotal,
    @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
    final String? formattedSubtotal,
    @JsonKey(name: 'ItemCount', includeIfNull: false) final int? itemCount,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
    final String? currencyCode,
  }) = _$CartSummaryDtoImpl;

  factory _CartSummaryDto.fromJson(Map<String, dynamic> json) =
      _$CartSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'Subtotal', includeIfNull: false)
  double? get subtotal;
  @override
  @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
  String? get formattedSubtotal;
  @override
  @JsonKey(name: 'ItemCount', includeIfNull: false)
  int? get itemCount;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode;

  /// Create a copy of CartSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartSummaryDtoImplCopyWith<_$CartSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
