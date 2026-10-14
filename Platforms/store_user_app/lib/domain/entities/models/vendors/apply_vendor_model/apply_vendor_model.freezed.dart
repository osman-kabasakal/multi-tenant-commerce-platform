// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apply_vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplyVendorModel _$ApplyVendorModelFromJson(Map<String, dynamic> json) {
  return _ApplyVendorModel.fromJson(json);
}

/// @nodoc
mixin _$ApplyVendorModel {
  @JsonKey(name: 'Address', includeIfNull: false)
  VendorAddressModel? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
  bool? get termsOfServiceEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  bool? get termsOfServicePopup => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableFormInput', includeIfNull: false)
  bool? get disableFormInput => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ApplyVendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplyVendorModelCopyWith<ApplyVendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplyVendorModelCopyWith<$Res> {
  factory $ApplyVendorModelCopyWith(
    ApplyVendorModel value,
    $Res Function(ApplyVendorModel) then,
  ) = _$ApplyVendorModelCopyWithImpl<$Res, ApplyVendorModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Address', includeIfNull: false) VendorAddressModel? address,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
    bool? termsOfServiceEnabled,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    bool? termsOfServicePopup,
    @JsonKey(name: 'DisableFormInput', includeIfNull: false)
    bool? disableFormInput,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $VendorAddressModelCopyWith<$Res>? get address;
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$ApplyVendorModelCopyWithImpl<$Res, $Val extends ApplyVendorModel>
    implements $ApplyVendorModelCopyWith<$Res> {
  _$ApplyVendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? description = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? termsOfServiceEnabled = freezed,
    Object? termsOfServicePopup = freezed,
    Object? disableFormInput = freezed,
    Object? result = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as VendorAddressModel?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
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
            termsOfServiceEnabled:
                freezed == termsOfServiceEnabled
                    ? _value.termsOfServiceEnabled
                    : termsOfServiceEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            termsOfServicePopup:
                freezed == termsOfServicePopup
                    ? _value.termsOfServicePopup
                    : termsOfServicePopup // ignore: cast_nullable_to_non_nullable
                        as bool?,
            disableFormInput:
                freezed == disableFormInput
                    ? _value.disableFormInput
                    : disableFormInput // ignore: cast_nullable_to_non_nullable
                        as bool?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorAddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $VendorAddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of ApplyVendorModel
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
abstract class _$$ApplyVendorModelImplCopyWith<$Res>
    implements $ApplyVendorModelCopyWith<$Res> {
  factory _$$ApplyVendorModelImplCopyWith(
    _$ApplyVendorModelImpl value,
    $Res Function(_$ApplyVendorModelImpl) then,
  ) = __$$ApplyVendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Address', includeIfNull: false) VendorAddressModel? address,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
    bool? termsOfServiceEnabled,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    bool? termsOfServicePopup,
    @JsonKey(name: 'DisableFormInput', includeIfNull: false)
    bool? disableFormInput,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $VendorAddressModelCopyWith<$Res>? get address;
  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$ApplyVendorModelImplCopyWithImpl<$Res>
    extends _$ApplyVendorModelCopyWithImpl<$Res, _$ApplyVendorModelImpl>
    implements _$$ApplyVendorModelImplCopyWith<$Res> {
  __$$ApplyVendorModelImplCopyWithImpl(
    _$ApplyVendorModelImpl _value,
    $Res Function(_$ApplyVendorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? description = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? termsOfServiceEnabled = freezed,
    Object? termsOfServicePopup = freezed,
    Object? disableFormInput = freezed,
    Object? result = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ApplyVendorModelImpl(
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as VendorAddressModel?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
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
        termsOfServiceEnabled:
            freezed == termsOfServiceEnabled
                ? _value.termsOfServiceEnabled
                : termsOfServiceEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        termsOfServicePopup:
            freezed == termsOfServicePopup
                ? _value.termsOfServicePopup
                : termsOfServicePopup // ignore: cast_nullable_to_non_nullable
                    as bool?,
        disableFormInput:
            freezed == disableFormInput
                ? _value.disableFormInput
                : disableFormInput // ignore: cast_nullable_to_non_nullable
                    as bool?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
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
class _$ApplyVendorModelImpl implements _ApplyVendorModel {
  _$ApplyVendorModelImpl({
    @JsonKey(name: 'Address', includeIfNull: false) this.address,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
    this.termsOfServiceEnabled = false,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    this.termsOfServicePopup = false,
    @JsonKey(name: 'DisableFormInput', includeIfNull: false)
    this.disableFormInput = false,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ApplyVendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplyVendorModelImplFromJson(json);

  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  final VendorAddressModel? address;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
  @override
  @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
  final bool? termsOfServiceEnabled;
  @override
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  final bool? termsOfServicePopup;
  @override
  @JsonKey(name: 'DisableFormInput', includeIfNull: false)
  final bool? disableFormInput;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
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
    return 'ApplyVendorModel(address: $address, name: $name, email: $email, description: $description, displayCaptcha: $displayCaptcha, captcha: $captcha, termsOfServiceEnabled: $termsOfServiceEnabled, termsOfServicePopup: $termsOfServicePopup, disableFormInput: $disableFormInput, result: $result, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyVendorModelImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            (identical(other.termsOfServiceEnabled, termsOfServiceEnabled) ||
                other.termsOfServiceEnabled == termsOfServiceEnabled) &&
            (identical(other.termsOfServicePopup, termsOfServicePopup) ||
                other.termsOfServicePopup == termsOfServicePopup) &&
            (identical(other.disableFormInput, disableFormInput) ||
                other.disableFormInput == disableFormInput) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    address,
    name,
    email,
    description,
    displayCaptcha,
    captcha,
    termsOfServiceEnabled,
    termsOfServicePopup,
    disableFormInput,
    result,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyVendorModelImplCopyWith<_$ApplyVendorModelImpl> get copyWith =>
      __$$ApplyVendorModelImplCopyWithImpl<_$ApplyVendorModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplyVendorModelImplToJson(this);
  }
}

abstract class _ApplyVendorModel implements ApplyVendorModel {
  factory _ApplyVendorModel({
    @JsonKey(name: 'Address', includeIfNull: false)
    final VendorAddressModel? address,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
    final bool? termsOfServiceEnabled,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    final bool? termsOfServicePopup,
    @JsonKey(name: 'DisableFormInput', includeIfNull: false)
    final bool? disableFormInput,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ApplyVendorModelImpl;

  factory _ApplyVendorModel.fromJson(Map<String, dynamic> json) =
      _$ApplyVendorModelImpl.fromJson;

  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  VendorAddressModel? get address;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
  bool? get termsOfServiceEnabled;
  @override
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  bool? get termsOfServicePopup;
  @override
  @JsonKey(name: 'DisableFormInput', includeIfNull: false)
  bool? get disableFormInput;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ApplyVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyVendorModelImplCopyWith<_$ApplyVendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
