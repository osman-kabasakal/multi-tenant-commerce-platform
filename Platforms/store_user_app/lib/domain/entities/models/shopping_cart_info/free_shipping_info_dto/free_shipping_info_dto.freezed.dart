// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_shipping_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FreeShippingInfoDto _$FreeShippingInfoDtoFromJson(Map<String, dynamic> json) {
  return _FreeShippingInfoDto.fromJson(json);
}

/// @nodoc
mixin _$FreeShippingInfoDto {
  @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
  bool? get isFreeShippingActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
  double? get minimumAmountForFreeShipping =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
  double? get remainingAmountForFreeShipping =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
  String? get freeShippingDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
  String? get freeShippingSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
  String? get formattedMinimumAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
  String? get formattedRemainingAmount => throw _privateConstructorUsedError;

  /// Serializes this FreeShippingInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FreeShippingInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FreeShippingInfoDtoCopyWith<FreeShippingInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FreeShippingInfoDtoCopyWith<$Res> {
  factory $FreeShippingInfoDtoCopyWith(
    FreeShippingInfoDto value,
    $Res Function(FreeShippingInfoDto) then,
  ) = _$FreeShippingInfoDtoCopyWithImpl<$Res, FreeShippingInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
    bool? isFreeShippingActive,
    @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
    double? minimumAmountForFreeShipping,
    @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
    double? remainingAmountForFreeShipping,
    @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
    String? freeShippingDescription,
    @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
    String? freeShippingSource,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    String? formattedRemainingAmount,
  });
}

