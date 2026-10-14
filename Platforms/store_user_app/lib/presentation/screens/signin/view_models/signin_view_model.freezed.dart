// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SigninViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  AppFormController<LoginModel> get formController =>
      throw _privateConstructorUsedError;
  LoginModelFormBuilder get formBuilder => throw _privateConstructorUsedError;
  LoginModel get loginModel => throw _privateConstructorUsedError;
  String? get returnUrl => throw _privateConstructorUsedError;
  bool get processing => throw _privateConstructorUsedError;
  String? get submitError => throw _privateConstructorUsedError;

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SigninViewModelCopyWith<SigninViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SigninViewModelCopyWith<$Res> {
  factory $SigninViewModelCopyWith(
    SigninViewModel value,
    $Res Function(SigninViewModel) then,
  ) = _$SigninViewModelCopyWithImpl<$Res, SigninViewModel>;
  @useResult
  $Res call({
    bool isLoading,
    AppFormController<LoginModel> formController,
    LoginModelFormBuilder formBuilder,
    LoginModel loginModel,
    String? returnUrl,
    bool processing,
    String? submitError,
  });

  $LoginModelCopyWith<$Res> get loginModel;
}

/// @nodoc
class _$SigninViewModelCopyWithImpl<$Res, $Val extends SigninViewModel>
    implements $SigninViewModelCopyWith<$Res> {
  _$SigninViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? formController = null,
    Object? formBuilder = null,
    Object? loginModel = null,
    Object? returnUrl = freezed,
    Object? processing = null,
    Object? submitError = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            formController:
                null == formController
                    ? _value.formController
                    : formController // ignore: cast_nullable_to_non_nullable
                        as AppFormController<LoginModel>,
            formBuilder:
                null == formBuilder
                    ? _value.formBuilder
                    : formBuilder // ignore: cast_nullable_to_non_nullable
                        as LoginModelFormBuilder,
            loginModel:
                null == loginModel
                    ? _value.loginModel
                    : loginModel // ignore: cast_nullable_to_non_nullable
                        as LoginModel,
            returnUrl:
                freezed == returnUrl
                    ? _value.returnUrl
                    : returnUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            processing:
                null == processing
                    ? _value.processing
                    : processing // ignore: cast_nullable_to_non_nullable
                        as bool,
            submitError:
                freezed == submitError
                    ? _value.submitError
                    : submitError // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoginModelCopyWith<$Res> get loginModel {
    return $LoginModelCopyWith<$Res>(_value.loginModel, (value) {
      return _then(_value.copyWith(loginModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SigninViewModelImplCopyWith<$Res>
    implements $SigninViewModelCopyWith<$Res> {
  factory _$$SigninViewModelImplCopyWith(
    _$SigninViewModelImpl value,
    $Res Function(_$SigninViewModelImpl) then,
  ) = __$$SigninViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    AppFormController<LoginModel> formController,
    LoginModelFormBuilder formBuilder,
    LoginModel loginModel,
    String? returnUrl,
    bool processing,
    String? submitError,
  });

  @override
  $LoginModelCopyWith<$Res> get loginModel;
}

/// @nodoc
class __$$SigninViewModelImplCopyWithImpl<$Res>
    extends _$SigninViewModelCopyWithImpl<$Res, _$SigninViewModelImpl>
    implements _$$SigninViewModelImplCopyWith<$Res> {
  __$$SigninViewModelImplCopyWithImpl(
    _$SigninViewModelImpl _value,
    $Res Function(_$SigninViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? formController = null,
    Object? formBuilder = null,
    Object? loginModel = null,
    Object? returnUrl = freezed,
    Object? processing = null,
    Object? submitError = freezed,
  }) {
    return _then(
      _$SigninViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        formController:
            null == formController
                ? _value.formController
                : formController // ignore: cast_nullable_to_non_nullable
                    as AppFormController<LoginModel>,
        formBuilder:
            null == formBuilder
                ? _value.formBuilder
                : formBuilder // ignore: cast_nullable_to_non_nullable
                    as LoginModelFormBuilder,
        loginModel:
            null == loginModel
                ? _value.loginModel
                : loginModel // ignore: cast_nullable_to_non_nullable
                    as LoginModel,
        returnUrl:
            freezed == returnUrl
                ? _value.returnUrl
                : returnUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        processing:
            null == processing
                ? _value.processing
                : processing // ignore: cast_nullable_to_non_nullable
                    as bool,
        submitError:
            freezed == submitError
                ? _value.submitError
                : submitError // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SigninViewModelImpl implements _SigninViewModel {
  const _$SigninViewModelImpl({
    this.isLoading = false,
    required this.formController,
    required this.formBuilder,
    required this.loginModel,
    this.returnUrl,
    this.processing = false,
    this.submitError,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final AppFormController<LoginModel> formController;
  @override
  final LoginModelFormBuilder formBuilder;
  @override
  final LoginModel loginModel;
  @override
  final String? returnUrl;
  @override
  @JsonKey()
  final bool processing;
  @override
  final String? submitError;

  @override
  String toString() {
    return 'SigninViewModel(isLoading: $isLoading, formController: $formController, formBuilder: $formBuilder, loginModel: $loginModel, returnUrl: $returnUrl, processing: $processing, submitError: $submitError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SigninViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.formController, formController) ||
                other.formController == formController) &&
            (identical(other.formBuilder, formBuilder) ||
                other.formBuilder == formBuilder) &&
            (identical(other.loginModel, loginModel) ||
                other.loginModel == loginModel) &&
            (identical(other.returnUrl, returnUrl) ||
                other.returnUrl == returnUrl) &&
            (identical(other.processing, processing) ||
                other.processing == processing) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    formController,
    formBuilder,
    loginModel,
    returnUrl,
    processing,
    submitError,
  );

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SigninViewModelImplCopyWith<_$SigninViewModelImpl> get copyWith =>
      __$$SigninViewModelImplCopyWithImpl<_$SigninViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SigninViewModel implements SigninViewModel {
  const factory _SigninViewModel({
    final bool isLoading,
    required final AppFormController<LoginModel> formController,
    required final LoginModelFormBuilder formBuilder,
    required final LoginModel loginModel,
    final String? returnUrl,
    final bool processing,
    final String? submitError,
  }) = _$SigninViewModelImpl;

  @override
  bool get isLoading;
  @override
  AppFormController<LoginModel> get formController;
  @override
  LoginModelFormBuilder get formBuilder;
  @override
  LoginModel get loginModel;
  @override
  String? get returnUrl;
  @override
  bool get processing;
  @override
  String? get submitError;

  /// Create a copy of SigninViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SigninViewModelImplCopyWith<_$SigninViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
