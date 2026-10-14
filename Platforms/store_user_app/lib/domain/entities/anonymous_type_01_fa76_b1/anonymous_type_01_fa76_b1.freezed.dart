// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type_01_fa76_b1.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_01FA76B1 _$AnonymousType_01FA76B1FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_01FA76B1.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_01FA76B1 {
  @JsonKey(name: 'success', includeIfNull: false)
  bool? get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'message', includeIfNull: false)
  Object? get message => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_01FA76B1 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_01FA76B1
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_01FA76B1CopyWith<AnonymousType_01FA76B1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_01FA76B1CopyWith<$Res> {
  factory $AnonymousType_01FA76B1CopyWith(
    AnonymousType_01FA76B1 value,
    $Res Function(AnonymousType_01FA76B1) then,
  ) = _$AnonymousType_01FA76B1CopyWithImpl<$Res, AnonymousType_01FA76B1>;
  @useResult
  $Res call({
    @JsonKey(name: 'success', includeIfNull: false) bool? success,
    @JsonKey(name: 'message', includeIfNull: false) Object? message,
  });
}

/// @nodoc
class _$AnonymousType_01FA76B1CopyWithImpl<
  $Res,
  $Val extends AnonymousType_01FA76B1
>
    implements $AnonymousType_01FA76B1CopyWith<$Res> {
  _$AnonymousType_01FA76B1CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_01FA76B1
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _value.copyWith(
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool?,
            message: freezed == message ? _value.message : message,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_01FA76B1ImplCopyWith<$Res>
    implements $AnonymousType_01FA76B1CopyWith<$Res> {
  factory _$$AnonymousType_01FA76B1ImplCopyWith(
    _$AnonymousType_01FA76B1Impl value,
    $Res Function(_$AnonymousType_01FA76B1Impl) then,
  ) = __$$AnonymousType_01FA76B1ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'success', includeIfNull: false) bool? success,
    @JsonKey(name: 'message', includeIfNull: false) Object? message,
  });
}

/// @nodoc
class __$$AnonymousType_01FA76B1ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_01FA76B1CopyWithImpl<$Res, _$AnonymousType_01FA76B1Impl>
    implements _$$AnonymousType_01FA76B1ImplCopyWith<$Res> {
  __$$AnonymousType_01FA76B1ImplCopyWithImpl(
    _$AnonymousType_01FA76B1Impl _value,
    $Res Function(_$AnonymousType_01FA76B1Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_01FA76B1
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _$AnonymousType_01FA76B1Impl(
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool?,
        message: freezed == message ? _value.message : message,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_01FA76B1Impl implements _AnonymousType_01FA76B1 {
  _$AnonymousType_01FA76B1Impl({
    @JsonKey(name: 'success', includeIfNull: false) this.success = false,
    @JsonKey(name: 'message', includeIfNull: false) this.message,
  });

  factory _$AnonymousType_01FA76B1Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_01FA76B1ImplFromJson(json);

  @override
  @JsonKey(name: 'success', includeIfNull: false)
  final bool? success;
  @override
  @JsonKey(name: 'message', includeIfNull: false)
  final Object? message;

  @override
  String toString() {
    return 'AnonymousType_01FA76B1(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_01FA76B1Impl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(message),
  );

  /// Create a copy of AnonymousType_01FA76B1
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_01FA76B1ImplCopyWith<_$AnonymousType_01FA76B1Impl>
  get copyWith =>
      __$$AnonymousType_01FA76B1ImplCopyWithImpl<_$AnonymousType_01FA76B1Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_01FA76B1ImplToJson(this);
  }
}

abstract class _AnonymousType_01FA76B1 implements AnonymousType_01FA76B1 {
  factory _AnonymousType_01FA76B1({
    @JsonKey(name: 'success', includeIfNull: false) final bool? success,
    @JsonKey(name: 'message', includeIfNull: false) final Object? message,
  }) = _$AnonymousType_01FA76B1Impl;

  factory _AnonymousType_01FA76B1.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_01FA76B1Impl.fromJson;

  @override
  @JsonKey(name: 'success', includeIfNull: false)
  bool? get success;
  @override
  @JsonKey(name: 'message', includeIfNull: false)
  Object? get message;

  /// Create a copy of AnonymousType_01FA76B1
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_01FA76B1ImplCopyWith<_$AnonymousType_01FA76B1Impl>
  get copyWith => throw _privateConstructorUsedError;
}
