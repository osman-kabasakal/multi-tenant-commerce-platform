// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SignupViewModel {
  AppFormController<RegisterModel> get formController =>
      throw _privateConstructorUsedError;
  RegisterModelFormBuilder get formBuilder =>
      throw _privateConstructorUsedError;
  RegisterModel? get registerModel => throw _privateConstructorUsedError;
  Map<String, dynamic>? get claims => throw _privateConstructorUsedError;
  String? get returnUrl => throw _privateConstructorUsedError;
  bool get processing => throw _privateConstructorUsedError;
  String? get submitError => throw _privateConstructorUsedError;
  int? get registrationResultId => throw _privateConstructorUsedError;
  String? get registrationResultMessage => throw _privateConstructorUsedError;
  bool get showRegistrationResult => throw _privateConstructorUsedError;

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignupViewModelCopyWith<SignupViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupViewModelCopyWith<$Res> {
  factory $SignupViewModelCopyWith(
    SignupViewModel value,
    $Res Function(SignupViewModel) then,
  ) = _$SignupViewModelCopyWithImpl<$Res, SignupViewModel>;
  @useResult
  $Res call({
    AppFormController<RegisterModel> formController,
    RegisterModelFormBuilder formBuilder,
    RegisterModel? registerModel,
    Map<String, dynamic>? claims,
    String? returnUrl,
    bool processing,
    String? submitError,
    int? registrationResultId,
    String? registrationResultMessage,
    bool showRegistrationResult,
  });

  $RegisterModelCopyWith<$Res>? get registerModel;
}

