// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactVendorModel _$ContactVendorModelFromJson(Map<String, dynamic> json) {
  return _ContactVendorModel.fromJson(json);
}

/// @nodoc
mixin _$ContactVendorModel {
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ContactVendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactVendorModelCopyWith<ContactVendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactVendorModelCopyWith<$Res> {
  factory $ContactVendorModelCopyWith(
    ContactVendorModel value,
    $Res Function(ContactVendorModel) then,
  ) = _$ContactVendorModelCopyWithImpl<$Res, ContactVendorModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
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
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$ContactVendorModelCopyWithImpl<$Res, $Val extends ContactVendorModel>
    implements $ContactVendorModelCopyWith<$Res> {
  _$ContactVendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? email = freezed,
    Object? subject = freezed,
    Object? subjectEnabled = freezed,
    Object? enquiry = freezed,
    Object? fullName = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorName:
                freezed == vendorName
                    ? _value.vendorName
                    : vendorName // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ContactVendorModel
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
abstract class _$$ContactVendorModelImplCopyWith<$Res>
    implements $ContactVendorModelCopyWith<$Res> {
  factory _$$ContactVendorModelImplCopyWith(
    _$ContactVendorModelImpl value,
    $Res Function(_$ContactVendorModelImpl) then,
  ) = __$$ContactVendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
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
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$ContactVendorModelImplCopyWithImpl<$Res>
    extends _$ContactVendorModelCopyWithImpl<$Res, _$ContactVendorModelImpl>
    implements _$$ContactVendorModelImplCopyWith<$Res> {
  __$$ContactVendorModelImplCopyWithImpl(
    _$ContactVendorModelImpl _value,
    $Res Function(_$ContactVendorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? email = freezed,
    Object? subject = freezed,
    Object? subjectEnabled = freezed,
    Object? enquiry = freezed,
    Object? fullName = freezed,
    Object? successfullySent = freezed,
    Object? result = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ContactVendorModelImpl(
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorName:
            freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$ContactVendorModelImpl implements _ContactVendorModel {
  _$ContactVendorModelImpl({
    @JsonKey(name: 'VendorId', includeIfNull: false) this.vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) this.vendorName,
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
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ContactVendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactVendorModelImplFromJson(json);

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  final String? vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  final String? vendorName;
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
    return 'ContactVendorModel(vendorId: $vendorId, vendorName: $vendorName, email: $email, subject: $subject, subjectEnabled: $subjectEnabled, enquiry: $enquiry, fullName: $fullName, successfullySent: $successfullySent, result: $result, displayCaptcha: $displayCaptcha, captcha: $captcha, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactVendorModelImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
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
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    vendorId,
    vendorName,
    email,
    subject,
    subjectEnabled,
    enquiry,
    fullName,
    successfullySent,
    result,
    displayCaptcha,
    captcha,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ContactVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactVendorModelImplCopyWith<_$ContactVendorModelImpl> get copyWith =>
      __$$ContactVendorModelImplCopyWithImpl<_$ContactVendorModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactVendorModelImplToJson(this);
  }
}

abstract class _ContactVendorModel implements ContactVendorModel {
  factory _ContactVendorModel({
    @JsonKey(name: 'VendorId', includeIfNull: false) final String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) final String? vendorName,
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
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ContactVendorModelImpl;

  factory _ContactVendorModel.fromJson(Map<String, dynamic> json) =
      _$ContactVendorModelImpl.fromJson;

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName;
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
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ContactVendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactVendorModelImplCopyWith<_$ContactVendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
