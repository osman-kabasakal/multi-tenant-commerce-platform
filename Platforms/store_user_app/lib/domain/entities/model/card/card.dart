import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'card.freezed.dart';
part 'card.g.dart';

@freezed
class Card extends StoreJsonSerializable<Card> with _$Card {
  factory Card({ 
    @JsonKey(name: 'ExternalId', includeIfNull: false)
     String? externalId,

    @JsonKey(name: 'Email', includeIfNull: false)
     String? email,

    @JsonKey(name: 'CardUserKey', includeIfNull: false)
     String? cardUserKey,

    @JsonKey(name: 'CardToken', includeIfNull: false)
     String? cardToken,

    @JsonKey(name: 'CardAlias', includeIfNull: false)
     String? cardAlias,

    @JsonKey(name: 'BinNumber', includeIfNull: false)
     String? binNumber,

    @JsonKey(name: 'LastFourDigits', includeIfNull: false)
     String? lastFourDigits,

    @JsonKey(name: 'CardType', includeIfNull: false)
     String? cardType,

    @JsonKey(name: 'CardAssociation', includeIfNull: false)
     String? cardAssociation,

    @JsonKey(name: 'CardFamily', includeIfNull: false)
     String? cardFamily,

    @JsonKey(name: 'CardBankCode', includeIfNull: false)
    @Default(null) int? cardBankCode,

    @JsonKey(name: 'CardBankName', includeIfNull: false)
     String? cardBankName,

    @JsonKey(name: 'Status', includeIfNull: false)
     String? status,

    @JsonKey(name: 'StatusCode', includeIfNull: false)
     int? statusCode,

    @JsonKey(name: 'ErrorCode', includeIfNull: false)
     String? errorCode,

    @JsonKey(name: 'ErrorMessage', includeIfNull: false)
     String? errorMessage,

    @JsonKey(name: 'ErrorGroup', includeIfNull: false)
     String? errorGroup,

    @JsonKey(name: 'ConversationId', includeIfNull: false)
     String? conversationId,

    @JsonKey(name: 'SystemTime', includeIfNull: false)
     int? systemTime,

    @JsonKey(name: 'Locale', includeIfNull: false)
     String? locale
}) = _Card;

  factory Card.fromJson(Map<String, dynamic> json) =>
      _$CardFromJson(json);
}