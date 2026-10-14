// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaxRate _$TaxRateFromJson(Map<String, dynamic> json) {
  return _TaxRate.fromJson(json);
}

/// @nodoc
mixin _$TaxRate {
  @JsonKey(name: 'Rate', includeIfNull: false)
  String? get rate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this TaxRate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxRateCopyWith<TaxRate> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxRateCopyWith<$Res> {
  factory $TaxRateCopyWith(TaxRate value, $Res Function(TaxRate) then) =
      _$TaxRateCopyWithImpl<$Res, TaxRate>;
  @useResult
  $Res call({
    @JsonKey(name: 'Rate', includeIfNull: false) String? rate,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$TaxRateCopyWithImpl<$Res, $Val extends TaxRate>
    implements $TaxRateCopyWith<$Res> {
  _$TaxRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rate = freezed,
    Object? value = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            rate:
                freezed == rate
                    ? _value.rate
                    : rate // ignore: cast_nullable_to_non_nullable
                        as String?,
            value:
                freezed == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TaxRateImplCopyWith<$Res> implements $TaxRateCopyWith<$Res> {
  factory _$$TaxRateImplCopyWith(
    _$TaxRateImpl value,
    $Res Function(_$TaxRateImpl) then,
  ) = __$$TaxRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Rate', includeIfNull: false) String? rate,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$TaxRateImplCopyWithImpl<$Res>
    extends _$TaxRateCopyWithImpl<$Res, _$TaxRateImpl>
    implements _$$TaxRateImplCopyWith<$Res> {
  __$$TaxRateImplCopyWithImpl(
    _$TaxRateImpl _value,
    $Res Function(_$TaxRateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rate = freezed,
    Object? value = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$TaxRateImpl(
        rate:
            freezed == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                    as String?,
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
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
class _$TaxRateImpl implements _TaxRate {
  _$TaxRateImpl({
    @JsonKey(name: 'Rate', includeIfNull: false) this.rate,
    @JsonKey(name: 'Value', includeIfNull: false) this.value,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$TaxRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxRateImplFromJson(json);

  @override
  @JsonKey(name: 'Rate', includeIfNull: false)
  final String? rate;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  final String? value;
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
    return 'TaxRate(rate: $rate, value: $value, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxRateImpl &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.value, value) || other.value == value) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rate,
    value,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxRateImplCopyWith<_$TaxRateImpl> get copyWith =>
      __$$TaxRateImplCopyWithImpl<_$TaxRateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxRateImplToJson(this);
  }
}

abstract class _TaxRate implements TaxRate {
  factory _TaxRate({
    @JsonKey(name: 'Rate', includeIfNull: false) final String? rate,
    @JsonKey(name: 'Value', includeIfNull: false) final String? value,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$TaxRateImpl;

  factory _TaxRate.fromJson(Map<String, dynamic> json) = _$TaxRateImpl.fromJson;

  @override
  @JsonKey(name: 'Rate', includeIfNull: false)
  String? get rate;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxRateImplCopyWith<_$TaxRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
