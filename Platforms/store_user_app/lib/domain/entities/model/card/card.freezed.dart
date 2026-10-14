// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Card _$CardFromJson(Map<String, dynamic> json) {
  return _Card.fromJson(json);
}

/// @nodoc
mixin _$Card {
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  String? get externalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardUserKey', includeIfNull: false)
  String? get cardUserKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardToken', includeIfNull: false)
  String? get cardToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardAlias', includeIfNull: false)
  String? get cardAlias => throw _privateConstructorUsedError;
  @JsonKey(name: 'BinNumber', includeIfNull: false)
  String? get binNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'LastFourDigits', includeIfNull: false)
  String? get lastFourDigits => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardType', includeIfNull: false)
  String? get cardType => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardAssociation', includeIfNull: false)
  String? get cardAssociation => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardFamily', includeIfNull: false)
  String? get cardFamily => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardBankCode', includeIfNull: false)
  int? get cardBankCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'CardBankName', includeIfNull: false)
  String? get cardBankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Status', includeIfNull: false)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'StatusCode', includeIfNull: false)
  int? get statusCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ErrorCode', includeIfNull: false)
  String? get errorCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ErrorMessage', includeIfNull: false)
  String? get errorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'ErrorGroup', includeIfNull: false)
  String? get errorGroup => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConversationId', includeIfNull: false)
  String? get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'SystemTime', includeIfNull: false)
  int? get systemTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'Locale', includeIfNull: false)
  String? get locale => throw _privateConstructorUsedError;

  /// Serializes this Card to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardCopyWith<Card> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardCopyWith<$Res> {
  factory $CardCopyWith(Card value, $Res Function(Card) then) =
      _$CardCopyWithImpl<$Res, Card>;
  @useResult
  $Res call({
    @JsonKey(name: 'ExternalId', includeIfNull: false) String? externalId,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'CardUserKey', includeIfNull: false) String? cardUserKey,
    @JsonKey(name: 'CardToken', includeIfNull: false) String? cardToken,
    @JsonKey(name: 'CardAlias', includeIfNull: false) String? cardAlias,
    @JsonKey(name: 'BinNumber', includeIfNull: false) String? binNumber,
    @JsonKey(name: 'LastFourDigits', includeIfNull: false)
    String? lastFourDigits,
    @JsonKey(name: 'CardType', includeIfNull: false) String? cardType,
    @JsonKey(name: 'CardAssociation', includeIfNull: false)
    String? cardAssociation,
    @JsonKey(name: 'CardFamily', includeIfNull: false) String? cardFamily,
    @JsonKey(name: 'CardBankCode', includeIfNull: false) int? cardBankCode,
    @JsonKey(name: 'CardBankName', includeIfNull: false) String? cardBankName,
    @JsonKey(name: 'Status', includeIfNull: false) String? status,
    @JsonKey(name: 'StatusCode', includeIfNull: false) int? statusCode,
    @JsonKey(name: 'ErrorCode', includeIfNull: false) String? errorCode,
    @JsonKey(name: 'ErrorMessage', includeIfNull: false) String? errorMessage,
    @JsonKey(name: 'ErrorGroup', includeIfNull: false) String? errorGroup,
    @JsonKey(name: 'ConversationId', includeIfNull: false)
    String? conversationId,
    @JsonKey(name: 'SystemTime', includeIfNull: false) int? systemTime,
    @JsonKey(name: 'Locale', includeIfNull: false) String? locale,
  });
}

