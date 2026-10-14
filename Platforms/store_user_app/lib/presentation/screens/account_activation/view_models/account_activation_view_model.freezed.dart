// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_activation_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AccountActivationViewModel {
  String get token => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;
  bool get isActivationSuccess => throw _privateConstructorUsedError;
  String? get resultMessage => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AccountActivationViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountActivationViewModelCopyWith<AccountActivationViewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountActivationViewModelCopyWith<$Res> {
  factory $AccountActivationViewModelCopyWith(
    AccountActivationViewModel value,
    $Res Function(AccountActivationViewModel) then,
  ) =
      _$AccountActivationViewModelCopyWithImpl<
        $Res,
        AccountActivationViewModel
      >;
  @useResult
  $Res call({
    String token,
    String email,
    bool isProcessing,
    bool isActivationSuccess,
    String? resultMessage,
    String? errorMessage,
  });
}

/// @nodoc
class _$AccountActivationViewModelCopyWithImpl<
  $Res,
  $Val extends AccountActivationViewModel
>
    implements $AccountActivationViewModelCopyWith<$Res> {
  _$AccountActivationViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountActivationViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? email = null,
    Object? isProcessing = null,
    Object? isActivationSuccess = null,
    Object? resultMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            token:
                null == token
                    ? _value.token
                    : token // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            isProcessing:
                null == isProcessing
                    ? _value.isProcessing
                    : isProcessing // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActivationSuccess:
                null == isActivationSuccess
                    ? _value.isActivationSuccess
                    : isActivationSuccess // ignore: cast_nullable_to_non_nullable
                        as bool,
            resultMessage:
                freezed == resultMessage
                    ? _value.resultMessage
                    : resultMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountActivationViewModelImplCopyWith<$Res>
    implements $AccountActivationViewModelCopyWith<$Res> {
  factory _$$AccountActivationViewModelImplCopyWith(
    _$AccountActivationViewModelImpl value,
    $Res Function(_$AccountActivationViewModelImpl) then,
  ) = __$$AccountActivationViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String email,
    bool isProcessing,
    bool isActivationSuccess,
    String? resultMessage,
    String? errorMessage,
  });
}

/// @nodoc
class __$$AccountActivationViewModelImplCopyWithImpl<$Res>
    extends
        _$AccountActivationViewModelCopyWithImpl<
          $Res,
          _$AccountActivationViewModelImpl
        >
    implements _$$AccountActivationViewModelImplCopyWith<$Res> {
  __$$AccountActivationViewModelImplCopyWithImpl(
    _$AccountActivationViewModelImpl _value,
    $Res Function(_$AccountActivationViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountActivationViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? email = null,
    Object? isProcessing = null,
    Object? isActivationSuccess = null,
    Object? resultMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AccountActivationViewModelImpl(
        token:
            null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        isProcessing:
            null == isProcessing
                ? _value.isProcessing
                : isProcessing // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActivationSuccess:
            null == isActivationSuccess
                ? _value.isActivationSuccess
                : isActivationSuccess // ignore: cast_nullable_to_non_nullable
                    as bool,
        resultMessage:
            freezed == resultMessage
                ? _value.resultMessage
                : resultMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$AccountActivationViewModelImpl implements _AccountActivationViewModel {
  const _$AccountActivationViewModelImpl({
    required this.token,
    required this.email,
    this.isProcessing = false,
    this.isActivationSuccess = false,
    this.resultMessage,
    this.errorMessage,
  });

  @override
  final String token;
  @override
  final String email;
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final bool isActivationSuccess;
  @override
  final String? resultMessage;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AccountActivationViewModel(token: $token, email: $email, isProcessing: $isProcessing, isActivationSuccess: $isActivationSuccess, resultMessage: $resultMessage, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountActivationViewModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isActivationSuccess, isActivationSuccess) ||
                other.isActivationSuccess == isActivationSuccess) &&
            (identical(other.resultMessage, resultMessage) ||
                other.resultMessage == resultMessage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    email,
    isProcessing,
    isActivationSuccess,
    resultMessage,
    errorMessage,
  );

  /// Create a copy of AccountActivationViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountActivationViewModelImplCopyWith<_$AccountActivationViewModelImpl>
  get copyWith => __$$AccountActivationViewModelImplCopyWithImpl<
    _$AccountActivationViewModelImpl
  >(this, _$identity);
}

abstract class _AccountActivationViewModel
    implements AccountActivationViewModel {
  const factory _AccountActivationViewModel({
    required final String token,
    required final String email,
    final bool isProcessing,
    final bool isActivationSuccess,
    final String? resultMessage,
    final String? errorMessage,
  }) = _$AccountActivationViewModelImpl;

  @override
  String get token;
  @override
  String get email;
  @override
  bool get isProcessing;
  @override
  bool get isActivationSuccess;
  @override
  String? get resultMessage;
  @override
  String? get errorMessage;

  /// Create a copy of AccountActivationViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountActivationViewModelImplCopyWith<_$AccountActivationViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
