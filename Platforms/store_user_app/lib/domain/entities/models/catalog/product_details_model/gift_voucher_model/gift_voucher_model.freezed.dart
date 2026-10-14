// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_voucher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GiftVoucherModel _$GiftVoucherModelFromJson(Map<String, dynamic> json) {
  return _GiftVoucherModel.fromJson(json);
}

/// @nodoc
mixin _$GiftVoucherModel {
  @JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
  bool? get isGiftVoucher => throw _privateConstructorUsedError;
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  String? get recipientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  String? get recipientEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'SenderName', includeIfNull: false)
  String? get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  String? get senderEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
  GiftVoucherType? get giftVoucherType => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this GiftVoucherModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftVoucherModelCopyWith<GiftVoucherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftVoucherModelCopyWith<$Res> {
  factory $GiftVoucherModelCopyWith(
    GiftVoucherModel value,
    $Res Function(GiftVoucherModel) then,
  ) = _$GiftVoucherModelCopyWithImpl<$Res, GiftVoucherModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'IsGiftVoucher', includeIfNull: false) bool? isGiftVoucher,
    @JsonKey(name: 'RecipientName', includeIfNull: false) String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
    GiftVoucherType? giftVoucherType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$GiftVoucherModelCopyWithImpl<$Res, $Val extends GiftVoucherModel>
    implements $GiftVoucherModelCopyWith<$Res> {
  _$GiftVoucherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGiftVoucher = freezed,
    Object? recipientName = freezed,
    Object? recipientEmail = freezed,
    Object? senderName = freezed,
    Object? senderEmail = freezed,
    Object? message = freezed,
    Object? giftVoucherType = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            isGiftVoucher:
                freezed == isGiftVoucher
                    ? _value.isGiftVoucher
                    : isGiftVoucher // ignore: cast_nullable_to_non_nullable
                        as bool?,
            recipientName:
                freezed == recipientName
                    ? _value.recipientName
                    : recipientName // ignore: cast_nullable_to_non_nullable
                        as String?,
            recipientEmail:
                freezed == recipientEmail
                    ? _value.recipientEmail
                    : recipientEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            senderName:
                freezed == senderName
                    ? _value.senderName
                    : senderName // ignore: cast_nullable_to_non_nullable
                        as String?,
            senderEmail:
                freezed == senderEmail
                    ? _value.senderEmail
                    : senderEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            giftVoucherType:
                freezed == giftVoucherType
                    ? _value.giftVoucherType
                    : giftVoucherType // ignore: cast_nullable_to_non_nullable
                        as GiftVoucherType?,
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
abstract class _$$GiftVoucherModelImplCopyWith<$Res>
    implements $GiftVoucherModelCopyWith<$Res> {
  factory _$$GiftVoucherModelImplCopyWith(
    _$GiftVoucherModelImpl value,
    $Res Function(_$GiftVoucherModelImpl) then,
  ) = __$$GiftVoucherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'IsGiftVoucher', includeIfNull: false) bool? isGiftVoucher,
    @JsonKey(name: 'RecipientName', includeIfNull: false) String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
    GiftVoucherType? giftVoucherType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$GiftVoucherModelImplCopyWithImpl<$Res>
    extends _$GiftVoucherModelCopyWithImpl<$Res, _$GiftVoucherModelImpl>
    implements _$$GiftVoucherModelImplCopyWith<$Res> {
  __$$GiftVoucherModelImplCopyWithImpl(
    _$GiftVoucherModelImpl _value,
    $Res Function(_$GiftVoucherModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GiftVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGiftVoucher = freezed,
    Object? recipientName = freezed,
    Object? recipientEmail = freezed,
    Object? senderName = freezed,
    Object? senderEmail = freezed,
    Object? message = freezed,
    Object? giftVoucherType = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$GiftVoucherModelImpl(
        isGiftVoucher:
            freezed == isGiftVoucher
                ? _value.isGiftVoucher
                : isGiftVoucher // ignore: cast_nullable_to_non_nullable
                    as bool?,
        recipientName:
            freezed == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
                    as String?,
        recipientEmail:
            freezed == recipientEmail
                ? _value.recipientEmail
                : recipientEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        senderName:
            freezed == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                    as String?,
        senderEmail:
            freezed == senderEmail
                ? _value.senderEmail
                : senderEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        giftVoucherType:
            freezed == giftVoucherType
                ? _value.giftVoucherType
                : giftVoucherType // ignore: cast_nullable_to_non_nullable
                    as GiftVoucherType?,
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
class _$GiftVoucherModelImpl implements _GiftVoucherModel {
  _$GiftVoucherModelImpl({
    @JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
    this.isGiftVoucher = false,
    @JsonKey(name: 'RecipientName', includeIfNull: false) this.recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false) this.recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) this.senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) this.senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
    @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
    this.giftVoucherType = GiftVoucherType.virtual,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$GiftVoucherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftVoucherModelImplFromJson(json);

  @override
  @JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
  final bool? isGiftVoucher;
  @override
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  final String? recipientName;
  @override
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  final String? recipientEmail;
  @override
  @JsonKey(name: 'SenderName', includeIfNull: false)
  final String? senderName;
  @override
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  final String? senderEmail;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final String? message;
  @override
  @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
  final GiftVoucherType? giftVoucherType;
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
    return 'GiftVoucherModel(isGiftVoucher: $isGiftVoucher, recipientName: $recipientName, recipientEmail: $recipientEmail, senderName: $senderName, senderEmail: $senderEmail, message: $message, giftVoucherType: $giftVoucherType, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftVoucherModelImpl &&
            (identical(other.isGiftVoucher, isGiftVoucher) ||
                other.isGiftVoucher == isGiftVoucher) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientEmail, recipientEmail) ||
                other.recipientEmail == recipientEmail) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderEmail, senderEmail) ||
                other.senderEmail == senderEmail) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.giftVoucherType, giftVoucherType) ||
                other.giftVoucherType == giftVoucherType) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isGiftVoucher,
    recipientName,
    recipientEmail,
    senderName,
    senderEmail,
    message,
    giftVoucherType,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of GiftVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftVoucherModelImplCopyWith<_$GiftVoucherModelImpl> get copyWith =>
      __$$GiftVoucherModelImplCopyWithImpl<_$GiftVoucherModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftVoucherModelImplToJson(this);
  }
}

abstract class _GiftVoucherModel implements GiftVoucherModel {
  factory _GiftVoucherModel({
    @JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
    final bool? isGiftVoucher,
    @JsonKey(name: 'RecipientName', includeIfNull: false)
    final String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    final String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) final String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false)
    final String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) final String? message,
    @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
    final GiftVoucherType? giftVoucherType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$GiftVoucherModelImpl;

  factory _GiftVoucherModel.fromJson(Map<String, dynamic> json) =
      _$GiftVoucherModelImpl.fromJson;

  @override
  @JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
  bool? get isGiftVoucher;
  @override
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  String? get recipientName;
  @override
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  String? get recipientEmail;
  @override
  @JsonKey(name: 'SenderName', includeIfNull: false)
  String? get senderName;
  @override
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  String? get senderEmail;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message;
  @override
  @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
  GiftVoucherType? get giftVoucherType;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of GiftVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftVoucherModelImplCopyWith<_$GiftVoucherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
