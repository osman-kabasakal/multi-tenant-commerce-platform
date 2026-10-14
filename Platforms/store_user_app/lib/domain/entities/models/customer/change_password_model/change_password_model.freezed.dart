// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChangePasswordModel _$ChangePasswordModelFromJson(Map<String, dynamic> json) {
  return _ChangePasswordModel.fromJson(json);
}

/// @nodoc
mixin _$ChangePasswordModel {
  @JsonKey(name: 'OldPassword', includeIfNull: false)
  String? get oldPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  String? get newPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  String? get confirmNewPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
  bool? get passwordIsExpired => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ChangePasswordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangePasswordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangePasswordModelCopyWith<ChangePasswordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordModelCopyWith<$Res> {
  factory $ChangePasswordModelCopyWith(
    ChangePasswordModel value,
    $Res Function(ChangePasswordModel) then,
  ) = _$ChangePasswordModelCopyWithImpl<$Res, ChangePasswordModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OldPassword', includeIfNull: false) String? oldPassword,
    @JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    String? confirmNewPassword,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
    bool? passwordIsExpired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ChangePasswordModelCopyWithImpl<$Res, $Val extends ChangePasswordModel>
    implements $ChangePasswordModelCopyWith<$Res> {
  _$ChangePasswordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangePasswordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = freezed,
    Object? newPassword = freezed,
    Object? confirmNewPassword = freezed,
    Object? result = freezed,
    Object? passwordIsExpired = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            oldPassword:
                freezed == oldPassword
                    ? _value.oldPassword
                    : oldPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as String?,
            passwordIsExpired:
                freezed == passwordIsExpired
                    ? _value.passwordIsExpired
                    : passwordIsExpired // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$ChangePasswordModelImplCopyWith<$Res>
    implements $ChangePasswordModelCopyWith<$Res> {
  factory _$$ChangePasswordModelImplCopyWith(
    _$ChangePasswordModelImpl value,
    $Res Function(_$ChangePasswordModelImpl) then,
  ) = __$$ChangePasswordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OldPassword', includeIfNull: false) String? oldPassword,
    @JsonKey(name: 'NewPassword', includeIfNull: false) String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    String? confirmNewPassword,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
    bool? passwordIsExpired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ChangePasswordModelImplCopyWithImpl<$Res>
    extends _$ChangePasswordModelCopyWithImpl<$Res, _$ChangePasswordModelImpl>
    implements _$$ChangePasswordModelImplCopyWith<$Res> {
  __$$ChangePasswordModelImplCopyWithImpl(
    _$ChangePasswordModelImpl _value,
    $Res Function(_$ChangePasswordModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChangePasswordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = freezed,
    Object? newPassword = freezed,
    Object? confirmNewPassword = freezed,
    Object? result = freezed,
    Object? passwordIsExpired = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ChangePasswordModelImpl(
        oldPassword:
            freezed == oldPassword
                ? _value.oldPassword
                : oldPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as String?,
        passwordIsExpired:
            freezed == passwordIsExpired
                ? _value.passwordIsExpired
                : passwordIsExpired // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$ChangePasswordModelImpl implements _ChangePasswordModel {
  _$ChangePasswordModelImpl({
    @JsonKey(name: 'OldPassword', includeIfNull: false) this.oldPassword,
    @JsonKey(name: 'NewPassword', includeIfNull: false) this.newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    this.confirmNewPassword,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
    this.passwordIsExpired = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ChangePasswordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangePasswordModelImplFromJson(json);

  @override
  @JsonKey(name: 'OldPassword', includeIfNull: false)
  final String? oldPassword;
  @override
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  final String? newPassword;
  @override
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  final String? confirmNewPassword;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
  @override
  @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
  final bool? passwordIsExpired;
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
    return 'ChangePasswordModel(oldPassword: $oldPassword, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword, result: $result, passwordIsExpired: $passwordIsExpired, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordModelImpl &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmNewPassword, confirmNewPassword) ||
                other.confirmNewPassword == confirmNewPassword) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.passwordIsExpired, passwordIsExpired) ||
                other.passwordIsExpired == passwordIsExpired) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    oldPassword,
    newPassword,
    confirmNewPassword,
    result,
    passwordIsExpired,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ChangePasswordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordModelImplCopyWith<_$ChangePasswordModelImpl> get copyWith =>
      __$$ChangePasswordModelImplCopyWithImpl<_$ChangePasswordModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangePasswordModelImplToJson(this);
  }
}

abstract class _ChangePasswordModel implements ChangePasswordModel {
  factory _ChangePasswordModel({
    @JsonKey(name: 'OldPassword', includeIfNull: false)
    final String? oldPassword,
    @JsonKey(name: 'NewPassword', includeIfNull: false)
    final String? newPassword,
    @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
    final String? confirmNewPassword,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
    final bool? passwordIsExpired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ChangePasswordModelImpl;

  factory _ChangePasswordModel.fromJson(Map<String, dynamic> json) =
      _$ChangePasswordModelImpl.fromJson;

  @override
  @JsonKey(name: 'OldPassword', includeIfNull: false)
  String? get oldPassword;
  @override
  @JsonKey(name: 'NewPassword', includeIfNull: false)
  String? get newPassword;
  @override
  @JsonKey(name: 'ConfirmNewPassword', includeIfNull: false)
  String? get confirmNewPassword;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'PasswordIsExpired', includeIfNull: false)
  bool? get passwordIsExpired;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ChangePasswordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePasswordModelImplCopyWith<_$ChangePasswordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
