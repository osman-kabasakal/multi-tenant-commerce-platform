// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_height_webview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AutoHeightWebviewModel {
  double get height => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Set<Factory<OneSequenceGestureRecognizer>> get gestureRecognizers =>
      throw _privateConstructorUsedError;

  /// Create a copy of AutoHeightWebviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoHeightWebviewModelCopyWith<AutoHeightWebviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoHeightWebviewModelCopyWith<$Res> {
  factory $AutoHeightWebviewModelCopyWith(
    AutoHeightWebviewModel value,
    $Res Function(AutoHeightWebviewModel) then,
  ) = _$AutoHeightWebviewModelCopyWithImpl<$Res, AutoHeightWebviewModel>;
  @useResult
  $Res call({
    double height,
    bool isLoading,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  });
}

/// @nodoc
class _$AutoHeightWebviewModelCopyWithImpl<
  $Res,
  $Val extends AutoHeightWebviewModel
>
    implements $AutoHeightWebviewModelCopyWith<$Res> {
  _$AutoHeightWebviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoHeightWebviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? isLoading = null,
    Object? gestureRecognizers = null,
  }) {
    return _then(
      _value.copyWith(
            height:
                null == height
                    ? _value.height
                    : height // ignore: cast_nullable_to_non_nullable
                        as double,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            gestureRecognizers:
                null == gestureRecognizers
                    ? _value.gestureRecognizers
                    : gestureRecognizers // ignore: cast_nullable_to_non_nullable
                        as Set<Factory<OneSequenceGestureRecognizer>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AutoHeightWebviewModelImplCopyWith<$Res>
    implements $AutoHeightWebviewModelCopyWith<$Res> {
  factory _$$AutoHeightWebviewModelImplCopyWith(
    _$AutoHeightWebviewModelImpl value,
    $Res Function(_$AutoHeightWebviewModelImpl) then,
  ) = __$$AutoHeightWebviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double height,
    bool isLoading,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  });
}

/// @nodoc
class __$$AutoHeightWebviewModelImplCopyWithImpl<$Res>
    extends
        _$AutoHeightWebviewModelCopyWithImpl<$Res, _$AutoHeightWebviewModelImpl>
    implements _$$AutoHeightWebviewModelImplCopyWith<$Res> {
  __$$AutoHeightWebviewModelImplCopyWithImpl(
    _$AutoHeightWebviewModelImpl _value,
    $Res Function(_$AutoHeightWebviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AutoHeightWebviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? isLoading = null,
    Object? gestureRecognizers = null,
  }) {
    return _then(
      _$AutoHeightWebviewModelImpl(
        height:
            null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                    as double,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        gestureRecognizers:
            null == gestureRecognizers
                ? _value._gestureRecognizers
                : gestureRecognizers // ignore: cast_nullable_to_non_nullable
                    as Set<Factory<OneSequenceGestureRecognizer>>,
      ),
    );
  }
}

/// @nodoc

class _$AutoHeightWebviewModelImpl
    with DiagnosticableTreeMixin
    implements _AutoHeightWebviewModel {
  const _$AutoHeightWebviewModelImpl({
    this.height = 1,
    this.isLoading = true,
    required final Set<Factory<OneSequenceGestureRecognizer>>
    gestureRecognizers,
  }) : _gestureRecognizers = gestureRecognizers;

  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final bool isLoading;
  final Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers;
  @override
  Set<Factory<OneSequenceGestureRecognizer>> get gestureRecognizers {
    if (_gestureRecognizers is EqualUnmodifiableSetView)
      return _gestureRecognizers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_gestureRecognizers);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AutoHeightWebviewModel(height: $height, isLoading: $isLoading, gestureRecognizers: $gestureRecognizers)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AutoHeightWebviewModel'))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('gestureRecognizers', gestureRecognizers));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoHeightWebviewModelImpl &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._gestureRecognizers,
              _gestureRecognizers,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    height,
    isLoading,
    const DeepCollectionEquality().hash(_gestureRecognizers),
  );

  /// Create a copy of AutoHeightWebviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoHeightWebviewModelImplCopyWith<_$AutoHeightWebviewModelImpl>
  get copyWith =>
      __$$AutoHeightWebviewModelImplCopyWithImpl<_$AutoHeightWebviewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _AutoHeightWebviewModel implements AutoHeightWebviewModel {
  const factory _AutoHeightWebviewModel({
    final double height,
    final bool isLoading,
    required final Set<Factory<OneSequenceGestureRecognizer>>
    gestureRecognizers,
  }) = _$AutoHeightWebviewModelImpl;

  @override
  double get height;
  @override
  bool get isLoading;
  @override
  Set<Factory<OneSequenceGestureRecognizer>> get gestureRecognizers;

  /// Create a copy of AutoHeightWebviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoHeightWebviewModelImplCopyWith<_$AutoHeightWebviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
