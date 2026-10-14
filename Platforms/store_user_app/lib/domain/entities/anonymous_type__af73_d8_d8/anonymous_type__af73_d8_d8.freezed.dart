// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type__af73_d8_d8.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_AF73D8D8 _$AnonymousType_AF73D8D8FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_AF73D8D8.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_AF73D8D8 {
  @JsonKey(name: 'Available', includeIfNull: false)
  bool? get available => throw _privateConstructorUsedError;
  @JsonKey(name: 'Text', includeIfNull: false)
  Object? get text => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_AF73D8D8 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_AF73D8D8
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_AF73D8D8CopyWith<AnonymousType_AF73D8D8> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_AF73D8D8CopyWith<$Res> {
  factory $AnonymousType_AF73D8D8CopyWith(
    AnonymousType_AF73D8D8 value,
    $Res Function(AnonymousType_AF73D8D8) then,
  ) = _$AnonymousType_AF73D8D8CopyWithImpl<$Res, AnonymousType_AF73D8D8>;
  @useResult
  $Res call({
    @JsonKey(name: 'Available', includeIfNull: false) bool? available,
    @JsonKey(name: 'Text', includeIfNull: false) Object? text,
  });
}

/// @nodoc
class _$AnonymousType_AF73D8D8CopyWithImpl<
  $Res,
  $Val extends AnonymousType_AF73D8D8
>
    implements $AnonymousType_AF73D8D8CopyWith<$Res> {
  _$AnonymousType_AF73D8D8CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_AF73D8D8
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? available = freezed, Object? text = freezed}) {
    return _then(
      _value.copyWith(
            available:
                freezed == available
                    ? _value.available
                    : available // ignore: cast_nullable_to_non_nullable
                        as bool?,
            text: freezed == text ? _value.text : text,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_AF73D8D8ImplCopyWith<$Res>
    implements $AnonymousType_AF73D8D8CopyWith<$Res> {
  factory _$$AnonymousType_AF73D8D8ImplCopyWith(
    _$AnonymousType_AF73D8D8Impl value,
    $Res Function(_$AnonymousType_AF73D8D8Impl) then,
  ) = __$$AnonymousType_AF73D8D8ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Available', includeIfNull: false) bool? available,
    @JsonKey(name: 'Text', includeIfNull: false) Object? text,
  });
}

/// @nodoc
class __$$AnonymousType_AF73D8D8ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_AF73D8D8CopyWithImpl<$Res, _$AnonymousType_AF73D8D8Impl>
    implements _$$AnonymousType_AF73D8D8ImplCopyWith<$Res> {
  __$$AnonymousType_AF73D8D8ImplCopyWithImpl(
    _$AnonymousType_AF73D8D8Impl _value,
    $Res Function(_$AnonymousType_AF73D8D8Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_AF73D8D8
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? available = freezed, Object? text = freezed}) {
    return _then(
      _$AnonymousType_AF73D8D8Impl(
        available:
            freezed == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                    as bool?,
        text: freezed == text ? _value.text : text,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_AF73D8D8Impl implements _AnonymousType_AF73D8D8 {
  _$AnonymousType_AF73D8D8Impl({
    @JsonKey(name: 'Available', includeIfNull: false) this.available = false,
    @JsonKey(name: 'Text', includeIfNull: false) this.text,
  });

  factory _$AnonymousType_AF73D8D8Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_AF73D8D8ImplFromJson(json);

  @override
  @JsonKey(name: 'Available', includeIfNull: false)
  final bool? available;
  @override
  @JsonKey(name: 'Text', includeIfNull: false)
  final Object? text;

  @override
  String toString() {
    return 'AnonymousType_AF73D8D8(available: $available, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_AF73D8D8Impl &&
            (identical(other.available, available) ||
                other.available == available) &&
            const DeepCollectionEquality().equals(other.text, text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    available,
    const DeepCollectionEquality().hash(text),
  );

  /// Create a copy of AnonymousType_AF73D8D8
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_AF73D8D8ImplCopyWith<_$AnonymousType_AF73D8D8Impl>
  get copyWith =>
      __$$AnonymousType_AF73D8D8ImplCopyWithImpl<_$AnonymousType_AF73D8D8Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_AF73D8D8ImplToJson(this);
  }
}

abstract class _AnonymousType_AF73D8D8 implements AnonymousType_AF73D8D8 {
  factory _AnonymousType_AF73D8D8({
    @JsonKey(name: 'Available', includeIfNull: false) final bool? available,
    @JsonKey(name: 'Text', includeIfNull: false) final Object? text,
  }) = _$AnonymousType_AF73D8D8Impl;

  factory _AnonymousType_AF73D8D8.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_AF73D8D8Impl.fromJson;

  @override
  @JsonKey(name: 'Available', includeIfNull: false)
  bool? get available;
  @override
  @JsonKey(name: 'Text', includeIfNull: false)
  Object? get text;

  /// Create a copy of AnonymousType_AF73D8D8
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_AF73D8D8ImplCopyWith<_$AnonymousType_AF73D8D8Impl>
  get copyWith => throw _privateConstructorUsedError;
}
