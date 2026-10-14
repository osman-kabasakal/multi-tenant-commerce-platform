// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loginModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return _LoginModel.fromJson(json);
}

/// @nodoc
mixin _$LoginModel {
  @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
  bool? get checkoutAsGuest => throw _privateConstructorUsedError;
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
  bool? get usernamesEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'Username', includeIfNull: false)
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'RememberMe', includeIfNull: false)
  bool? get rememberMe => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this LoginModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginModelCopyWith<LoginModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginModelCopyWith<$Res> {
  factory $LoginModelCopyWith(
    LoginModel value,
    $Res Function(LoginModel) then,
  ) = _$LoginModelCopyWithImpl<$Res, LoginModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
    bool? checkoutAsGuest,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
    bool? usernamesEnabled,
    @JsonKey(name: 'Username', includeIfNull: false) String? username,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'RememberMe', includeIfNull: false) bool? rememberMe,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$LoginModelCopyWithImpl<$Res, $Val extends LoginModel>
    implements $LoginModelCopyWith<$Res> {
  _$LoginModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutAsGuest = freezed,
    Object? email = freezed,
    Object? usernamesEnabled = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? rememberMe = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            checkoutAsGuest:
                freezed == checkoutAsGuest
                    ? _value.checkoutAsGuest
                    : checkoutAsGuest // ignore: cast_nullable_to_non_nullable
                        as bool?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            usernamesEnabled:
                freezed == usernamesEnabled
                    ? _value.usernamesEnabled
                    : usernamesEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            username:
                freezed == username
                    ? _value.username
                    : username // ignore: cast_nullable_to_non_nullable
                        as String?,
            password:
                freezed == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String?,
            rememberMe:
                freezed == rememberMe
                    ? _value.rememberMe
                    : rememberMe // ignore: cast_nullable_to_non_nullable
                        as bool?,
            displayCaptcha:
                freezed == displayCaptcha
                    ? _value.displayCaptcha
                    : displayCaptcha // ignore: cast_nullable_to_non_nullable
                        as bool?,
            captcha:
                freezed == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as ICaptchaValidModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ICaptchaValidModelCopyWith<$Res>? get captcha {
    if (_value.captcha == null) {
      return null;
    }

    return $ICaptchaValidModelCopyWith<$Res>(_value.captcha!, (value) {
      return _then(_value.copyWith(captcha: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginModelImplCopyWith<$Res>
    implements $LoginModelCopyWith<$Res> {
  factory _$$LoginModelImplCopyWith(
    _$LoginModelImpl value,
    $Res Function(_$LoginModelImpl) then,
  ) = __$$LoginModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
    bool? checkoutAsGuest,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
    bool? usernamesEnabled,
    @JsonKey(name: 'Username', includeIfNull: false) String? username,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'RememberMe', includeIfNull: false) bool? rememberMe,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$LoginModelImplCopyWithImpl<$Res>
    extends _$LoginModelCopyWithImpl<$Res, _$LoginModelImpl>
    implements _$$LoginModelImplCopyWith<$Res> {
  __$$LoginModelImplCopyWithImpl(
    _$LoginModelImpl _value,
    $Res Function(_$LoginModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutAsGuest = freezed,
    Object? email = freezed,
    Object? usernamesEnabled = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? rememberMe = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$LoginModelImpl(
        checkoutAsGuest:
            freezed == checkoutAsGuest
                ? _value.checkoutAsGuest
                : checkoutAsGuest // ignore: cast_nullable_to_non_nullable
                    as bool?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        usernamesEnabled:
            freezed == usernamesEnabled
                ? _value.usernamesEnabled
                : usernamesEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        username:
            freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                    as String?,
        password:
            freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String?,
        rememberMe:
            freezed == rememberMe
                ? _value.rememberMe
                : rememberMe // ignore: cast_nullable_to_non_nullable
                    as bool?,
        displayCaptcha:
            freezed == displayCaptcha
                ? _value.displayCaptcha
                : displayCaptcha // ignore: cast_nullable_to_non_nullable
                    as bool?,
        captcha:
            freezed == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as ICaptchaValidModel?,
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
class _$LoginModelImpl implements _LoginModel {
  _$LoginModelImpl({
    @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
    this.checkoutAsGuest = false,
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
    this.usernamesEnabled = false,
    @JsonKey(name: 'Username', includeIfNull: false) this.username,
    @JsonKey(name: 'Password', includeIfNull: false) this.password,
    @JsonKey(name: 'RememberMe', includeIfNull: false) this.rememberMe = false,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$LoginModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginModelImplFromJson(json);

  @override
  @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
  final bool? checkoutAsGuest;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
  final bool? usernamesEnabled;
  @override
  @JsonKey(name: 'Username', includeIfNull: false)
  final String? username;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;
  @override
  @JsonKey(name: 'RememberMe', includeIfNull: false)
  final bool? rememberMe;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
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
    return 'LoginModel(checkoutAsGuest: $checkoutAsGuest, email: $email, usernamesEnabled: $usernamesEnabled, username: $username, password: $password, rememberMe: $rememberMe, displayCaptcha: $displayCaptcha, captcha: $captcha, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginModelImpl &&
            (identical(other.checkoutAsGuest, checkoutAsGuest) ||
                other.checkoutAsGuest == checkoutAsGuest) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.usernamesEnabled, usernamesEnabled) ||
                other.usernamesEnabled == usernamesEnabled) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    checkoutAsGuest,
    email,
    usernamesEnabled,
    username,
    password,
    rememberMe,
    displayCaptcha,
    captcha,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      __$$LoginModelImplCopyWithImpl<_$LoginModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginModelImplToJson(this);
  }
}

abstract class _LoginModel implements LoginModel {
  factory _LoginModel({
    @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
    final bool? checkoutAsGuest,
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
    final bool? usernamesEnabled,
    @JsonKey(name: 'Username', includeIfNull: false) final String? username,
    @JsonKey(name: 'Password', includeIfNull: false) final String? password,
    @JsonKey(name: 'RememberMe', includeIfNull: false) final bool? rememberMe,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$LoginModelImpl;

  factory _LoginModel.fromJson(Map<String, dynamic> json) =
      _$LoginModelImpl.fromJson;

  @override
  @JsonKey(name: 'CheckoutAsGuest', includeIfNull: false)
  bool? get checkoutAsGuest;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'UsernamesEnabled', includeIfNull: false)
  bool? get usernamesEnabled;
  @override
  @JsonKey(name: 'Username', includeIfNull: false)
  String? get username;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password;
  @override
  @JsonKey(name: 'RememberMe', includeIfNull: false)
  bool? get rememberMe;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
