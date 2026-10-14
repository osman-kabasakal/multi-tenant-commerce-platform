// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_us_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactUsModel _$ContactUsModelFromJson(Map<String, dynamic> json) {
  return _ContactUsModel.fromJson(json);
}

/// @nodoc
mixin _$ContactUsModel {
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'Subject', includeIfNull: false)
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
  bool? get subjectEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'Enquiry', includeIfNull: false)
  String? get enquiry => throw _privateConstructorUsedError;
  @JsonKey(name: 'FullName', includeIfNull: false)
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
  bool? get successfullySent => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
  String? get contactAttributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'ContactAttribute', includeIfNull: false)
  List<CustomAttribute>? get contactAttribute =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ContactAttributes', includeIfNull: false)
  List<ContactAttributeModel>? get contactAttributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ContactUsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactUsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactUsModelCopyWith<ContactUsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactUsModelCopyWith<$Res> {
  factory $ContactUsModelCopyWith(
    ContactUsModel value,
    $Res Function(ContactUsModel) then,
  ) = _$ContactUsModelCopyWithImpl<$Res, ContactUsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'Subject', includeIfNull: false) String? subject,
    @JsonKey(name: 'SubjectEnabled', includeIfNull: false) bool? subjectEnabled,
    @JsonKey(name: 'Enquiry', includeIfNull: false) String? enquiry,
    @JsonKey(name: 'FullName', includeIfNull: false) String? fullName,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
    String? contactAttributeInfo,
    @JsonKey(name: 'ContactAttribute', includeIfNull: false)
    List<CustomAttribute>? contactAttribute,
    @JsonKey(name: 'ContactAttributes', includeIfNull: false)
    List<ContactAttributeModel>? contactAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$ContactUsModelCopyWithImpl<$Res, $Val extends ContactUsModel>
    implements $ContactUsModelCopyWith<$Res> {
  _$ContactUsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactUsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? subject = freezed,
    Object? subjectEnabled = freezed,
    Object? enquiry = freezed,
    Object? fullName = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? attributes = freezed,
    Object? contactAttributeInfo = freezed,
    Object? contactAttribute = freezed,
    Object? contactAttributes = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            subject:
                freezed == subject
                    ? _value.subject
                    : subject // ignore: cast_nullable_to_non_nullable
                        as String?,
            subjectEnabled:
                freezed == subjectEnabled
                    ? _value.subjectEnabled
                    : subjectEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            enquiry:
                freezed == enquiry
                    ? _value.enquiry
                    : enquiry // ignore: cast_nullable_to_non_nullable
                        as String?,
            fullName:
                freezed == fullName
                    ? _value.fullName
                    : fullName // ignore: cast_nullable_to_non_nullable
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
            attributes:
                freezed == attributes
                    ? _value.attributes
                    : attributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttributeModel>?,
            contactAttributeInfo:
                freezed == contactAttributeInfo
                    ? _value.contactAttributeInfo
                    : contactAttributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            contactAttribute:
                freezed == contactAttribute
                    ? _value.contactAttribute
                    : contactAttribute // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttribute>?,
            contactAttributes:
                freezed == contactAttributes
                    ? _value.contactAttributes
                    : contactAttributes // ignore: cast_nullable_to_non_nullable
                        as List<ContactAttributeModel>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ContactUsModel
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
abstract class _$$ContactUsModelImplCopyWith<$Res>
    implements $ContactUsModelCopyWith<$Res> {
  factory _$$ContactUsModelImplCopyWith(
    _$ContactUsModelImpl value,
    $Res Function(_$ContactUsModelImpl) then,
  ) = __$$ContactUsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'Subject', includeIfNull: false) String? subject,
    @JsonKey(name: 'SubjectEnabled', includeIfNull: false) bool? subjectEnabled,
    @JsonKey(name: 'Enquiry', includeIfNull: false) String? enquiry,
    @JsonKey(name: 'FullName', includeIfNull: false) String? fullName,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
    String? contactAttributeInfo,
    @JsonKey(name: 'ContactAttribute', includeIfNull: false)
    List<CustomAttribute>? contactAttribute,
    @JsonKey(name: 'ContactAttributes', includeIfNull: false)
    List<ContactAttributeModel>? contactAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$ContactUsModelImplCopyWithImpl<$Res>
    extends _$ContactUsModelCopyWithImpl<$Res, _$ContactUsModelImpl>
    implements _$$ContactUsModelImplCopyWith<$Res> {
  __$$ContactUsModelImplCopyWithImpl(
    _$ContactUsModelImpl _value,
    $Res Function(_$ContactUsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactUsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? subject = freezed,
    Object? subjectEnabled = freezed,
    Object? enquiry = freezed,
    Object? fullName = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? attributes = freezed,
    Object? contactAttributeInfo = freezed,
    Object? contactAttribute = freezed,
    Object? contactAttributes = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ContactUsModelImpl(
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        subject:
            freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                    as String?,
        subjectEnabled:
            freezed == subjectEnabled
                ? _value.subjectEnabled
                : subjectEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        enquiry:
            freezed == enquiry
                ? _value.enquiry
                : enquiry // ignore: cast_nullable_to_non_nullable
                    as String?,
        fullName:
            freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
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
        attributes:
            freezed == attributes
                ? _value._attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttributeModel>?,
        contactAttributeInfo:
            freezed == contactAttributeInfo
                ? _value.contactAttributeInfo
                : contactAttributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        contactAttribute:
            freezed == contactAttribute
                ? _value._contactAttribute
                : contactAttribute // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttribute>?,
        contactAttributes:
            freezed == contactAttributes
                ? _value._contactAttributes
                : contactAttributes // ignore: cast_nullable_to_non_nullable
                    as List<ContactAttributeModel>?,
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
class _$ContactUsModelImpl implements _ContactUsModel {
  _$ContactUsModelImpl({
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'Subject', includeIfNull: false) this.subject,
    @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
    this.subjectEnabled = false,
    @JsonKey(name: 'Enquiry', includeIfNull: false) this.enquiry,
    @JsonKey(name: 'FullName', includeIfNull: false) this.fullName,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    this.successfullySent = false,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes = const [],
    @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
    this.contactAttributeInfo,
    @JsonKey(name: 'ContactAttribute', includeIfNull: false)
    final List<CustomAttribute>? contactAttribute = const [],
    @JsonKey(name: 'ContactAttributes', includeIfNull: false)
    final List<ContactAttributeModel>? contactAttributes = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _attributes = attributes,
       _contactAttribute = contactAttribute,
       _contactAttributes = contactAttributes,
       _userFields = userFields;

  factory _$ContactUsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactUsModelImplFromJson(json);

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'Subject', includeIfNull: false)
  final String? subject;
  @override
  @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
  final bool? subjectEnabled;
  @override
  @JsonKey(name: 'Enquiry', includeIfNull: false)
  final String? enquiry;
  @override
  @JsonKey(name: 'FullName', includeIfNull: false)
  final String? fullName;
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
  final List<CustomAttributeModel>? _attributes;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
  final String? contactAttributeInfo;
  final List<CustomAttribute>? _contactAttribute;
  @override
  @JsonKey(name: 'ContactAttribute', includeIfNull: false)
  List<CustomAttribute>? get contactAttribute {
    final value = _contactAttribute;
    if (value == null) return null;
    if (_contactAttribute is EqualUnmodifiableListView)
      return _contactAttribute;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ContactAttributeModel>? _contactAttributes;
  @override
  @JsonKey(name: 'ContactAttributes', includeIfNull: false)
  List<ContactAttributeModel>? get contactAttributes {
    final value = _contactAttributes;
    if (value == null) return null;
    if (_contactAttributes is EqualUnmodifiableListView)
      return _contactAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'ContactUsModel(email: $email, subject: $subject, subjectEnabled: $subjectEnabled, enquiry: $enquiry, fullName: $fullName, successfullySent: $successfullySent, result: $result, displayCaptcha: $displayCaptcha, captcha: $captcha, attributes: $attributes, contactAttributeInfo: $contactAttributeInfo, contactAttribute: $contactAttribute, contactAttributes: $contactAttributes, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactUsModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.subjectEnabled, subjectEnabled) ||
                other.subjectEnabled == subjectEnabled) &&
            (identical(other.enquiry, enquiry) || other.enquiry == enquiry) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.successfullySent, successfullySent) ||
                other.successfullySent == successfullySent) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ) &&
            (identical(other.contactAttributeInfo, contactAttributeInfo) ||
                other.contactAttributeInfo == contactAttributeInfo) &&
            const DeepCollectionEquality().equals(
              other._contactAttribute,
              _contactAttribute,
            ) &&
            const DeepCollectionEquality().equals(
              other._contactAttributes,
              _contactAttributes,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    subject,
    subjectEnabled,
    enquiry,
    fullName,
    successfullySent,
    result,
    displayCaptcha,
    captcha,
    const DeepCollectionEquality().hash(_attributes),
    contactAttributeInfo,
    const DeepCollectionEquality().hash(_contactAttribute),
    const DeepCollectionEquality().hash(_contactAttributes),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ContactUsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactUsModelImplCopyWith<_$ContactUsModelImpl> get copyWith =>
      __$$ContactUsModelImplCopyWithImpl<_$ContactUsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactUsModelImplToJson(this);
  }
}

abstract class _ContactUsModel implements ContactUsModel {
  factory _ContactUsModel({
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'Subject', includeIfNull: false) final String? subject,
    @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
    final bool? subjectEnabled,
    @JsonKey(name: 'Enquiry', includeIfNull: false) final String? enquiry,
    @JsonKey(name: 'FullName', includeIfNull: false) final String? fullName,
    @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
    final bool? successfullySent,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
    final String? contactAttributeInfo,
    @JsonKey(name: 'ContactAttribute', includeIfNull: false)
    final List<CustomAttribute>? contactAttribute,
    @JsonKey(name: 'ContactAttributes', includeIfNull: false)
    final List<ContactAttributeModel>? contactAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ContactUsModelImpl;

  factory _ContactUsModel.fromJson(Map<String, dynamic> json) =
      _$ContactUsModelImpl.fromJson;

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'Subject', includeIfNull: false)
  String? get subject;
  @override
  @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
  bool? get subjectEnabled;
  @override
  @JsonKey(name: 'Enquiry', includeIfNull: false)
  String? get enquiry;
  @override
  @JsonKey(name: 'FullName', includeIfNull: false)
  String? get fullName;
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
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes;
  @override
  @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
  String? get contactAttributeInfo;
  @override
  @JsonKey(name: 'ContactAttribute', includeIfNull: false)
  List<CustomAttribute>? get contactAttribute;
  @override
  @JsonKey(name: 'ContactAttributes', includeIfNull: false)
  List<ContactAttributeModel>? get contactAttributes;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ContactUsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactUsModelImplCopyWith<_$ContactUsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