/// @nodoc
class _$SignupViewModelCopyWithImpl<$Res, $Val extends SignupViewModel>
    implements $SignupViewModelCopyWith<$Res> {
  _$SignupViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formController = null,
    Object? formBuilder = null,
    Object? registerModel = freezed,
    Object? claims = freezed,
    Object? returnUrl = freezed,
    Object? processing = null,
    Object? submitError = freezed,
    Object? registrationResultId = freezed,
    Object? registrationResultMessage = freezed,
    Object? showRegistrationResult = null,
  }) {
    return _then(
      _value.copyWith(
            formController:
                null == formController
                    ? _value.formController
                    : formController // ignore: cast_nullable_to_non_nullable
                        as AppFormController<RegisterModel>,
            formBuilder:
                null == formBuilder
                    ? _value.formBuilder
                    : formBuilder // ignore: cast_nullable_to_non_nullable
                        as RegisterModelFormBuilder,
            registerModel:
                freezed == registerModel
                    ? _value.registerModel
                    : registerModel // ignore: cast_nullable_to_non_nullable
                        as RegisterModel?,
            claims:
                freezed == claims
                    ? _value.claims
                    : claims // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
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
            registrationResultId:
                freezed == registrationResultId
                    ? _value.registrationResultId
                    : registrationResultId // ignore: cast_nullable_to_non_nullable
                        as int?,
            registrationResultMessage:
                freezed == registrationResultMessage
                    ? _value.registrationResultMessage
                    : registrationResultMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            showRegistrationResult:
                null == showRegistrationResult
                    ? _value.showRegistrationResult
                    : showRegistrationResult // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterModelCopyWith<$Res>? get registerModel {
    if (_value.registerModel == null) {
      return null;
    }

    return $RegisterModelCopyWith<$Res>(_value.registerModel!, (value) {
      return _then(_value.copyWith(registerModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SignupViewModelImplCopyWith<$Res>
    implements $SignupViewModelCopyWith<$Res> {
  factory _$$SignupViewModelImplCopyWith(
    _$SignupViewModelImpl value,
    $Res Function(_$SignupViewModelImpl) then,
  ) = __$$SignupViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AppFormController<RegisterModel> formController,
    RegisterModelFormBuilder formBuilder,
    RegisterModel? registerModel,
    Map<String, dynamic>? claims,
    String? returnUrl,
    bool processing,
    String? submitError,
    int? registrationResultId,
    String? registrationResultMessage,
    bool showRegistrationResult,
  });

  @override
  $RegisterModelCopyWith<$Res>? get registerModel;
}

/// @nodoc
class __$$SignupViewModelImplCopyWithImpl<$Res>
    extends _$SignupViewModelCopyWithImpl<$Res, _$SignupViewModelImpl>
    implements _$$SignupViewModelImplCopyWith<$Res> {
  __$$SignupViewModelImplCopyWithImpl(
    _$SignupViewModelImpl _value,
    $Res Function(_$SignupViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formController = null,
    Object? formBuilder = null,
    Object? registerModel = freezed,
    Object? claims = freezed,
    Object? returnUrl = freezed,
    Object? processing = null,
    Object? submitError = freezed,
    Object? registrationResultId = freezed,
    Object? registrationResultMessage = freezed,
    Object? showRegistrationResult = null,
  }) {
    return _then(
      _$SignupViewModelImpl(
        formController:
            null == formController
                ? _value.formController
                : formController // ignore: cast_nullable_to_non_nullable
                    as AppFormController<RegisterModel>,
        formBuilder:
            null == formBuilder
                ? _value.formBuilder
                : formBuilder // ignore: cast_nullable_to_non_nullable
                    as RegisterModelFormBuilder,
        registerModel:
            freezed == registerModel
                ? _value.registerModel
                : registerModel // ignore: cast_nullable_to_non_nullable
                    as RegisterModel?,
        claims:
            freezed == claims
                ? _value._claims
                : claims // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
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
        registrationResultId:
            freezed == registrationResultId
                ? _value.registrationResultId
                : registrationResultId // ignore: cast_nullable_to_non_nullable
                    as int?,
        registrationResultMessage:
            freezed == registrationResultMessage
                ? _value.registrationResultMessage
                : registrationResultMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        showRegistrationResult:
            null == showRegistrationResult
                ? _value.showRegistrationResult
                : showRegistrationResult // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$SignupViewModelImpl implements _SignupViewModel {
  const _$SignupViewModelImpl({
    required this.formController,
    required this.formBuilder,
    this.registerModel,
    final Map<String, dynamic>? claims,
    this.returnUrl,
    this.processing = false,
    this.submitError,
    this.registrationResultId,
    this.registrationResultMessage,
    this.showRegistrationResult = false,
  }) : _claims = claims;

  @override
  final AppFormController<RegisterModel> formController;
  @override
  final RegisterModelFormBuilder formBuilder;
  @override
  final RegisterModel? registerModel;
  final Map<String, dynamic>? _claims;
  @override
  Map<String, dynamic>? get claims {
    final value = _claims;
    if (value == null) return null;
    if (_claims is EqualUnmodifiableMapView) return _claims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? returnUrl;
  @override
  @JsonKey()
  final bool processing;
  @override
  final String? submitError;
  @override
  final int? registrationResultId;
  @override
  final String? registrationResultMessage;
  @override
  @JsonKey()
  final bool showRegistrationResult;

  @override
  String toString() {
    return 'SignupViewModel(formController: $formController, formBuilder: $formBuilder, registerModel: $registerModel, claims: $claims, returnUrl: $returnUrl, processing: $processing, submitError: $submitError, registrationResultId: $registrationResultId, registrationResultMessage: $registrationResultMessage, showRegistrationResult: $showRegistrationResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupViewModelImpl &&
            (identical(other.formController, formController) ||
                other.formController == formController) &&
            (identical(other.formBuilder, formBuilder) ||
                other.formBuilder == formBuilder) &&
            (identical(other.registerModel, registerModel) ||
                other.registerModel == registerModel) &&
            const DeepCollectionEquality().equals(other._claims, _claims) &&
            (identical(other.returnUrl, returnUrl) ||
                other.returnUrl == returnUrl) &&
            (identical(other.processing, processing) ||
                other.processing == processing) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.registrationResultId, registrationResultId) ||
                other.registrationResultId == registrationResultId) &&
            (identical(
                  other.registrationResultMessage,
                  registrationResultMessage,
                ) ||
                other.registrationResultMessage == registrationResultMessage) &&
            (identical(other.showRegistrationResult, showRegistrationResult) ||
                other.showRegistrationResult == showRegistrationResult));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    formController,
    formBuilder,
    registerModel,
    const DeepCollectionEquality().hash(_claims),
    returnUrl,
    processing,
    submitError,
    registrationResultId,
    registrationResultMessage,
    showRegistrationResult,
  );

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupViewModelImplCopyWith<_$SignupViewModelImpl> get copyWith =>
      __$$SignupViewModelImplCopyWithImpl<_$SignupViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SignupViewModel implements SignupViewModel {
  const factory _SignupViewModel({
    required final AppFormController<RegisterModel> formController,
    required final RegisterModelFormBuilder formBuilder,
    final RegisterModel? registerModel,
    final Map<String, dynamic>? claims,
    final String? returnUrl,
    final bool processing,
    final String? submitError,
    final int? registrationResultId,
    final String? registrationResultMessage,
    final bool showRegistrationResult,
  }) = _$SignupViewModelImpl;

  @override
  AppFormController<RegisterModel> get formController;
  @override
  RegisterModelFormBuilder get formBuilder;
  @override
  RegisterModel? get registerModel;
  @override
  Map<String, dynamic>? get claims;
  @override
  String? get returnUrl;
  @override
  bool get processing;
  @override
  String? get submitError;
  @override
  int? get registrationResultId;
  @override
  String? get registrationResultMessage;
  @override
  bool get showRegistrationResult;

  /// Create a copy of SignupViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignupViewModelImplCopyWith<_$SignupViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
