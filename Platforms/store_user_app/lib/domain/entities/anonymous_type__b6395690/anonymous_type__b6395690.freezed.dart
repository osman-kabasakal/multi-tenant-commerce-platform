// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type__b6395690.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_B6395690 _$AnonymousType_B6395690FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_B6395690.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_B6395690 {
  @JsonKey(name: 'stored', includeIfNull: false)
  bool? get stored => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_B6395690 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_B6395690
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_B6395690CopyWith<AnonymousType_B6395690> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_B6395690CopyWith<$Res> {
  factory $AnonymousType_B6395690CopyWith(
    AnonymousType_B6395690 value,
    $Res Function(AnonymousType_B6395690) then,
  ) = _$AnonymousType_B6395690CopyWithImpl<$Res, AnonymousType_B6395690>;
  @useResult
  $Res call({@JsonKey(name: 'stored', includeIfNull: false) bool? stored});
}

/// @nodoc
class _$AnonymousType_B6395690CopyWithImpl<
  $Res,
  $Val extends AnonymousType_B6395690
>
    implements $AnonymousType_B6395690CopyWith<$Res> {
  _$AnonymousType_B6395690CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_B6395690
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stored = freezed}) {
    return _then(
      _value.copyWith(
            stored:
                freezed == stored
                    ? _value.stored
                    : stored // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousType_B6395690ImplCopyWith<$Res>
    implements $AnonymousType_B6395690CopyWith<$Res> {
  factory _$$AnonymousType_B6395690ImplCopyWith(
    _$AnonymousType_B6395690Impl value,
    $Res Function(_$AnonymousType_B6395690Impl) then,
  ) = __$$AnonymousType_B6395690ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'stored', includeIfNull: false) bool? stored});
}

/// @nodoc
class __$$AnonymousType_B6395690ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_B6395690CopyWithImpl<$Res, _$AnonymousType_B6395690Impl>
    implements _$$AnonymousType_B6395690ImplCopyWith<$Res> {
  __$$AnonymousType_B6395690ImplCopyWithImpl(
    _$AnonymousType_B6395690Impl _value,
    $Res Function(_$AnonymousType_B6395690Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_B6395690
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stored = freezed}) {
    return _then(
      _$AnonymousType_B6395690Impl(
        stored:
            freezed == stored
                ? _value.stored
                : stored // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_B6395690Impl implements _AnonymousType_B6395690 {
  _$AnonymousType_B6395690Impl({
    @JsonKey(name: 'stored', includeIfNull: false) this.stored = false,
  });

  factory _$AnonymousType_B6395690Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_B6395690ImplFromJson(json);

  @override
  @JsonKey(name: 'stored', includeIfNull: false)
  final bool? stored;

  @override
  String toString() {
    return 'AnonymousType_B6395690(stored: $stored)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_B6395690Impl &&
            (identical(other.stored, stored) || other.stored == stored));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stored);

  /// Create a copy of AnonymousType_B6395690
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_B6395690ImplCopyWith<_$AnonymousType_B6395690Impl>
  get copyWith =>
      __$$AnonymousType_B6395690ImplCopyWithImpl<_$AnonymousType_B6395690Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_B6395690ImplToJson(this);
  }
}

abstract class _AnonymousType_B6395690 implements AnonymousType_B6395690 {
  factory _AnonymousType_B6395690({
    @JsonKey(name: 'stored', includeIfNull: false) final bool? stored,
  }) = _$AnonymousType_B6395690Impl;

  factory _AnonymousType_B6395690.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_B6395690Impl.fromJson;

  @override
  @JsonKey(name: 'stored', includeIfNull: false)
  bool? get stored;

  /// Create a copy of AnonymousType_B6395690
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_B6395690ImplCopyWith<_$AnonymousType_B6395690Impl>
  get copyWith => throw _privateConstructorUsedError;
}
