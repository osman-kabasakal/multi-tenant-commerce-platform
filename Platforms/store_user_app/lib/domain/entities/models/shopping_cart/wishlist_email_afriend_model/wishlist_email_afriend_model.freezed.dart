// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_email_afriend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WishlistEmailAFriendModel _$WishlistEmailAFriendModelFromJson(
  Map<String, dynamic> json,
) {
  return _WishlistEmailAFriendModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistEmailAFriendModel {
  @JsonKey(name: 'FriendEmail', includeIfNull: false)
  String? get friendEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
  String? get yourEmailAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'PersonalMessage', includeIfNull: false)
  String? get personalMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
  bool? get successfullySent => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this WishlistEmailAFriendModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistEmailAFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistEmailAFriendModelCopyWith<WishlistEmailAFriendModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistEmailAFriendModelCopyWith<$Res> {
  factory $WishlistEmailAFriendModelCopyWith(
    WishlistEmailAFriendModel value,
    $Res Function(WishlistEmailAFriendModel) then,
  ) = _$WishlistEmailAFriendModelCopyWithImpl<$Res, WishlistEmailAFriendModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'FriendEmail', includeIfNull: false) String? friendEmail,
    @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
    String? yourEmailAddress,
    @JsonKey(name: 'PersonalMessage', includeIfNull: false)
    String? personalMessage,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$WishlistEmailAFriendModelCopyWithImpl<
  $Res,
  $Val extends WishlistEmailAFriendModel
>
    implements $WishlistEmailAFriendModelCopyWith<$Res> {
  _$WishlistEmailAFriendModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistEmailAFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendEmail = freezed,
    Object? yourEmailAddress = freezed,
    Object? personalMessage = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            friendEmail:
                freezed == friendEmail
                    ? _value.friendEmail
                    : friendEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            yourEmailAddress:
                freezed == yourEmailAddress
                    ? _value.yourEmailAddress
                    : yourEmailAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            personalMessage:
                freezed == personalMessage
                    ? _value.personalMessage
                    : personalMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            successfullySent:
                freezed == successfullySent
                    ? _value.successfullySent
                    : successfullySent // ignore: cast_nullable_to_non_nullable
                        as bool?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as String?,
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

  /// Create a copy of WishlistEmailAFriendModel
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
abstract class _$$WishlistEmailAFriendModelImplCopyWith<$Res>
    implements $WishlistEmailAFriendModelCopyWith<$Res> {
  factory _$$WishlistEmailAFriendModelImplCopyWith(
    _$WishlistEmailAFriendModelImpl value,
    $Res Function(_$WishlistEmailAFriendModelImpl) then,
  ) = __$$WishlistEmailAFriendModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'FriendEmail', includeIfNull: false) String? friendEmail,
    @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
    String? yourEmailAddress,
    @JsonKey(name: 'PersonalMessage', includeIfNull: false)
    String? personalMessage,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$WishlistEmailAFriendModelImplCopyWithImpl<$Res>
    extends
        _$WishlistEmailAFriendModelCopyWithImpl<
          $Res,
          _$WishlistEmailAFriendModelImpl
        >
    implements _$$WishlistEmailAFriendModelImplCopyWith<$Res> {
  __$$WishlistEmailAFriendModelImplCopyWithImpl(
    _$WishlistEmailAFriendModelImpl _value,
    $Res Function(_$WishlistEmailAFriendModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistEmailAFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendEmail = freezed,
    Object? yourEmailAddress = freezed,
    Object? personalMessage = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$WishlistEmailAFriendModelImpl(
        friendEmail:
            freezed == friendEmail
                ? _value.friendEmail
                : friendEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        yourEmailAddress:
            freezed == yourEmailAddress
                ? _value.yourEmailAddress
                : yourEmailAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        personalMessage:
            freezed == personalMessage
                ? _value.personalMessage
                : personalMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        successfullySent:
            freezed == successfullySent
                ? _value.successfullySent
                : successfullySent // ignore: cast_nullable_to_non_nullable
                    as bool?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$WishlistEmailAFriendModelImpl implements _WishlistEmailAFriendModel {
  _$WishlistEmailAFriendModelImpl({
    @JsonKey(name: 'FriendEmail', includeIfNull: false) this.friendEmail,
    @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
    this.yourEmailAddress,
    @JsonKey(name: 'PersonalMessage', includeIfNull: false)
    this.personalMessage,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    this.successfullySent = false,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$WishlistEmailAFriendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistEmailAFriendModelImplFromJson(json);

  @override
  @JsonKey(name: 'FriendEmail', includeIfNull: false)
  final String? friendEmail;
  @override
  @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
  final String? yourEmailAddress;
  @override
  @JsonKey(name: 'PersonalMessage', includeIfNull: false)
  final String? personalMessage;
  @override
  @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
  final bool? successfullySent;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
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
    return 'WishlistEmailAFriendModel(friendEmail: $friendEmail, yourEmailAddress: $yourEmailAddress, personalMessage: $personalMessage, successfullySent: $successfullySent, result: $result, displayCaptcha: $displayCaptcha, captcha: $captcha, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistEmailAFriendModelImpl &&
            (identical(other.friendEmail, friendEmail) ||
                other.friendEmail == friendEmail) &&
            (identical(other.yourEmailAddress, yourEmailAddress) ||
                other.yourEmailAddress == yourEmailAddress) &&
            (identical(other.personalMessage, personalMessage) ||
                other.personalMessage == personalMessage) &&
            (identical(other.successfullySent, successfullySent) ||
                other.successfullySent == successfullySent) &&
            (identical(other.result, result) || other.result == result) &&
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
    friendEmail,
    yourEmailAddress,
    personalMessage,
    successfullySent,
    result,
    displayCaptcha,
    captcha,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of WishlistEmailAFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistEmailAFriendModelImplCopyWith<_$WishlistEmailAFriendModelImpl>
  get copyWith => __$$WishlistEmailAFriendModelImplCopyWithImpl<
    _$WishlistEmailAFriendModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistEmailAFriendModelImplToJson(this);
  }
}

abstract class _WishlistEmailAFriendModel implements WishlistEmailAFriendModel {
  factory _WishlistEmailAFriendModel({
    @JsonKey(name: 'FriendEmail', includeIfNull: false)
    final String? friendEmail,
    @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
    final String? yourEmailAddress,
    @JsonKey(name: 'PersonalMessage', includeIfNull: false)
    final String? personalMessage,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    final bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$WishlistEmailAFriendModelImpl;

  factory _WishlistEmailAFriendModel.fromJson(Map<String, dynamic> json) =
      _$WishlistEmailAFriendModelImpl.fromJson;

  @override
  @JsonKey(name: 'FriendEmail', includeIfNull: false)
  String? get friendEmail;
  @override
  @JsonKey(name: 'YourEmailAddress', includeIfNull: false)
  String? get yourEmailAddress;
  @override
  @JsonKey(name: 'PersonalMessage', includeIfNull: false)
  String? get personalMessage;
  @override
  @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
  bool? get successfullySent;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of WishlistEmailAFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistEmailAFriendModelImplCopyWith<_$WishlistEmailAFriendModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
