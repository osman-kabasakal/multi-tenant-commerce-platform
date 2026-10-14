// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShippingOption _$ShippingOptionFromJson(Map<String, dynamic> json) {
  return _ShippingOption.fromJson(json);
}

/// @nodoc
mixin _$ShippingOption {
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  String? get shippingRateProviderSystemName =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Rate', includeIfNull: false)
  double? get rate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ShippingOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShippingOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingOptionCopyWith<ShippingOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingOptionCopyWith<$Res> {
  factory $ShippingOptionCopyWith(
    ShippingOption value,
    $Res Function(ShippingOption) then,
  ) = _$ShippingOptionCopyWithImpl<$Res, ShippingOption>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    String? shippingRateProviderSystemName,
    @JsonKey(name: 'Rate', includeIfNull: false) double? rate,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
  });
}

/// @nodoc
class _$ShippingOptionCopyWithImpl<$Res, $Val extends ShippingOption>
    implements $ShippingOptionCopyWith<$Res> {
  _$ShippingOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRateProviderSystemName = freezed,
    Object? rate = freezed,
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            shippingRateProviderSystemName:
                freezed == shippingRateProviderSystemName
                    ? _value.shippingRateProviderSystemName
                    : shippingRateProviderSystemName // ignore: cast_nullable_to_non_nullable
                        as String?,
            rate:
                freezed == rate
                    ? _value.rate
                    : rate // ignore: cast_nullable_to_non_nullable
                        as double?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShippingOptionImplCopyWith<$Res>
    implements $ShippingOptionCopyWith<$Res> {
  factory _$$ShippingOptionImplCopyWith(
    _$ShippingOptionImpl value,
    $Res Function(_$ShippingOptionImpl) then,
  ) = __$$ShippingOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    String? shippingRateProviderSystemName,
    @JsonKey(name: 'Rate', includeIfNull: false) double? rate,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
  });
}

/// @nodoc
class __$$ShippingOptionImplCopyWithImpl<$Res>
    extends _$ShippingOptionCopyWithImpl<$Res, _$ShippingOptionImpl>
    implements _$$ShippingOptionImplCopyWith<$Res> {
  __$$ShippingOptionImplCopyWithImpl(
    _$ShippingOptionImpl _value,
    $Res Function(_$ShippingOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShippingOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRateProviderSystemName = freezed,
    Object? rate = freezed,
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$ShippingOptionImpl(
        shippingRateProviderSystemName:
            freezed == shippingRateProviderSystemName
                ? _value.shippingRateProviderSystemName
                : shippingRateProviderSystemName // ignore: cast_nullable_to_non_nullable
                    as String?,
        rate:
            freezed == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                    as double?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShippingOptionImpl implements _ShippingOption {
  _$ShippingOptionImpl({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    this.shippingRateProviderSystemName,
    @JsonKey(name: 'Rate', includeIfNull: false) this.rate,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
  });

  factory _$ShippingOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShippingOptionImplFromJson(json);

  @override
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  final String? shippingRateProviderSystemName;
  @override
  @JsonKey(name: 'Rate', includeIfNull: false)
  final double? rate;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;

  @override
  String toString() {
    return 'ShippingOption(shippingRateProviderSystemName: $shippingRateProviderSystemName, rate: $rate, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingOptionImpl &&
            (identical(
                  other.shippingRateProviderSystemName,
                  shippingRateProviderSystemName,
                ) ||
                other.shippingRateProviderSystemName ==
                    shippingRateProviderSystemName) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    shippingRateProviderSystemName,
    rate,
    name,
    description,
  );

  /// Create a copy of ShippingOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingOptionImplCopyWith<_$ShippingOptionImpl> get copyWith =>
      __$$ShippingOptionImplCopyWithImpl<_$ShippingOptionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShippingOptionImplToJson(this);
  }
}

abstract class _ShippingOption implements ShippingOption {
  factory _ShippingOption({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    final String? shippingRateProviderSystemName,
    @JsonKey(name: 'Rate', includeIfNull: false) final double? rate,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
  }) = _$ShippingOptionImpl;

  factory _ShippingOption.fromJson(Map<String, dynamic> json) =
      _$ShippingOptionImpl.fromJson;

  @override
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  String? get shippingRateProviderSystemName;
  @override
  @JsonKey(name: 'Rate', includeIfNull: false)
  double? get rate;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;

  /// Create a copy of ShippingOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingOptionImplCopyWith<_$ShippingOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
