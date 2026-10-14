// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_ask_question_simple_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductAskQuestionSimpleModel _$ProductAskQuestionSimpleModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductAskQuestionSimpleModel.fromJson(json);
}

/// @nodoc
mixin _$ProductAskQuestionSimpleModel {
  @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
  String? get askQuestionEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
  String? get askQuestionFullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
  String? get askQuestionPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
  String? get askQuestionMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductAskQuestionSimpleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductAskQuestionSimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductAskQuestionSimpleModelCopyWith<ProductAskQuestionSimpleModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAskQuestionSimpleModelCopyWith<$Res> {
  factory $ProductAskQuestionSimpleModelCopyWith(
    ProductAskQuestionSimpleModel value,
    $Res Function(ProductAskQuestionSimpleModel) then,
  ) =
      _$ProductAskQuestionSimpleModelCopyWithImpl<
        $Res,
        ProductAskQuestionSimpleModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
    String? askQuestionEmail,
    @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
    String? askQuestionFullName,
    @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
    String? askQuestionPhone,
    @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
    String? askQuestionMessage,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$ProductAskQuestionSimpleModelCopyWithImpl<
  $Res,
  $Val extends ProductAskQuestionSimpleModel
>
    implements $ProductAskQuestionSimpleModelCopyWith<$Res> {
  _$ProductAskQuestionSimpleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductAskQuestionSimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? askQuestionEmail = freezed,
    Object? askQuestionFullName = freezed,
    Object? askQuestionPhone = freezed,
    Object? askQuestionMessage = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            askQuestionEmail:
                freezed == askQuestionEmail
                    ? _value.askQuestionEmail
                    : askQuestionEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            askQuestionFullName:
                freezed == askQuestionFullName
                    ? _value.askQuestionFullName
                    : askQuestionFullName // ignore: cast_nullable_to_non_nullable
                        as String?,
            askQuestionPhone:
                freezed == askQuestionPhone
                    ? _value.askQuestionPhone
                    : askQuestionPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            askQuestionMessage:
                freezed == askQuestionMessage
                    ? _value.askQuestionMessage
                    : askQuestionMessage // ignore: cast_nullable_to_non_nullable
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
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of ProductAskQuestionSimpleModel
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
abstract class _$$ProductAskQuestionSimpleModelImplCopyWith<$Res>
    implements $ProductAskQuestionSimpleModelCopyWith<$Res> {
  factory _$$ProductAskQuestionSimpleModelImplCopyWith(
    _$ProductAskQuestionSimpleModelImpl value,
    $Res Function(_$ProductAskQuestionSimpleModelImpl) then,
  ) = __$$ProductAskQuestionSimpleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
    String? askQuestionEmail,
    @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
    String? askQuestionFullName,
    @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
    String? askQuestionPhone,
    @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
    String? askQuestionMessage,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$ProductAskQuestionSimpleModelImplCopyWithImpl<$Res>
    extends
        _$ProductAskQuestionSimpleModelCopyWithImpl<
          $Res,
          _$ProductAskQuestionSimpleModelImpl
        >
    implements _$$ProductAskQuestionSimpleModelImplCopyWith<$Res> {
  __$$ProductAskQuestionSimpleModelImplCopyWithImpl(
    _$ProductAskQuestionSimpleModelImpl _value,
    $Res Function(_$ProductAskQuestionSimpleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductAskQuestionSimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? askQuestionEmail = freezed,
    Object? askQuestionFullName = freezed,
    Object? askQuestionPhone = freezed,
    Object? askQuestionMessage = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductAskQuestionSimpleModelImpl(
        askQuestionEmail:
            freezed == askQuestionEmail
                ? _value.askQuestionEmail
                : askQuestionEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        askQuestionFullName:
            freezed == askQuestionFullName
                ? _value.askQuestionFullName
                : askQuestionFullName // ignore: cast_nullable_to_non_nullable
                    as String?,
        askQuestionPhone:
            freezed == askQuestionPhone
                ? _value.askQuestionPhone
                : askQuestionPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        askQuestionMessage:
            freezed == askQuestionMessage
                ? _value.askQuestionMessage
                : askQuestionMessage // ignore: cast_nullable_to_non_nullable
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
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
class _$ProductAskQuestionSimpleModelImpl
    implements _ProductAskQuestionSimpleModel {
  _$ProductAskQuestionSimpleModelImpl({
    @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
    this.askQuestionEmail,
    @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
    this.askQuestionFullName,
    @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
    this.askQuestionPhone,
    @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
    this.askQuestionMessage,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductAskQuestionSimpleModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ProductAskQuestionSimpleModelImplFromJson(json);

  @override
  @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
  final String? askQuestionEmail;
  @override
  @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
  final String? askQuestionFullName;
  @override
  @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
  final String? askQuestionPhone;
  @override
  @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
  final String? askQuestionMessage;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
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
    return 'ProductAskQuestionSimpleModel(askQuestionEmail: $askQuestionEmail, askQuestionFullName: $askQuestionFullName, askQuestionPhone: $askQuestionPhone, askQuestionMessage: $askQuestionMessage, displayCaptcha: $displayCaptcha, captcha: $captcha, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAskQuestionSimpleModelImpl &&
            (identical(other.askQuestionEmail, askQuestionEmail) ||
                other.askQuestionEmail == askQuestionEmail) &&
            (identical(other.askQuestionFullName, askQuestionFullName) ||
                other.askQuestionFullName == askQuestionFullName) &&
            (identical(other.askQuestionPhone, askQuestionPhone) ||
                other.askQuestionPhone == askQuestionPhone) &&
            (identical(other.askQuestionMessage, askQuestionMessage) ||
                other.askQuestionMessage == askQuestionMessage) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    askQuestionEmail,
    askQuestionFullName,
    askQuestionPhone,
    askQuestionMessage,
    displayCaptcha,
    captcha,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductAskQuestionSimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAskQuestionSimpleModelImplCopyWith<
    _$ProductAskQuestionSimpleModelImpl
  >
  get copyWith => __$$ProductAskQuestionSimpleModelImplCopyWithImpl<
    _$ProductAskQuestionSimpleModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAskQuestionSimpleModelImplToJson(this);
  }
}

abstract class _ProductAskQuestionSimpleModel
    implements ProductAskQuestionSimpleModel {
  factory _ProductAskQuestionSimpleModel({
    @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
    final String? askQuestionEmail,
    @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
    final String? askQuestionFullName,
    @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
    final String? askQuestionPhone,
    @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
    final String? askQuestionMessage,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductAskQuestionSimpleModelImpl;

  factory _ProductAskQuestionSimpleModel.fromJson(Map<String, dynamic> json) =
      _$ProductAskQuestionSimpleModelImpl.fromJson;

  @override
  @JsonKey(name: 'AskQuestionEmail', includeIfNull: false)
  String? get askQuestionEmail;
  @override
  @JsonKey(name: 'AskQuestionFullName', includeIfNull: false)
  String? get askQuestionFullName;
  @override
  @JsonKey(name: 'AskQuestionPhone', includeIfNull: false)
  String? get askQuestionPhone;
  @override
  @JsonKey(name: 'AskQuestionMessage', includeIfNull: false)
  String? get askQuestionMessage;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductAskQuestionSimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAskQuestionSimpleModelImplCopyWith<
    _$ProductAskQuestionSimpleModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
