// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_attribute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomAttribute _$CustomAttributeFromJson(Map<String, dynamic> json) {
  return _CustomAttribute.fromJson(json);
}

/// @nodoc
mixin _$CustomAttribute {
  @JsonKey(name: 'Key', includeIfNull: false)
  String? get key => throw _privateConstructorUsedError;
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value => throw _privateConstructorUsedError;

  /// Serializes this CustomAttribute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomAttribute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomAttributeCopyWith<CustomAttribute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomAttributeCopyWith<$Res> {
  factory $CustomAttributeCopyWith(
    CustomAttribute value,
    $Res Function(CustomAttribute) then,
  ) = _$CustomAttributeCopyWithImpl<$Res, CustomAttribute>;
  @useResult
  $Res call({
    @JsonKey(name: 'Key', includeIfNull: false) String? key,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });
}

/// @nodoc
class _$CustomAttributeCopyWithImpl<$Res, $Val extends CustomAttribute>
    implements $CustomAttributeCopyWith<$Res> {
  _$CustomAttributeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomAttribute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = freezed, Object? value = freezed}) {
    return _then(
      _value.copyWith(
            key:
                freezed == key
                    ? _value.key
                    : key // ignore: cast_nullable_to_non_nullable
                        as String?,
            value:
                freezed == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomAttributeImplCopyWith<$Res>
    implements $CustomAttributeCopyWith<$Res> {
  factory _$$CustomAttributeImplCopyWith(
    _$CustomAttributeImpl value,
    $Res Function(_$CustomAttributeImpl) then,
  ) = __$$CustomAttributeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Key', includeIfNull: false) String? key,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });
}

/// @nodoc
class __$$CustomAttributeImplCopyWithImpl<$Res>
    extends _$CustomAttributeCopyWithImpl<$Res, _$CustomAttributeImpl>
    implements _$$CustomAttributeImplCopyWith<$Res> {
  __$$CustomAttributeImplCopyWithImpl(
    _$CustomAttributeImpl _value,
    $Res Function(_$CustomAttributeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomAttribute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = freezed, Object? value = freezed}) {
    return _then(
      _$CustomAttributeImpl(
        key:
            freezed == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                    as String?,
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomAttributeImpl implements _CustomAttribute {
  _$CustomAttributeImpl({
    @JsonKey(name: 'Key', includeIfNull: false) this.key,
    @JsonKey(name: 'Value', includeIfNull: false) this.value,
  });

  factory _$CustomAttributeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomAttributeImplFromJson(json);

  @override
  @JsonKey(name: 'Key', includeIfNull: false)
  final String? key;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  final String? value;

  @override
  String toString() {
    return 'CustomAttribute(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomAttributeImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  /// Create a copy of CustomAttribute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomAttributeImplCopyWith<_$CustomAttributeImpl> get copyWith =>
      __$$CustomAttributeImplCopyWithImpl<_$CustomAttributeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomAttributeImplToJson(this);
  }
}

abstract class _CustomAttribute implements CustomAttribute {
  factory _CustomAttribute({
    @JsonKey(name: 'Key', includeIfNull: false) final String? key,
    @JsonKey(name: 'Value', includeIfNull: false) final String? value,
  }) = _$CustomAttributeImpl;

  factory _CustomAttribute.fromJson(Map<String, dynamic> json) =
      _$CustomAttributeImpl.fromJson;

  @override
  @JsonKey(name: 'Key', includeIfNull: false)
  String? get key;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value;

  /// Create a copy of CustomAttribute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomAttributeImplCopyWith<_$CustomAttributeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
