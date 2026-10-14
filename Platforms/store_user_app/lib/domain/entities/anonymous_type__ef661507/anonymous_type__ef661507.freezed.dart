// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type__ef661507.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_EF661507 _$AnonymousType_EF661507FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_EF661507.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_EF661507 {
  @JsonKey(name: 'model', includeIfNull: false)
  ShoppingCartModel? get model => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_EF661507 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_EF661507CopyWith<AnonymousType_EF661507> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_EF661507CopyWith<$Res> {
  factory $AnonymousType_EF661507CopyWith(
    AnonymousType_EF661507 value,
    $Res Function(AnonymousType_EF661507) then,
  ) = _$AnonymousType_EF661507CopyWithImpl<$Res, AnonymousType_EF661507>;
  @useResult
  $Res call({
    @JsonKey(name: 'model', includeIfNull: false) ShoppingCartModel? model,
  });

  $ShoppingCartModelCopyWith<$Res>? get model;
}

/// @nodoc
class _$AnonymousType_EF661507CopyWithImpl<
  $Res,
  $Val extends AnonymousType_EF661507
>
    implements $AnonymousType_EF661507CopyWith<$Res> {
  _$AnonymousType_EF661507CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? model = freezed}) {
    return _then(
      _value.copyWith(
            model:
                freezed == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShoppingCartModelCopyWith<$Res>? get model {
    if (_value.model == null) {
      return null;
    }

    return $ShoppingCartModelCopyWith<$Res>(_value.model!, (value) {
      return _then(_value.copyWith(model: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnonymousType_EF661507ImplCopyWith<$Res>
    implements $AnonymousType_EF661507CopyWith<$Res> {
  factory _$$AnonymousType_EF661507ImplCopyWith(
    _$AnonymousType_EF661507Impl value,
    $Res Function(_$AnonymousType_EF661507Impl) then,
  ) = __$$AnonymousType_EF661507ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'model', includeIfNull: false) ShoppingCartModel? model,
  });

  @override
  $ShoppingCartModelCopyWith<$Res>? get model;
}

/// @nodoc
class __$$AnonymousType_EF661507ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_EF661507CopyWithImpl<$Res, _$AnonymousType_EF661507Impl>
    implements _$$AnonymousType_EF661507ImplCopyWith<$Res> {
  __$$AnonymousType_EF661507ImplCopyWithImpl(
    _$AnonymousType_EF661507Impl _value,
    $Res Function(_$AnonymousType_EF661507Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? model = freezed}) {
    return _then(
      _$AnonymousType_EF661507Impl(
        model:
            freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_EF661507Impl implements _AnonymousType_EF661507 {
  _$AnonymousType_EF661507Impl({
    @JsonKey(name: 'model', includeIfNull: false) this.model,
  });

  factory _$AnonymousType_EF661507Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_EF661507ImplFromJson(json);

  @override
  @JsonKey(name: 'model', includeIfNull: false)
  final ShoppingCartModel? model;

  @override
  String toString() {
    return 'AnonymousType_EF661507(model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_EF661507Impl &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, model);

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_EF661507ImplCopyWith<_$AnonymousType_EF661507Impl>
  get copyWith =>
      __$$AnonymousType_EF661507ImplCopyWithImpl<_$AnonymousType_EF661507Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_EF661507ImplToJson(this);
  }
}

abstract class _AnonymousType_EF661507 implements AnonymousType_EF661507 {
  factory _AnonymousType_EF661507({
    @JsonKey(name: 'model', includeIfNull: false)
    final ShoppingCartModel? model,
  }) = _$AnonymousType_EF661507Impl;

  factory _AnonymousType_EF661507.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_EF661507Impl.fromJson;

  @override
  @JsonKey(name: 'model', includeIfNull: false)
  ShoppingCartModel? get model;

  /// Create a copy of AnonymousType_EF661507
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_EF661507ImplCopyWith<_$AnonymousType_EF661507Impl>
  get copyWith => throw _privateConstructorUsedError;
}
