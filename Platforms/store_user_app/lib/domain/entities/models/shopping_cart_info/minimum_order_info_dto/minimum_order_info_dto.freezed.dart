// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimum_order_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MinimumOrderInfoDto _$MinimumOrderInfoDtoFromJson(Map<String, dynamic> json) {
  return _MinimumOrderInfoDto.fromJson(json);
}

/// @nodoc
mixin _$MinimumOrderInfoDto {
  @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
  double? get minimumOrderAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'RemainingAmount', includeIfNull: false)
  double? get remainingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsMet', includeIfNull: false)
  bool? get isMet => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
  String? get formattedMinimumAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
  String? get formattedRemainingAmount => throw _privateConstructorUsedError;

  /// Serializes this MinimumOrderInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MinimumOrderInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MinimumOrderInfoDtoCopyWith<MinimumOrderInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinimumOrderInfoDtoCopyWith<$Res> {
  factory $MinimumOrderInfoDtoCopyWith(
    MinimumOrderInfoDto value,
    $Res Function(MinimumOrderInfoDto) then,
  ) = _$MinimumOrderInfoDtoCopyWithImpl<$Res, MinimumOrderInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
    double? minimumOrderAmount,
    @JsonKey(name: 'RemainingAmount', includeIfNull: false)
    double? remainingAmount,
    @JsonKey(name: 'IsMet', includeIfNull: false) bool? isMet,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    String? formattedRemainingAmount,
  });
}

/// @nodoc
class _$MinimumOrderInfoDtoCopyWithImpl<$Res, $Val extends MinimumOrderInfoDto>
    implements $MinimumOrderInfoDtoCopyWith<$Res> {
  _$MinimumOrderInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MinimumOrderInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumOrderAmount = freezed,
    Object? remainingAmount = freezed,
    Object? isMet = freezed,
    Object? currencyCode = freezed,
    Object? formattedMinimumAmount = freezed,
    Object? formattedRemainingAmount = freezed,
  }) {
    return _then(
      _value.copyWith(
            minimumOrderAmount:
                freezed == minimumOrderAmount
                    ? _value.minimumOrderAmount
                    : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            remainingAmount:
                freezed == remainingAmount
                    ? _value.remainingAmount
                    : remainingAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            isMet:
                freezed == isMet
                    ? _value.isMet
                    : isMet // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$MinimumOrderInfoDtoImplCopyWith<$Res>
    implements $MinimumOrderInfoDtoCopyWith<$Res> {
  factory _$$MinimumOrderInfoDtoImplCopyWith(
    _$MinimumOrderInfoDtoImpl value,
    $Res Function(_$MinimumOrderInfoDtoImpl) then,
  ) = __$$MinimumOrderInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
    double? minimumOrderAmount,
    @JsonKey(name: 'RemainingAmount', includeIfNull: false)
    double? remainingAmount,
    @JsonKey(name: 'IsMet', includeIfNull: false) bool? isMet,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    String? formattedRemainingAmount,
  });
}

/// @nodoc
class __$$MinimumOrderInfoDtoImplCopyWithImpl<$Res>
    extends _$MinimumOrderInfoDtoCopyWithImpl<$Res, _$MinimumOrderInfoDtoImpl>
    implements _$$MinimumOrderInfoDtoImplCopyWith<$Res> {
  __$$MinimumOrderInfoDtoImplCopyWithImpl(
    _$MinimumOrderInfoDtoImpl _value,
    $Res Function(_$MinimumOrderInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MinimumOrderInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumOrderAmount = freezed,
    Object? remainingAmount = freezed,
    Object? isMet = freezed,
    Object? currencyCode = freezed,
    Object? formattedMinimumAmount = freezed,
    Object? formattedRemainingAmount = freezed,
  }) {
    return _then(
      _$MinimumOrderInfoDtoImpl(
        minimumOrderAmount:
            freezed == minimumOrderAmount
                ? _value.minimumOrderAmount
                : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        remainingAmount:
            freezed == remainingAmount
                ? _value.remainingAmount
                : remainingAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        isMet:
            freezed == isMet
                ? _value.isMet
                : isMet // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$MinimumOrderInfoDtoImpl implements _MinimumOrderInfoDto {
  _$MinimumOrderInfoDtoImpl({
    @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
    this.minimumOrderAmount,
    @JsonKey(name: 'RemainingAmount', includeIfNull: false)
    this.remainingAmount,
    @JsonKey(name: 'IsMet', includeIfNull: false) this.isMet = false,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) this.currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    this.formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    this.formattedRemainingAmount,
  });

  factory _$MinimumOrderInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinimumOrderInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
  final double? minimumOrderAmount;
  @override
  @JsonKey(name: 'RemainingAmount', includeIfNull: false)
  final double? remainingAmount;
  @override
  @JsonKey(name: 'IsMet', includeIfNull: false)
  final bool? isMet;
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
    return 'MinimumOrderInfoDto(minimumOrderAmount: $minimumOrderAmount, remainingAmount: $remainingAmount, isMet: $isMet, currencyCode: $currencyCode, formattedMinimumAmount: $formattedMinimumAmount, formattedRemainingAmount: $formattedRemainingAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinimumOrderInfoDtoImpl &&
            (identical(other.minimumOrderAmount, minimumOrderAmount) ||
                other.minimumOrderAmount == minimumOrderAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.isMet, isMet) || other.isMet == isMet) &&
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
    minimumOrderAmount,
    remainingAmount,
    isMet,
    currencyCode,
    formattedMinimumAmount,
    formattedRemainingAmount,
  );

  /// Create a copy of MinimumOrderInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MinimumOrderInfoDtoImplCopyWith<_$MinimumOrderInfoDtoImpl> get copyWith =>
      __$$MinimumOrderInfoDtoImplCopyWithImpl<_$MinimumOrderInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MinimumOrderInfoDtoImplToJson(this);
  }
}

abstract class _MinimumOrderInfoDto implements MinimumOrderInfoDto {
  factory _MinimumOrderInfoDto({
    @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
    final double? minimumOrderAmount,
    @JsonKey(name: 'RemainingAmount', includeIfNull: false)
    final double? remainingAmount,
    @JsonKey(name: 'IsMet', includeIfNull: false) final bool? isMet,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
    final String? currencyCode,
    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
    final String? formattedMinimumAmount,
    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
    final String? formattedRemainingAmount,
  }) = _$MinimumOrderInfoDtoImpl;

  factory _MinimumOrderInfoDto.fromJson(Map<String, dynamic> json) =
      _$MinimumOrderInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
  double? get minimumOrderAmount;
  @override
  @JsonKey(name: 'RemainingAmount', includeIfNull: false)
  double? get remainingAmount;
  @override
  @JsonKey(name: 'IsMet', includeIfNull: false)
  bool? get isMet;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode;
  @override
  @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
  String? get formattedMinimumAmount;
  @override
  @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
  String? get formattedRemainingAmount;

  /// Create a copy of MinimumOrderInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MinimumOrderInfoDtoImplCopyWith<_$MinimumOrderInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
