// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_step_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutStepResponse _$CheckoutStepResponseFromJson(Map<String, dynamic> json) {
  return _CheckoutStepResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckoutStepResponse {
  @JsonKey(name: 'update_section')
  UpdateSectionJsonModel? get UpdateSection =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'goto_section')
  String? get goToSection => throw _privateConstructorUsedError;
  @JsonKey(name: 'wrong_billing_address')
  bool get wrongBillingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_state')
  List<String> get modelState => throw _privateConstructorUsedError;
  @JsonKey(name: 'error')
  int? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;
  int? get success => throw _privateConstructorUsedError;
  String? get redirect => throw _privateConstructorUsedError;

  /// Serializes this CheckoutStepResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutStepResponseCopyWith<CheckoutStepResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStepResponseCopyWith<$Res> {
  factory $CheckoutStepResponseCopyWith(
    CheckoutStepResponse value,
    $Res Function(CheckoutStepResponse) then,
  ) = _$CheckoutStepResponseCopyWithImpl<$Res, CheckoutStepResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'update_section') UpdateSectionJsonModel? UpdateSection,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_billing_address') bool wrongBillingAddress,
    @JsonKey(name: 'model_state') List<String> modelState,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
    int? success,
    String? redirect,
  });

  $UpdateSectionJsonModelCopyWith<$Res>? get UpdateSection;
}

/// @nodoc
class _$CheckoutStepResponseCopyWithImpl<
  $Res,
  $Val extends CheckoutStepResponse
