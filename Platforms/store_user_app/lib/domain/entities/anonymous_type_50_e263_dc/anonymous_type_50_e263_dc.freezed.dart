// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type_50_e263_dc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_50E263DC _$AnonymousType_50E263DCFromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_50E263DC.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_50E263DC {
  @JsonKey(name: 'redirect', includeIfNull: false)
  Object? get redirect => throw _privateConstructorUsedError;
  @JsonKey(name: 'success', includeIfNull: false)
  bool? get success => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_50E263DC to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_50E263DC
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_50E263DCCopyWith<AnonymousType_50E263DC> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_50E263DCCopyWith<$Res> {
  factory $AnonymousType_50E263DCCopyWith(
    AnonymousType_50E263DC value,
    $Res Function(AnonymousType_50E263DC) then,
  ) = _$AnonymousType_50E263DCCopyWithImpl<$Res, AnonymousType_50E263DC>;
  @useResult
  $Res call({
    @JsonKey(name: 'redirect', includeIfNull: false) Object? redirect,
    @JsonKey(name: 'success', includeIfNull: false) bool? success,
  });
}

/// @nodoc
class _$AnonymousType_50E263DCCopyWithImpl<
  $Res,
  $Val extends AnonymousType_50E263DC
>
    implements $AnonymousType_50E263DCCopyWith<$Res> {
  _$AnonymousType_50E263DCCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_50E263DC
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirect = freezed, Object? success = freezed}) {
    return _then(
      _value.copyWith(
            redirect: freezed == redirect ? _value.redirect : redirect,
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_50E263DCImplCopyWith<$Res>
    implements $AnonymousType_50E263DCCopyWith<$Res> {
  factory _$$AnonymousType_50E263DCImplCopyWith(
    _$AnonymousType_50E263DCImpl value,
    $Res Function(_$AnonymousType_50E263DCImpl) then,
  ) = __$$AnonymousType_50E263DCImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'redirect', includeIfNull: false) Object? redirect,
    @JsonKey(name: 'success', includeIfNull: false) bool? success,
  });
}

/// @nodoc
class __$$AnonymousType_50E263DCImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_50E263DCCopyWithImpl<$Res, _$AnonymousType_50E263DCImpl>
    implements _$$AnonymousType_50E263DCImplCopyWith<$Res> {
  __$$AnonymousType_50E263DCImplCopyWithImpl(
    _$AnonymousType_50E263DCImpl _value,
    $Res Function(_$AnonymousType_50E263DCImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_50E263DC
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirect = freezed, Object? success = freezed}) {
    return _then(
      _$AnonymousType_50E263DCImpl(
        redirect: freezed == redirect ? _value.redirect : redirect,
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_50E263DCImpl implements _AnonymousType_50E263DC {
  _$AnonymousType_50E263DCImpl({
    @JsonKey(name: 'redirect', includeIfNull: false) this.redirect,
    @JsonKey(name: 'success', includeIfNull: false) this.success = false,
  });

  factory _$AnonymousType_50E263DCImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_50E263DCImplFromJson(json);

  @override
  @JsonKey(name: 'redirect', includeIfNull: false)
  final Object? redirect;
  @override
  @JsonKey(name: 'success', includeIfNull: false)
  final bool? success;

  @override
  String toString() {
    return 'AnonymousType_50E263DC(redirect: $redirect, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_50E263DCImpl &&
            const DeepCollectionEquality().equals(other.redirect, redirect) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(redirect),
    success,
  );

  /// Create a copy of AnonymousType_50E263DC
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_50E263DCImplCopyWith<_$AnonymousType_50E263DCImpl>
  get copyWith =>
      __$$AnonymousType_50E263DCImplCopyWithImpl<_$AnonymousType_50E263DCImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_50E263DCImplToJson(this);
  }
}

abstract class _AnonymousType_50E263DC implements AnonymousType_50E263DC {
  factory _AnonymousType_50E263DC({
    @JsonKey(name: 'redirect', includeIfNull: false) final Object? redirect,
    @JsonKey(name: 'success', includeIfNull: false) final bool? success,
  }) = _$AnonymousType_50E263DCImpl;

  factory _AnonymousType_50E263DC.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_50E263DCImpl.fromJson;

  @override
  @JsonKey(name: 'redirect', includeIfNull: false)
  Object? get redirect;
  @override
  @JsonKey(name: 'success', includeIfNull: false)
  bool? get success;

  /// Create a copy of AnonymousType_50E263DC
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_50E263DCImplCopyWith<_$AnonymousType_50E263DCImpl>
  get copyWith => throw _privateConstructorUsedError;
}