/// @nodoc
class _$CardCopyWithImpl<$Res, $Val extends Card>
    implements $CardCopyWith<$Res> {
  _$CardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalId = freezed,
    Object? email = freezed,
    Object? cardUserKey = freezed,
    Object? cardToken = freezed,
    Object? cardAlias = freezed,
    Object? binNumber = freezed,
    Object? lastFourDigits = freezed,
    Object? cardType = freezed,
    Object? cardAssociation = freezed,
    Object? cardFamily = freezed,
    Object? cardBankCode = freezed,
    Object? cardBankName = freezed,
    Object? status = freezed,
    Object? statusCode = freezed,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? errorGroup = freezed,
    Object? conversationId = freezed,
    Object? systemTime = freezed,
    Object? locale = freezed,
  }) {
    return _then(
      _value.copyWith(
            externalId:
                freezed == externalId
                    ? _value.externalId
                    : externalId // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardUserKey:
                freezed == cardUserKey
                    ? _value.cardUserKey
                    : cardUserKey // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardToken:
                freezed == cardToken
                    ? _value.cardToken
                    : cardToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardAlias:
                freezed == cardAlias
                    ? _value.cardAlias
                    : cardAlias // ignore: cast_nullable_to_non_nullable
                        as String?,
            binNumber:
                freezed == binNumber
                    ? _value.binNumber
                    : binNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastFourDigits:
                freezed == lastFourDigits
                    ? _value.lastFourDigits
                    : lastFourDigits // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardType:
                freezed == cardType
                    ? _value.cardType
                    : cardType // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardAssociation:
                freezed == cardAssociation
                    ? _value.cardAssociation
                    : cardAssociation // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardFamily:
                freezed == cardFamily
                    ? _value.cardFamily
                    : cardFamily // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardBankCode:
                freezed == cardBankCode
                    ? _value.cardBankCode
                    : cardBankCode // ignore: cast_nullable_to_non_nullable
                        as int?,
            cardBankName:
                freezed == cardBankName
                    ? _value.cardBankName
                    : cardBankName // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            statusCode:
                freezed == statusCode
                    ? _value.statusCode
                    : statusCode // ignore: cast_nullable_to_non_nullable
                        as int?,
            errorCode:
                freezed == errorCode
                    ? _value.errorCode
                    : errorCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorGroup:
                freezed == errorGroup
                    ? _value.errorGroup
                    : errorGroup // ignore: cast_nullable_to_non_nullable
                        as String?,
            conversationId:
                freezed == conversationId
                    ? _value.conversationId
                    : conversationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            systemTime:
                freezed == systemTime
                    ? _value.systemTime
                    : systemTime // ignore: cast_nullable_to_non_nullable
                        as int?,
            locale:
                freezed == locale
                    ? _value.locale
                    : locale // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardImplCopyWith<$Res> implements $CardCopyWith<$Res> {
  factory _$$CardImplCopyWith(
    _$CardImpl value,
    $Res Function(_$CardImpl) then,
  ) = __$$CardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ExternalId', includeIfNull: false) String? externalId,
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'CardUserKey', includeIfNull: false) String? cardUserKey,
    @JsonKey(name: 'CardToken', includeIfNull: false) String? cardToken,
    @JsonKey(name: 'CardAlias', includeIfNull: false) String? cardAlias,
    @JsonKey(name: 'BinNumber', includeIfNull: false) String? binNumber,
    @JsonKey(name: 'LastFourDigits', includeIfNull: false)
    String? lastFourDigits,
    @JsonKey(name: 'CardType', includeIfNull: false) String? cardType,
    @JsonKey(name: 'CardAssociation', includeIfNull: false)
    String? cardAssociation,
    @JsonKey(name: 'CardFamily', includeIfNull: false) String? cardFamily,
    @JsonKey(name: 'CardBankCode', includeIfNull: false) int? cardBankCode,
    @JsonKey(name: 'CardBankName', includeIfNull: false) String? cardBankName,
    @JsonKey(name: 'Status', includeIfNull: false) String? status,
    @JsonKey(name: 'StatusCode', includeIfNull: false) int? statusCode,
    @JsonKey(name: 'ErrorCode', includeIfNull: false) String? errorCode,
    @JsonKey(name: 'ErrorMessage', includeIfNull: false) String? errorMessage,
    @JsonKey(name: 'ErrorGroup', includeIfNull: false) String? errorGroup,
    @JsonKey(name: 'ConversationId', includeIfNull: false)
    String? conversationId,
    @JsonKey(name: 'SystemTime', includeIfNull: false) int? systemTime,
    @JsonKey(name: 'Locale', includeIfNull: false) String? locale,
  });
}