/// @nodoc
class _$FreeShippingInfoDtoCopyWithImpl<$Res, $Val extends FreeShippingInfoDto>
    implements $FreeShippingInfoDtoCopyWith<$Res> {
  _$FreeShippingInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FreeShippingInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFreeShippingActive = freezed,
    Object? minimumAmountForFreeShipping = freezed,
    Object? remainingAmountForFreeShipping = freezed,
    Object? freeShippingDescription = freezed,
    Object? freeShippingSource = freezed,
    Object? currencyCode = freezed,
    Object? formattedMinimumAmount = freezed,
    Object? formattedRemainingAmount = freezed,
  }) {
    return _then(
      _value.copyWith(
            isFreeShippingActive:
                freezed == isFreeShippingActive
                    ? _value.isFreeShippingActive
                    : isFreeShippingActive // ignore: cast_nullable_to_non_nullable
                        as bool?,
            minimumAmountForFreeShipping:
                freezed == minimumAmountForFreeShipping
                    ? _value.minimumAmountForFreeShipping
                    : minimumAmountForFreeShipping // ignore: cast_nullable_to_non_nullable
                        as double?,
            remainingAmountForFreeShipping:
                freezed == remainingAmountForFreeShipping
                    ? _value.remainingAmountForFreeShipping
                    : remainingAmountForFreeShipping // ignore: cast_nullable_to_non_nullable
                        as double?,
            freeShippingDescription:
                freezed == freeShippingDescription
                    ? _value.freeShippingDescription
                    : freeShippingDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            freeShippingSource:
                freezed == freeShippingSource
                    ? _value.freeShippingSource
                    : freeShippingSource // ignore: cast_nullable_to_non_nullable
                        as String?,
            currencyCode:
                freezed == currencyCode
                    ? _value.currencyCode
                    : currencyCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            formattedMinimumAmount:
                freezed == formattedMinimumAmount
                    ? _value.formattedMinimumAmount
                    : formattedMinimumAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
            formattedRemainingAmount:
                freezed == formattedRemainingAmount
                    ? _value.formattedRemainingAmount
                    : formattedRemainingAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FreeShippingInfoDtoImplCopyWith<$Res>
    implements $FreeShippingInfoDtoCopyWith<$Res> {
  factory _$$FreeShippingInfoDtoImplCopyWith(
    _$FreeShippingInfoDtoImpl value,
    $Res Function(_$FreeShippingInfoDtoImpl) then,
  ) = __$$FreeShippingInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
    bool? isFreeShippingActive,
    @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
    double? minimumAmountForFreeShipping,
    @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
    double? remainingAmountForFreeShipping,
    @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
    String? freeShippingDescription,
    @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
    String? freeShippingSource,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    String? formattedRemainingAmount,
  });
}

/// @nodoc
class __$$FreeShippingInfoDtoImplCopyWithImpl<$Res>
    extends _$FreeShippingInfoDtoCopyWithImpl<$Res, _$FreeShippingInfoDtoImpl>
    implements _$$FreeShippingInfoDtoImplCopyWith<$Res> {
  __$$FreeShippingInfoDtoImplCopyWithImpl(
    _$FreeShippingInfoDtoImpl _value,
    $Res Function(_$FreeShippingInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FreeShippingInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFreeShippingActive = freezed,
    Object? minimumAmountForFreeShipping = freezed,
    Object? remainingAmountForFreeShipping = freezed,
    Object? freeShippingDescription = freezed,
    Object? freeShippingSource = freezed,
    Object? currencyCode = freezed,
    Object? formattedMinimumAmount = freezed,
    Object? formattedRemainingAmount = freezed,
  }) {
    return _then(
      _$FreeShippingInfoDtoImpl(
        isFreeShippingActive:
            freezed == isFreeShippingActive
                ? _value.isFreeShippingActive
                : isFreeShippingActive // ignore: cast_nullable_to_non_nullable
                    as bool?,
        minimumAmountForFreeShipping:
            freezed == minimumAmountForFreeShipping
                ? _value.minimumAmountForFreeShipping
                : minimumAmountForFreeShipping // ignore: cast_nullable_to_non_nullable
                    as double?,
        remainingAmountForFreeShipping:
            freezed == remainingAmountForFreeShipping
                ? _value.remainingAmountForFreeShipping
                : remainingAmountForFreeShipping // ignore: cast_nullable_to_non_nullable
                    as double?,
        freeShippingDescription:
            freezed == freeShippingDescription
                ? _value.freeShippingDescription
                : freeShippingDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        freeShippingSource:
            freezed == freeShippingSource
                ? _value.freeShippingSource
                : freeShippingSource // ignore: cast_nullable_to_non_nullable
                    as String?,
        currencyCode:
            freezed == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        formattedMinimumAmount:
            freezed == formattedMinimumAmount
                ? _value.formattedMinimumAmount
                : formattedMinimumAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
        formattedRemainingAmount:
            freezed == formattedRemainingAmount
                ? _value.formattedRemainingAmount
                : formattedRemainingAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FreeShippingInfoDtoImpl implements _FreeShippingInfoDto {
  _$FreeShippingInfoDtoImpl({
    @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
    this.isFreeShippingActive = false,
    @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
    this.minimumAmountForFreeShipping = null,
    @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
    this.remainingAmountForFreeShipping = null,
    @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
    this.freeShippingDescription,
    @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
    this.freeShippingSource,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) this.currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    this.formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    this.formattedRemainingAmount,
  });

  factory _$FreeShippingInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FreeShippingInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
  final bool? isFreeShippingActive;
  @override
  @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
  final double? minimumAmountForFreeShipping;
  @override
  @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
  final double? remainingAmountForFreeShipping;
  @override
  @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
  final String? freeShippingDescription;
  @override
  @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
  final String? freeShippingSource;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  final String? currencyCode;
  @override
  @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
  final String? formattedMinimumAmount;
  @override
  @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
  final String? formattedRemainingAmount;

  @override
  String toString() {
    return 'FreeShippingInfoDto(isFreeShippingActive: $isFreeShippingActive, minimumAmountForFreeShipping: $minimumAmountForFreeShipping, remainingAmountForFreeShipping: $remainingAmountForFreeShipping, freeShippingDescription: $freeShippingDescription, freeShippingSource: $freeShippingSource, currencyCode: $currencyCode, formattedMinimumAmount: $formattedMinimumAmount, formattedRemainingAmount: $formattedRemainingAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FreeShippingInfoDtoImpl &&
            (identical(other.isFreeShippingActive, isFreeShippingActive) ||
                other.isFreeShippingActive == isFreeShippingActive) &&
            (identical(
                  other.minimumAmountForFreeShipping,
                  minimumAmountForFreeShipping,
                ) ||
                other.minimumAmountForFreeShipping ==
                    minimumAmountForFreeShipping) &&
            (identical(
                  other.remainingAmountForFreeShipping,
                  remainingAmountForFreeShipping,
                ) ||
                other.remainingAmountForFreeShipping ==
                    remainingAmountForFreeShipping) &&
            (identical(
                  other.freeShippingDescription,
                  freeShippingDescription,
                ) ||
                other.freeShippingDescription == freeShippingDescription) &&
            (identical(other.freeShippingSource, freeShippingSource) ||
                other.freeShippingSource == freeShippingSource) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.formattedMinimumAmount, formattedMinimumAmount) ||
                other.formattedMinimumAmount == formattedMinimumAmount) &&
            (identical(
                  other.formattedRemainingAmount,
                  formattedRemainingAmount,
                ) ||
                other.formattedRemainingAmount == formattedRemainingAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isFreeShippingActive,
    minimumAmountForFreeShipping,
    remainingAmountForFreeShipping,
    freeShippingDescription,
    freeShippingSource,
    currencyCode,
    formattedMinimumAmount,
    formattedRemainingAmount,
  );

  /// Create a copy of FreeShippingInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FreeShippingInfoDtoImplCopyWith<_$FreeShippingInfoDtoImpl> get copyWith =>
      __$$FreeShippingInfoDtoImplCopyWithImpl<_$FreeShippingInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FreeShippingInfoDtoImplToJson(this);
  }
}

abstract class _FreeShippingInfoDto implements FreeShippingInfoDto {
  factory _FreeShippingInfoDto({
    @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
    final bool? isFreeShippingActive,
    @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
    final double? minimumAmountForFreeShipping,
    @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
    final double? remainingAmountForFreeShipping,
    @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
    final String? freeShippingDescription,
    @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
    final String? freeShippingSource,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
    final String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    final String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    final String? formattedRemainingAmount,
  }) = _$FreeShippingInfoDtoImpl;

  factory _FreeShippingInfoDto.fromJson(Map<String, dynamic> json) =
      _$FreeShippingInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
  bool? get isFreeShippingActive;
  @override
  @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
  double? get minimumAmountForFreeShipping;
  @override
  @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
  double? get remainingAmountForFreeShipping;
  @override
  @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
  String? get freeShippingDescription;
  @override
  @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
  String? get freeShippingSource;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode;
  @override
  @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
  String? get formattedMinimumAmount;
  @override
  @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
  String? get formattedRemainingAmount;

  /// Create a copy of FreeShippingInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FreeShippingInfoDtoImplCopyWith<_$FreeShippingInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
