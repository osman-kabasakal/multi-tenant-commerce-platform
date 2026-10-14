// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type_10783450.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_10783450 _$AnonymousType_10783450FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_10783450.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_10783450 {
  @JsonKey(name: 'Authenticated', includeIfNull: false)
  bool? get authenticated => throw _privateConstructorUsedError;
  @JsonKey(name: 'Error', includeIfNull: false)
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_10783450 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_10783450
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_10783450CopyWith<AnonymousType_10783450> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_10783450CopyWith<$Res> {
  factory $AnonymousType_10783450CopyWith(
    AnonymousType_10783450 value,
    $Res Function(AnonymousType_10783450) then,
  ) = _$AnonymousType_10783450CopyWithImpl<$Res, AnonymousType_10783450>;
  @useResult
  $Res call({
    @JsonKey(name: 'Authenticated', includeIfNull: false) bool? authenticated,
    @JsonKey(name: 'Error', includeIfNull: false) String? error,
  });
}

/// @nodoc
class _$AnonymousType_10783450CopyWithImpl<
  $Res,
  $Val extends AnonymousType_10783450
>
    implements $AnonymousType_10783450CopyWith<$Res> {
  _$AnonymousType_10783450CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_10783450
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? authenticated = freezed, Object? error = freezed}) {
    return _then(
      _value.copyWith(
            authenticated:
                freezed == authenticated
                    ? _value.authenticated
                    : authenticated // ignore: cast_nullable_to_non_nullable
                        as bool?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_10783450ImplCopyWith<$Res>
    implements $AnonymousType_10783450CopyWith<$Res> {
  factory _$$AnonymousType_10783450ImplCopyWith(
    _$AnonymousType_10783450Impl value,
    $Res Function(_$AnonymousType_10783450Impl) then,
  ) = __$$AnonymousType_10783450ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Authenticated', includeIfNull: false) bool? authenticated,
    @JsonKey(name: 'Error', includeIfNull: false) String? error,
  });
}

/// @nodoc
class __$$AnonymousType_10783450ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_10783450CopyWithImpl<$Res, _$AnonymousType_10783450Impl>
    implements _$$AnonymousType_10783450ImplCopyWith<$Res> {
  __$$AnonymousType_10783450ImplCopyWithImpl(
    _$AnonymousType_10783450Impl _value,
    $Res Function(_$AnonymousType_10783450Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_10783450
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? authenticated = freezed, Object? error = freezed}) {
    return _then(
      _$AnonymousType_10783450Impl(
        authenticated:
            freezed == authenticated
                ? _value.authenticated
                : authenticated // ignore: cast_nullable_to_non_nullable
                    as bool?,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_10783450Impl implements _AnonymousType_10783450 {
  _$AnonymousType_10783450Impl({
    @JsonKey(name: 'Authenticated', includeIfNull: false)
    this.authenticated = false,
    @JsonKey(name: 'Error', includeIfNull: false) this.error,
  });

  factory _$AnonymousType_10783450Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_10783450ImplFromJson(json);

  @override
  @JsonKey(name: 'Authenticated', includeIfNull: false)
  final bool? authenticated;
  @override
  @JsonKey(name: 'Error', includeIfNull: false)
  final String? error;

  @override
  String toString() {
    return 'AnonymousType_10783450(authenticated: $authenticated, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_10783450Impl &&
            (identical(other.authenticated, authenticated) ||
                other.authenticated == authenticated) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, authenticated, error);

  /// Create a copy of AnonymousType_10783450
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_10783450ImplCopyWith<_$AnonymousType_10783450Impl>
  get copyWith =>
      __$$AnonymousType_10783450ImplCopyWithImpl<_$AnonymousType_10783450Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_10783450ImplToJson(this);
  }
}

abstract class _AnonymousType_10783450 implements AnonymousType_10783450 {
  factory _AnonymousType_10783450({
    @JsonKey(name: 'Authenticated', includeIfNull: false)
    final bool? authenticated,
    @JsonKey(name: 'Error', includeIfNull: false) final String? error,
  }) = _$AnonymousType_10783450Impl;

  factory _AnonymousType_10783450.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_10783450Impl.fromJson;

  @override
  @JsonKey(name: 'Authenticated', includeIfNull: false)
  bool? get authenticated;
  @override
  @JsonKey(name: 'Error', includeIfNull: false)
  String? get error;

  /// Create a copy of AnonymousType_10783450
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_10783450ImplCopyWith<_$AnonymousType_10783450Impl>
  get copyWith => throw _privateConstructorUsedError;
}