>
    implements $CheckoutStepResponseCopyWith<$Res> {
  _$CheckoutStepResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? UpdateSection = freezed,
    Object? goToSection = freezed,
    Object? wrongBillingAddress = null,
    Object? modelState = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? success = freezed,
    Object? redirect = freezed,
  }) {
    return _then(
      _value.copyWith(
            UpdateSection:
                freezed == UpdateSection
                    ? _value.UpdateSection
                    : UpdateSection // ignore: cast_nullable_to_non_nullable
                        as UpdateSectionJsonModel?,
            goToSection:
                freezed == goToSection
                    ? _value.goToSection
                    : goToSection // ignore: cast_nullable_to_non_nullable
                        as String?,
            wrongBillingAddress:
                null == wrongBillingAddress
                    ? _value.wrongBillingAddress
                    : wrongBillingAddress // ignore: cast_nullable_to_non_nullable
                        as bool,
            modelState:
                null == modelState
                    ? _value.modelState
                    : modelState // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as int?,
            redirect:
                freezed == redirect
                    ? _value.redirect
                    : redirect // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateSectionJsonModelCopyWith<$Res>? get UpdateSection {
    if (_value.UpdateSection == null) {
      return null;
    }

    return $UpdateSectionJsonModelCopyWith<$Res>(_value.UpdateSection!, (
      value,
    ) {
      return _then(_value.copyWith(UpdateSection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutStepResponseImplCopyWith<$Res>
    implements $CheckoutStepResponseCopyWith<$Res> {
  factory _$$CheckoutStepResponseImplCopyWith(
    _$CheckoutStepResponseImpl value,
    $Res Function(_$CheckoutStepResponseImpl) then,
  ) = __$$CheckoutStepResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'update_section') UpdateSectionJsonModel? UpdateSection,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_billing_address') bool wrongBillingAddress,
    @JsonKey(name: 'model_state') List<String> modelState,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
    int? success,
    String? redirect,
  });

  @override
  $UpdateSectionJsonModelCopyWith<$Res>? get UpdateSection;
}

/// @nodoc
class __$$CheckoutStepResponseImplCopyWithImpl<$Res>
    extends _$CheckoutStepResponseCopyWithImpl<$Res, _$CheckoutStepResponseImpl>
    implements _$$CheckoutStepResponseImplCopyWith<$Res> {
  __$$CheckoutStepResponseImplCopyWithImpl(
    _$CheckoutStepResponseImpl _value,
    $Res Function(_$CheckoutStepResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? UpdateSection = freezed,
    Object? goToSection = freezed,
    Object? wrongBillingAddress = null,
    Object? modelState = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? success = freezed,
    Object? redirect = freezed,
  }) {
    return _then(
      _$CheckoutStepResponseImpl(
        UpdateSection:
            freezed == UpdateSection
                ? _value.UpdateSection
                : UpdateSection // ignore: cast_nullable_to_non_nullable
                    as UpdateSectionJsonModel?,
        goToSection:
            freezed == goToSection
                ? _value.goToSection
                : goToSection // ignore: cast_nullable_to_non_nullable
                    as String?,
        wrongBillingAddress:
            null == wrongBillingAddress
                ? _value.wrongBillingAddress
                : wrongBillingAddress // ignore: cast_nullable_to_non_nullable
                    as bool,
        modelState:
            null == modelState
                ? _value._modelState
                : modelState // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as int?,
        redirect:
            freezed == redirect
                ? _value.redirect
                : redirect // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$CheckoutStepResponseImpl implements _CheckoutStepResponse {
  const _$CheckoutStepResponseImpl({
    @JsonKey(name: 'update_section') this.UpdateSection,
    @JsonKey(name: 'goto_section') this.goToSection,
    @JsonKey(name: 'wrong_billing_address') this.wrongBillingAddress = false,
    @JsonKey(name: 'model_state') final List<String> modelState = const [],
    @JsonKey(name: 'error') this.error,
    @JsonKey(name: 'message') this.message,
    this.success,
    this.redirect,
  }) : _modelState = modelState;

  factory _$CheckoutStepResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutStepResponseImplFromJson(json);

  @override
  @JsonKey(name: 'update_section')
  final UpdateSectionJsonModel? UpdateSection;
  @override
  @JsonKey(name: 'goto_section')
  final String? goToSection;
  @override
  @JsonKey(name: 'wrong_billing_address')
  final bool wrongBillingAddress;
  final List<String> _modelState;
  @override
  @JsonKey(name: 'model_state')
  List<String> get modelState {
    if (_modelState is EqualUnmodifiableListView) return _modelState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modelState);
  }

  @override
  @JsonKey(name: 'error')
  final int? error;
  @override
  @JsonKey(name: 'message')
  final String? message;
  @override
  final int? success;
  @override
  final String? redirect;

  @override
  String toString() {
    return 'CheckoutStepResponse(UpdateSection: $UpdateSection, goToSection: $goToSection, wrongBillingAddress: $wrongBillingAddress, modelState: $modelState, error: $error, message: $message, success: $success, redirect: $redirect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutStepResponseImpl &&
            (identical(other.UpdateSection, UpdateSection) ||
                other.UpdateSection == UpdateSection) &&
            (identical(other.goToSection, goToSection) ||
                other.goToSection == goToSection) &&
            (identical(other.wrongBillingAddress, wrongBillingAddress) ||
                other.wrongBillingAddress == wrongBillingAddress) &&
            const DeepCollectionEquality().equals(
              other._modelState,
              _modelState,
            ) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.redirect, redirect) ||
                other.redirect == redirect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    UpdateSection,
    goToSection,
    wrongBillingAddress,
    const DeepCollectionEquality().hash(_modelState),
    error,
    message,
    success,
    redirect,
  );

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutStepResponseImplCopyWith<_$CheckoutStepResponseImpl>
  get copyWith =>
      __$$CheckoutStepResponseImplCopyWithImpl<_$CheckoutStepResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutStepResponseImplToJson(this);
  }
}

abstract class _CheckoutStepResponse implements CheckoutStepResponse {
  const factory _CheckoutStepResponse({
    @JsonKey(name: 'update_section')
    final UpdateSectionJsonModel? UpdateSection,
    @JsonKey(name: 'goto_section') final String? goToSection,
    @JsonKey(name: 'wrong_billing_address') final bool wrongBillingAddress,
    @JsonKey(name: 'model_state') final List<String> modelState,
    @JsonKey(name: 'error') final int? error,
    @JsonKey(name: 'message') final String? message,
    final int? success,
    final String? redirect,
  }) = _$CheckoutStepResponseImpl;

  factory _CheckoutStepResponse.fromJson(Map<String, dynamic> json) =
      _$CheckoutStepResponseImpl.fromJson;

  @override
  @JsonKey(name: 'update_section')
  UpdateSectionJsonModel? get UpdateSection;
  @override
  @JsonKey(name: 'goto_section')
  String? get goToSection;
  @override
  @JsonKey(name: 'wrong_billing_address')
  bool get wrongBillingAddress;
  @override
  @JsonKey(name: 'model_state')
  List<String> get modelState;
  @override
  @JsonKey(name: 'error')
  int? get error;
  @override
  @JsonKey(name: 'message')
  String? get message;
  @override
  int? get success;
  @override
  String? get redirect;

  /// Create a copy of CheckoutStepResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutStepResponseImplCopyWith<_$CheckoutStepResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
