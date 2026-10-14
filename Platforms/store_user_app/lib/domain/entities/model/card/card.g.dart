// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardImpl _$$CardImplFromJson(Map<String, dynamic> json) => _$CardImpl(
  externalId: json['ExternalId'] as String?,
  email: json['Email'] as String?,
  cardUserKey: json['CardUserKey'] as String?,
  cardToken: json['CardToken'] as String?,
  cardAlias: json['CardAlias'] as String?,
  binNumber: json['BinNumber'] as String?,
  lastFourDigits: json['LastFourDigits'] as String?,
  cardType: json['CardType'] as String?,
  cardAssociation: json['CardAssociation'] as String?,
  cardFamily: json['CardFamily'] as String?,
  cardBankCode: (json['CardBankCode'] as num?)?.toInt() ?? null,
  cardBankName: json['CardBankName'] as String?,
  status: json['Status'] as String?,
  statusCode: (json['StatusCode'] as num?)?.toInt(),
  errorCode: json['ErrorCode'] as String?,
  errorMessage: json['ErrorMessage'] as String?,
  errorGroup: json['ErrorGroup'] as String?,
  conversationId: json['ConversationId'] as String?,
  systemTime: (json['SystemTime'] as num?)?.toInt(),
  locale: json['Locale'] as String?,
);

Map<String, dynamic> _$$CardImplToJson(_$CardImpl instance) =>
    <String, dynamic>{
      if (instance.externalId case final value?) 'ExternalId': value,
      if (instance.email case final value?) 'Email': value,
      if (instance.cardUserKey case final value?) 'CardUserKey': value,
      if (instance.cardToken case final value?) 'CardToken': value,
      if (instance.cardAlias case final value?) 'CardAlias': value,
      if (instance.binNumber case final value?) 'BinNumber': value,
      if (instance.lastFourDigits case final value?) 'LastFourDigits': value,
      if (instance.cardType case final value?) 'CardType': value,
      if (instance.cardAssociation case final value?) 'CardAssociation': value,
      if (instance.cardFamily case final value?) 'CardFamily': value,
      if (instance.cardBankCode case final value?) 'CardBankCode': value,
      if (instance.cardBankName case final value?) 'CardBankName': value,
      if (instance.status case final value?) 'Status': value,
      if (instance.statusCode case final value?) 'StatusCode': value,
      if (instance.errorCode case final value?) 'ErrorCode': value,
      if (instance.errorMessage case final value?) 'ErrorMessage': value,
      if (instance.errorGroup case final value?) 'ErrorGroup': value,
      if (instance.conversationId case final value?) 'ConversationId': value,
      if (instance.systemTime case final value?) 'SystemTime': value,
      if (instance.locale case final value?) 'Locale': value,
    };
