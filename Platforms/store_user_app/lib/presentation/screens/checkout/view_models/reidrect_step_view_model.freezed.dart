// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reidrect_step_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RedirectStepViewModel {
  WebViewController get webviewController => throw _privateConstructorUsedError;

  /// Create a copy of RedirectStepViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedirectStepViewModelCopyWith<RedirectStepViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedirectStepViewModelCopyWith<$Res> {
  factory $RedirectStepViewModelCopyWith(
    RedirectStepViewModel value,
    $Res Function(RedirectStepViewModel) then,
  ) = _$RedirectStepViewModelCopyWithImpl<$Res, RedirectStepViewModel>;
  @useResult
  $Res call({WebViewController webviewController});
}

/// @nodoc
class _$RedirectStepViewModelCopyWithImpl<
  $Res,
  $Val extends RedirectStepViewModel
>
    implements $RedirectStepViewModelCopyWith<$Res> {
  _$RedirectStepViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedirectStepViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? webviewController = null}) {
    return _then(
      _value.copyWith(
            webviewController:
                null == webviewController
                    ? _value.webviewController
                    : webviewController // ignore: cast_nullable_to_non_nullable
                        as WebViewController,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RedirectStepViewModelImplCopyWith<$Res>
    implements $RedirectStepViewModelCopyWith<$Res> {
  factory _$$RedirectStepViewModelImplCopyWith(
    _$RedirectStepViewModelImpl value,
    $Res Function(_$RedirectStepViewModelImpl) then,
  ) = __$$RedirectStepViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WebViewController webviewController});
}

/// @nodoc
class __$$RedirectStepViewModelImplCopyWithImpl<$Res>
    extends
        _$RedirectStepViewModelCopyWithImpl<$Res, _$RedirectStepViewModelImpl>
    implements _$$RedirectStepViewModelImplCopyWith<$Res> {
  __$$RedirectStepViewModelImplCopyWithImpl(
    _$RedirectStepViewModelImpl _value,
    $Res Function(_$RedirectStepViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedirectStepViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? webviewController = null}) {
    return _then(
      _$RedirectStepViewModelImpl(
        webviewController:
            null == webviewController
                ? _value.webviewController
                : webviewController // ignore: cast_nullable_to_non_nullable
                    as WebViewController,
      ),
    );
  }
}

/// @nodoc

class _$RedirectStepViewModelImpl implements _RedirectStepViewModel {
  const _$RedirectStepViewModelImpl({required this.webviewController});

  @override
  final WebViewController webviewController;

  @override
  String toString() {
    return 'RedirectStepViewModel(webviewController: $webviewController)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedirectStepViewModelImpl &&
            (identical(other.webviewController, webviewController) ||
                other.webviewController == webviewController));
  }

  @override
  int get hashCode => Object.hash(runtimeType, webviewController);

  /// Create a copy of RedirectStepViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedirectStepViewModelImplCopyWith<_$RedirectStepViewModelImpl>
  get copyWith =>
      __$$RedirectStepViewModelImplCopyWithImpl<_$RedirectStepViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _RedirectStepViewModel implements RedirectStepViewModel {
  const factory _RedirectStepViewModel({
    required final WebViewController webviewController,
  }) = _$RedirectStepViewModelImpl;

  @override
  WebViewController get webviewController;

  /// Create a copy of RedirectStepViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedirectStepViewModelImplCopyWith<_$RedirectStepViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
