// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type__d4_a20723.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_D4A20723 _$AnonymousType_D4A20723FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_D4A20723.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_D4A20723 {
  @JsonKey(name: 'Success', includeIfNull: false)
  Object? get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  Object? get message => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_D4A20723 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_D4A20723
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_D4A20723CopyWith<AnonymousType_D4A20723> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_D4A20723CopyWith<$Res> {
  factory $AnonymousType_D4A20723CopyWith(
    AnonymousType_D4A20723 value,
    $Res Function(AnonymousType_D4A20723) then,
  ) = _$AnonymousType_D4A20723CopyWithImpl<$Res, AnonymousType_D4A20723>;
  @useResult
  $Res call({
    @JsonKey(name: 'Success', includeIfNull: false) Object? success,
    @JsonKey(name: 'Message', includeIfNull: false) Object? message,
  });
}

/// @nodoc
class _$AnonymousType_D4A20723CopyWithImpl<
  $Res,
  $Val extends AnonymousType_D4A20723
>
    implements $AnonymousType_D4A20723CopyWith<$Res> {
  _$AnonymousType_D4A20723CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_D4A20723
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _value.copyWith(
            success: freezed == success ? _value.success : success,
            message: freezed == message ? _value.message : message,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_D4A20723ImplCopyWith<$Res>
    implements $AnonymousType_D4A20723CopyWith<$Res> {
  factory _$$AnonymousType_D4A20723ImplCopyWith(
    _$AnonymousType_D4A20723Impl value,
    $Res Function(_$AnonymousType_D4A20723Impl) then,
  ) = __$$AnonymousType_D4A20723ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Success', includeIfNull: false) Object? success,
    @JsonKey(name: 'Message', includeIfNull: false) Object? message,
  });
}

/// @nodoc
class __$$AnonymousType_D4A20723ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_D4A20723CopyWithImpl<$Res, _$AnonymousType_D4A20723Impl>
    implements _$$AnonymousType_D4A20723ImplCopyWith<$Res> {
  __$$AnonymousType_D4A20723ImplCopyWithImpl(
    _$AnonymousType_D4A20723Impl _value,
    $Res Function(_$AnonymousType_D4A20723Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_D4A20723
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _$AnonymousType_D4A20723Impl(
        success: freezed == success ? _value.success : success,
        message: freezed == message ? _value.message : message,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_D4A20723Impl implements _AnonymousType_D4A20723 {
  _$AnonymousType_D4A20723Impl({
    @JsonKey(name: 'Success', includeIfNull: false) this.success,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
  });

  factory _$AnonymousType_D4A20723Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_D4A20723ImplFromJson(json);

  @override
  @JsonKey(name: 'Success', includeIfNull: false)
  final Object? success;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final Object? message;

  @override
  String toString() {
    return 'AnonymousType_D4A20723(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_D4A20723Impl &&
            const DeepCollectionEquality().equals(other.success, success) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(success),
    const DeepCollectionEquality().hash(message),
  );

  /// Create a copy of AnonymousType_D4A20723
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_D4A20723ImplCopyWith<_$AnonymousType_D4A20723Impl>
  get copyWith =>
      __$$AnonymousType_D4A20723ImplCopyWithImpl<_$AnonymousType_D4A20723Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_D4A20723ImplToJson(this);
  }
}

abstract class _AnonymousType_D4A20723 implements AnonymousType_D4A20723 {
  factory _AnonymousType_D4A20723({
    @JsonKey(name: 'Success', includeIfNull: false) final Object? success,
    @JsonKey(name: 'Message', includeIfNull: false) final Object? message,
  }) = _$AnonymousType_D4A20723Impl;

  factory _AnonymousType_D4A20723.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_D4A20723Impl.fromJson;

  @override
  @JsonKey(name: 'Success', includeIfNull: false)
  Object? get success;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  Object? get message;

  /// Create a copy of AnonymousType_D4A20723
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_D4A20723ImplCopyWith<_$AnonymousType_D4A20723Impl>
  get copyWith => throw _privateConstructorUsedError;
}