/// @nodoc
class __$$CardImplCopyWithImpl<$Res>
    extends _$CardCopyWithImpl<$Res, _$CardImpl>
    implements _$$CardImplCopyWith<$Res> {
  __$$CardImplCopyWithImpl(_$CardImpl _value, $Res Function(_$CardImpl) _then)
    : super(_value, _then);

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalId = freezed,
    Object? email = freezed,
    Object? cardUserKey = freezed,
    Object? cardToken = freezed,
    Object? cardAlias = freezed,
    Object? binNumber = freezed,
    Object? lastFourDigits = freezed,
    Object? cardType = freezed,
    Object? cardAssociation = freezed,
    Object? cardFamily = freezed,
    Object? cardBankCode = freezed,
    Object? cardBankName = freezed,
    Object? status = freezed,
    Object? statusCode = freezed,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? errorGroup = freezed,
    Object? conversationId = freezed,
    Object? systemTime = freezed,
    Object? locale = freezed,
  }) {
    return _then(
      _$CardImpl(
        externalId:
            freezed == externalId
                ? _value.externalId
                : externalId // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardUserKey:
            freezed == cardUserKey
                ? _value.cardUserKey
                : cardUserKey // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardToken:
            freezed == cardToken
                ? _value.cardToken
                : cardToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardAlias:
            freezed == cardAlias
                ? _value.cardAlias
                : cardAlias // ignore: cast_nullable_to_non_nullable
                    as String?,
        binNumber:
            freezed == binNumber
                ? _value.binNumber
                : binNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastFourDigits:
            freezed == lastFourDigits
                ? _value.lastFourDigits
                : lastFourDigits // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardType:
            freezed == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardAssociation:
            freezed == cardAssociation
                ? _value.cardAssociation
                : cardAssociation // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardFamily:
            freezed == cardFamily
                ? _value.cardFamily
                : cardFamily // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardBankCode:
            freezed == cardBankCode
                ? _value.cardBankCode
                : cardBankCode // ignore: cast_nullable_to_non_nullable
                    as int?,
        cardBankName:
            freezed == cardBankName
                ? _value.cardBankName
                : cardBankName // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        statusCode:
            freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                    as int?,
        errorCode:
            freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorGroup:
            freezed == errorGroup
                ? _value.errorGroup
                : errorGroup // ignore: cast_nullable_to_non_nullable
                    as String?,
        conversationId:
            freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        systemTime:
            freezed == systemTime
                ? _value.systemTime
                : systemTime // ignore: cast_nullable_to_non_nullable
                    as int?,
        locale:
            freezed == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardImpl implements _Card {
  _$CardImpl({
    @JsonKey(name: 'ExternalId', includeIfNull: false) this.externalId,
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'CardUserKey', includeIfNull: false) this.cardUserKey,
    @JsonKey(name: 'CardToken', includeIfNull: false) this.cardToken,
    @JsonKey(name: 'CardAlias', includeIfNull: false) this.cardAlias,
    @JsonKey(name: 'BinNumber', includeIfNull: false) this.binNumber,
    @JsonKey(name: 'LastFourDigits', includeIfNull: false) this.lastFourDigits,
    @JsonKey(name: 'CardType', includeIfNull: false) this.cardType,
    @JsonKey(name: 'CardAssociation', includeIfNull: false)
    this.cardAssociation,
    @JsonKey(name: 'CardFamily', includeIfNull: false) this.cardFamily,
    @JsonKey(name: 'CardBankCode', includeIfNull: false)
    this.cardBankCode = null,
    @JsonKey(name: 'CardBankName', includeIfNull: false) this.cardBankName,
    @JsonKey(name: 'Status', includeIfNull: false) this.status,
    @JsonKey(name: 'StatusCode', includeIfNull: false) this.statusCode,
    @JsonKey(name: 'ErrorCode', includeIfNull: false) this.errorCode,
    @JsonKey(name: 'ErrorMessage', includeIfNull: false) this.errorMessage,
    @JsonKey(name: 'ErrorGroup', includeIfNull: false) this.errorGroup,
    @JsonKey(name: 'ConversationId', includeIfNull: false) this.conversationId,
    @JsonKey(name: 'SystemTime', includeIfNull: false) this.systemTime,
    @JsonKey(name: 'Locale', includeIfNull: false) this.locale,
  });

  factory _$CardImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardImplFromJson(json);

  @override
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  final String? externalId;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'CardUserKey', includeIfNull: false)
  final String? cardUserKey;
  @override
  @JsonKey(name: 'CardToken', includeIfNull: false)
  final String? cardToken;
  @override
  @JsonKey(name: 'CardAlias', includeIfNull: false)
  final String? cardAlias;
  @override
  @JsonKey(name: 'BinNumber', includeIfNull: false)
  final String? binNumber;
  @override
  @JsonKey(name: 'LastFourDigits', includeIfNull: false)
  final String? lastFourDigits;
  @override
  @JsonKey(name: 'CardType', includeIfNull: false)
  final String? cardType;
  @override
  @JsonKey(name: 'CardAssociation', includeIfNull: false)
  final String? cardAssociation;
  @override
  @JsonKey(name: 'CardFamily', includeIfNull: false)
  final String? cardFamily;
  @override
  @JsonKey(name: 'CardBankCode', includeIfNull: false)
  final int? cardBankCode;
  @override
  @JsonKey(name: 'CardBankName', includeIfNull: false)
  final String? cardBankName;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  final String? status;
  @override
  @JsonKey(name: 'StatusCode', includeIfNull: false)
  final int? statusCode;
  @override
  @JsonKey(name: 'ErrorCode', includeIfNull: false)
  final String? errorCode;
  @override
  @JsonKey(name: 'ErrorMessage', includeIfNull: false)
  final String? errorMessage;
  @override
  @JsonKey(name: 'ErrorGroup', includeIfNull: false)
  final String? errorGroup;
  @override
  @JsonKey(name: 'ConversationId', includeIfNull: false)
  final String? conversationId;
  @override
  @JsonKey(name: 'SystemTime', includeIfNull: false)
  final int? systemTime;
  @override
  @JsonKey(name: 'Locale', includeIfNull: false)
  final String? locale;

  @override
  String toString() {
    return 'Card(externalId: $externalId, email: $email, cardUserKey: $cardUserKey, cardToken: $cardToken, cardAlias: $cardAlias, binNumber: $binNumber, lastFourDigits: $lastFourDigits, cardType: $cardType, cardAssociation: $cardAssociation, cardFamily: $cardFamily, cardBankCode: $cardBankCode, cardBankName: $cardBankName, status: $status, statusCode: $statusCode, errorCode: $errorCode, errorMessage: $errorMessage, errorGroup: $errorGroup, conversationId: $conversationId, systemTime: $systemTime, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardImpl &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cardUserKey, cardUserKey) ||
                other.cardUserKey == cardUserKey) &&
            (identical(other.cardToken, cardToken) ||
                other.cardToken == cardToken) &&
            (identical(other.cardAlias, cardAlias) ||
                other.cardAlias == cardAlias) &&
            (identical(other.binNumber, binNumber) ||
                other.binNumber == binNumber) &&
            (identical(other.lastFourDigits, lastFourDigits) ||
                other.lastFourDigits == lastFourDigits) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.cardAssociation, cardAssociation) ||
                other.cardAssociation == cardAssociation) &&
            (identical(other.cardFamily, cardFamily) ||
                other.cardFamily == cardFamily) &&
            (identical(other.cardBankCode, cardBankCode) ||
                other.cardBankCode == cardBankCode) &&
            (identical(other.cardBankName, cardBankName) ||
                other.cardBankName == cardBankName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.errorGroup, errorGroup) ||
                other.errorGroup == errorGroup) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.systemTime, systemTime) ||
                other.systemTime == systemTime) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    externalId,
    email,
    cardUserKey,
    cardToken,
    cardAlias,
    binNumber,
    lastFourDigits,
    cardType,
    cardAssociation,
    cardFamily,
    cardBankCode,
    cardBankName,
    status,
    statusCode,
    errorCode,
    errorMessage,
    errorGroup,
    conversationId,
    systemTime,
    locale,
  ]);

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardImplCopyWith<_$CardImpl> get copyWith =>
      __$$CardImplCopyWithImpl<_$CardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardImplToJson(this);
  }
}

