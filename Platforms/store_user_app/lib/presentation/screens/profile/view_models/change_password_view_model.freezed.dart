// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChangePasswordViewModel {
  ChangePasswordModel? get model => throw _privateConstructorUsedError;
  bool? get isLoading => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;
  bool? get isSubmitted => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangePasswordViewModelCopyWith<ChangePasswordViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordViewModelCopyWith<$Res> {
  factory $ChangePasswordViewModelCopyWith(
    ChangePasswordViewModel value,
    $Res Function(ChangePasswordViewModel) then,
  ) = _$ChangePasswordViewModelCopyWithImpl<$Res, ChangePasswordViewModel>;
  @useResult
  $Res call({
    ChangePasswordModel? model,
    bool? isLoading,
    bool? success,
    bool? isSubmitted,
    String? message,
    Object? error,
  });

  $ChangePasswordModelCopyWith<$Res>? get model;
}

/// @nodoc
class _$ChangePasswordViewModelCopyWithImpl<
  $Res,
  $Val extends ChangePasswordViewModel
>
    implements $ChangePasswordViewModelCopyWith<$Res> {
  _$ChangePasswordViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? isLoading = freezed,
    Object? success = freezed,
    Object? isSubmitted = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            model:
                freezed == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as ChangePasswordModel?,
            isLoading:
                freezed == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool?,
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isSubmitted:
                freezed == isSubmitted
                    ? _value.isSubmitted
                    : isSubmitted // ignore: cast_nullable_to_non_nullable
                        as bool?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            error: freezed == error ? _value.error : error,
          )
          as $Val,
    );
  }

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChangePasswordModelCopyWith<$Res>? get model {
    if (_value.model == null) {
      return null;
    }

    return $ChangePasswordModelCopyWith<$Res>(_value.model!, (value) {
      return _then(_value.copyWith(model: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChangePasswordViewModelImplCopyWith<$Res>
    implements $ChangePasswordViewModelCopyWith<$Res> {
  factory _$$ChangePasswordViewModelImplCopyWith(
    _$ChangePasswordViewModelImpl value,
    $Res Function(_$ChangePasswordViewModelImpl) then,
  ) = __$$ChangePasswordViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ChangePasswordModel? model,
    bool? isLoading,
    bool? success,
    bool? isSubmitted,
    String? message,
    Object? error,
  });

  @override
  $ChangePasswordModelCopyWith<$Res>? get model;
}

/// @nodoc
class __$$ChangePasswordViewModelImplCopyWithImpl<$Res>
    extends
        _$ChangePasswordViewModelCopyWithImpl<
          $Res,
          _$ChangePasswordViewModelImpl
        >
    implements _$$ChangePasswordViewModelImplCopyWith<$Res> {
  __$$ChangePasswordViewModelImplCopyWithImpl(
    _$ChangePasswordViewModelImpl _value,
    $Res Function(_$ChangePasswordViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? isLoading = freezed,
    Object? success = freezed,
    Object? isSubmitted = freezed,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$ChangePasswordViewModelImpl(
        model:
            freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                    as ChangePasswordModel?,
        isLoading:
            freezed == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool?,
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isSubmitted:
            freezed == isSubmitted
                ? _value.isSubmitted
                : isSubmitted // ignore: cast_nullable_to_non_nullable
                    as bool?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        error: freezed == error ? _value.error : error,
      ),
    );
  }
}

/// @nodoc

class _$ChangePasswordViewModelImpl implements _ChangePasswordViewModel {
  const _$ChangePasswordViewModelImpl({
    this.model,
    this.isLoading,
    this.success,
    this.isSubmitted,
    this.message,
    this.error,
  });

  @override
  final ChangePasswordModel? model;
  @override
  final bool? isLoading;
  @override
  final bool? success;
  @override
  final bool? isSubmitted;
  @override
  final String? message;
  @override
  final Object? error;

  @override
  String toString() {
    return 'ChangePasswordViewModel(model: $model, isLoading: $isLoading, success: $success, isSubmitted: $isSubmitted, message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordViewModelImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.isSubmitted, isSubmitted) ||
                other.isSubmitted == isSubmitted) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    model,
    isLoading,
    success,
    isSubmitted,
    message,
    const DeepCollectionEquality().hash(error),
  );

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordViewModelImplCopyWith<_$ChangePasswordViewModelImpl>
  get copyWith => __$$ChangePasswordViewModelImplCopyWithImpl<
    _$ChangePasswordViewModelImpl
  >(this, _$identity);
}

abstract class _ChangePasswordViewModel implements ChangePasswordViewModel {
  const factory _ChangePasswordViewModel({
    final ChangePasswordModel? model,
    final bool? isLoading,
    final bool? success,
    final bool? isSubmitted,
    final String? message,
    final Object? error,
  }) = _$ChangePasswordViewModelImpl;

  @override
  ChangePasswordModel? get model;
  @override
  bool? get isLoading;
  @override
  bool? get success;
  @override
  bool? get isSubmitted;
  @override
  String? get message;
  @override
  Object? get error;

  /// Create a copy of ChangePasswordViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePasswordViewModelImplCopyWith<_$ChangePasswordViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
