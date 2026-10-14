// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_recovery_confirm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PasswordRecoveryConfirmModel _$PasswordRecoveryConfirmModelFromJson(
  Map<String, dynamic> json,
) {
  return _PasswordRecoveryConfirmModel.fromJson(json);
}

/// @nodoc
mixin _$PasswordRecoveryConfirmModel {
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  String? get newPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  String? get confirmNewPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
  bool? get disablePasswordChanging => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'Token', includeIfNull: false)
  String? get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PasswordRecoveryConfirmModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordRecoveryConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordRecoveryConfirmModelCopyWith<PasswordRecoveryConfirmModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordRecoveryConfirmModelCopyWith<$Res> {
  factory $PasswordRecoveryConfirmModelCopyWith(
    PasswordRecoveryConfirmModel value,
    $Res Function(PasswordRecoveryConfirmModel) then,
  ) =
      _$PasswordRecoveryConfirmModelCopyWithImpl<
        $Res,
        PasswordRecoveryConfirmModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    String? confirmNewPassword,
    @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
    bool? disablePasswordChanging,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'Token', includeIfNull: false) String? token,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PasswordRecoveryConfirmModelCopyWithImpl<
  $Res,
  $Val extends PasswordRecoveryConfirmModel
>
    implements $PasswordRecoveryConfirmModelCopyWith<$Res> {
  _$PasswordRecoveryConfirmModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordRecoveryConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newPassword = freezed,
    Object? confirmNewPassword = freezed,
    Object? disablePasswordChanging = freezed,
    Object? result = freezed,
    Object? token = freezed,
    Object? email = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            newPassword:
                freezed == newPassword
                    ? _value.newPassword
                    : newPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
            confirmNewPassword:
                freezed == confirmNewPassword
                    ? _value.confirmNewPassword
                    : confirmNewPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
            disablePasswordChanging:
                freezed == disablePasswordChanging
                    ? _value.disablePasswordChanging
                    : disablePasswordChanging // ignore: cast_nullable_to_non_nullable
                        as bool?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as String?,
            token:
                freezed == token
                    ? _value.token
                    : token // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordRecoveryConfirmModelImplCopyWith<$Res>
    implements $PasswordRecoveryConfirmModelCopyWith<$Res> {
  factory _$$PasswordRecoveryConfirmModelImplCopyWith(
    _$PasswordRecoveryConfirmModelImpl value,
    $Res Function(_$PasswordRecoveryConfirmModelImpl) then,
  ) = __$$PasswordRecoveryConfirmModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    String? confirmNewPassword,
    @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
    bool? disablePasswordChanging,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'Token', includeIfNull: false) String? token,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PasswordRecoveryConfirmModelImplCopyWithImpl<$Res>
    extends
        _$PasswordRecoveryConfirmModelCopyWithImpl<
          $Res,
          _$PasswordRecoveryConfirmModelImpl
        >
    implements _$$PasswordRecoveryConfirmModelImplCopyWith<$Res> {
  __$$PasswordRecoveryConfirmModelImplCopyWithImpl(
    _$PasswordRecoveryConfirmModelImpl _value,
    $Res Function(_$PasswordRecoveryConfirmModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordRecoveryConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newPassword = freezed,
    Object? confirmNewPassword = freezed,
    Object? disablePasswordChanging = freezed,
    Object? result = freezed,
    Object? token = freezed,
    Object? email = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PasswordRecoveryConfirmModelImpl(
        newPassword:
            freezed == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
        confirmNewPassword:
            freezed == confirmNewPassword
                ? _value.confirmNewPassword
                : confirmNewPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
        disablePasswordChanging:
            freezed == disablePasswordChanging
                ? _value.disablePasswordChanging
                : disablePasswordChanging // ignore: cast_nullable_to_non_nullable
                    as bool?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as String?,
        token:
            freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordRecoveryConfirmModelImpl
    implements _PasswordRecoveryConfirmModel {
  _$PasswordRecoveryConfirmModelImpl({
    @JsonKey(name: 'NewPassword', includeIfNull: false) this.newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    this.confirmNewPassword,
    @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
    this.disablePasswordChanging = false,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'Token', includeIfNull: false) this.token,
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$PasswordRecoveryConfirmModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PasswordRecoveryConfirmModelImplFromJson(json);

  @override
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  final String? newPassword;
  @override
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  final String? confirmNewPassword;
  @override
  @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
  final bool? disablePasswordChanging;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
  @override
  @JsonKey(name: 'Token', includeIfNull: false)
  final String? token;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PasswordRecoveryConfirmModel(newPassword: $newPassword, confirmNewPassword: $confirmNewPassword, disablePasswordChanging: $disablePasswordChanging, result: $result, token: $token, email: $email, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordRecoveryConfirmModelImpl &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmNewPassword, confirmNewPassword) ||
                other.confirmNewPassword == confirmNewPassword) &&
            (identical(
                  other.disablePasswordChanging,
                  disablePasswordChanging,
                ) ||
                other.disablePasswordChanging == disablePasswordChanging) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    newPassword,
    confirmNewPassword,
    disablePasswordChanging,
    result,
    token,
    email,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PasswordRecoveryConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordRecoveryConfirmModelImplCopyWith<
    _$PasswordRecoveryConfirmModelImpl
  >
  get copyWith => __$$PasswordRecoveryConfirmModelImplCopyWithImpl<
    _$PasswordRecoveryConfirmModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordRecoveryConfirmModelImplToJson(this);
  }
}

abstract class _PasswordRecoveryConfirmModel
    implements PasswordRecoveryConfirmModel {
  factory _PasswordRecoveryConfirmModel({
    @JsonKey(name: 'NewPassword', includeIfNull: false)
    final String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    final String? confirmNewPassword,
    @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
    final bool? disablePasswordChanging,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'Token', includeIfNull: false) final String? token,
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PasswordRecoveryConfirmModelImpl;

  factory _PasswordRecoveryConfirmModel.fromJson(Map<String, dynamic> json) =
      _$PasswordRecoveryConfirmModelImpl.fromJson;

  @override
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  String? get newPassword;
  @override
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  String? get confirmNewPassword;
  @override
  @JsonKey(name: 'DisablePasswordChanging', includeIfNull: false)
  bool? get disablePasswordChanging;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'Token', includeIfNull: false)
  String? get token;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PasswordRecoveryConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordRecoveryConfirmModelImplCopyWith<
    _$PasswordRecoveryConfirmModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