abstract class _Card implements Card {
  factory _Card({
    @JsonKey(name: 'ExternalId', includeIfNull: false) final String? externalId,
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'CardUserKey', includeIfNull: false)
    final String? cardUserKey,
    @JsonKey(name: 'CardToken', includeIfNull: false) final String? cardToken,
    @JsonKey(name: 'CardAlias', includeIfNull: false) final String? cardAlias,
    @JsonKey(name: 'BinNumber', includeIfNull: false) final String? binNumber,
    @JsonKey(name: 'LastFourDigits', includeIfNull: false)
    final String? lastFourDigits,
    @JsonKey(name: 'CardType', includeIfNull: false) final String? cardType,
    @JsonKey(name: 'CardAssociation', includeIfNull: false)
    final String? cardAssociation,
    @JsonKey(name: 'CardFamily', includeIfNull: false) final String? cardFamily,
    @JsonKey(name: 'CardBankCode', includeIfNull: false)
    final int? cardBankCode,
    @JsonKey(name: 'CardBankName', includeIfNull: false)
    final String? cardBankName,
    @JsonKey(name: 'Status', includeIfNull: false) final String? status,
    @JsonKey(name: 'StatusCode', includeIfNull: false) final int? statusCode,
    @JsonKey(name: 'ErrorCode', includeIfNull: false) final String? errorCode,
    @JsonKey(name: 'ErrorMessage', includeIfNull: false)
    final String? errorMessage,
    @JsonKey(name: 'ErrorGroup', includeIfNull: false) final String? errorGroup,
    @JsonKey(name: 'ConversationId', includeIfNull: false)
    final String? conversationId,
    @JsonKey(name: 'SystemTime', includeIfNull: false) final int? systemTime,
    @JsonKey(name: 'Locale', includeIfNull: false) final String? locale,
  }) = _$CardImpl;

  factory _Card.fromJson(Map<String, dynamic> json) = _$CardImpl.fromJson;

  @override
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  String? get externalId;
  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'CardUserKey', includeIfNull: false)
  String? get cardUserKey;
  @override
  @JsonKey(name: 'CardToken', includeIfNull: false)
  String? get cardToken;
  @override
  @JsonKey(name: 'CardAlias', includeIfNull: false)
  String? get cardAlias;
  @override
  @JsonKey(name: 'BinNumber', includeIfNull: false)
  String? get binNumber;
  @override
  @JsonKey(name: 'LastFourDigits', includeIfNull: false)
  String? get lastFourDigits;
  @override
  @JsonKey(name: 'CardType', includeIfNull: false)
  String? get cardType;
  @override
  @JsonKey(name: 'CardAssociation', includeIfNull: false)
  String? get cardAssociation;
  @override
  @JsonKey(name: 'CardFamily', includeIfNull: false)
  String? get cardFamily;
  @override
  @JsonKey(name: 'CardBankCode', includeIfNull: false)
  int? get cardBankCode;
  @override
  @JsonKey(name: 'CardBankName', includeIfNull: false)
  String? get cardBankName;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  String? get status;
  @override
  @JsonKey(name: 'StatusCode', includeIfNull: false)
  int? get statusCode;
  @override
  @JsonKey(name: 'ErrorCode', includeIfNull: false)
  String? get errorCode;
  @override
  @JsonKey(name: 'ErrorMessage', includeIfNull: false)
  String? get errorMessage;
  @override
  @JsonKey(name: 'ErrorGroup', includeIfNull: false)
  String? get errorGroup;
  @override
  @JsonKey(name: 'ConversationId', includeIfNull: false)
  String? get conversationId;
  @override
  @JsonKey(name: 'SystemTime', includeIfNull: false)
  int? get systemTime;
  @override
  @JsonKey(name: 'Locale', includeIfNull: false)
  String? get locale;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardImplCopyWith<_$CardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
