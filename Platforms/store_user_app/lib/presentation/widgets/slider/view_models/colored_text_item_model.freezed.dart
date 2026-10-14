// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'colored_text_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ColoredTextItemModel {
  String get text => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  /// Create a copy of ColoredTextItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColoredTextItemModelCopyWith<ColoredTextItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColoredTextItemModelCopyWith<$Res> {
  factory $ColoredTextItemModelCopyWith(
    ColoredTextItemModel value,
    $Res Function(ColoredTextItemModel) then,
  ) = _$ColoredTextItemModelCopyWithImpl<$Res, ColoredTextItemModel>;
  @useResult
  $Res call({String text, Color color});
}

/// @nodoc
class _$ColoredTextItemModelCopyWithImpl<
  $Res,
  $Val extends ColoredTextItemModel
>
    implements $ColoredTextItemModelCopyWith<$Res> {
  _$ColoredTextItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColoredTextItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? color = null}) {
    return _then(
      _value.copyWith(
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as Color,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ColoredTextItemModelImplCopyWith<$Res>
    implements $ColoredTextItemModelCopyWith<$Res> {
  factory _$$ColoredTextItemModelImplCopyWith(
    _$ColoredTextItemModelImpl value,
    $Res Function(_$ColoredTextItemModelImpl) then,
  ) = __$$ColoredTextItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, Color color});
}

/// @nodoc
class __$$ColoredTextItemModelImplCopyWithImpl<$Res>
    extends _$ColoredTextItemModelCopyWithImpl<$Res, _$ColoredTextItemModelImpl>
    implements _$$ColoredTextItemModelImplCopyWith<$Res> {
  __$$ColoredTextItemModelImplCopyWithImpl(
    _$ColoredTextItemModelImpl _value,
    $Res Function(_$ColoredTextItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ColoredTextItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? color = null}) {
    return _then(
      _$ColoredTextItemModelImpl(
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as Color,
      ),
    );
  }
}

/// @nodoc

class _$ColoredTextItemModelImpl implements _ColoredTextItemModel {
  const _$ColoredTextItemModelImpl({required this.text, required this.color});

  @override
  final String text;
  @override
  final Color color;

  @override
  String toString() {
    return 'ColoredTextItemModel(text: $text, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColoredTextItemModelImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, color);

  /// Create a copy of ColoredTextItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColoredTextItemModelImplCopyWith<_$ColoredTextItemModelImpl>
  get copyWith =>
      __$$ColoredTextItemModelImplCopyWithImpl<_$ColoredTextItemModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ColoredTextItemModel implements ColoredTextItemModel {
  const factory _ColoredTextItemModel({
    required final String text,
    required final Color color,
  }) = _$ColoredTextItemModelImpl;

  @override
  String get text;
  @override
  Color get color;

  /// Create a copy of ColoredTextItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColoredTextItemModelImplCopyWith<_$ColoredTextItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
