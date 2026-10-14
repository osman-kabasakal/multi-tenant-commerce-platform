// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GiftVoucherModelImpl _$$GiftVoucherModelImplFromJson(
  Map<String, dynamic> json,
) => _$GiftVoucherModelImpl(
  isGiftVoucher: json['IsGiftVoucher'] as bool? ?? false,
  recipientName: json['RecipientName'] as String?,
  recipientEmail: json['RecipientEmail'] as String?,
  senderName: json['SenderName'] as String?,
  senderEmail: json['SenderEmail'] as String?,
  message: json['Message'] as String?,
  giftVoucherType:
      $enumDecodeNullable(_$GiftVoucherTypeEnumMap, json['GiftVoucherType']) ??
      GiftVoucherType.virtual,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$GiftVoucherModelImplToJson(
  _$GiftVoucherModelImpl instance,
) => <String, dynamic>{
  if (instance.isGiftVoucher case final value?) 'IsGiftVoucher': value,
  if (instance.recipientName case final value?) 'RecipientName': value,
  if (instance.recipientEmail case final value?) 'RecipientEmail': value,
  if (instance.senderName case final value?) 'SenderName': value,
  if (instance.senderEmail case final value?) 'SenderEmail': value,
  if (instance.message case final value?) 'Message': value,
  if (_$GiftVoucherTypeEnumMap[instance.giftVoucherType] case final value?)
    'GiftVoucherType': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$GiftVoucherTypeEnumMap = {
  GiftVoucherType.virtual: 0,
  GiftVoucherType.physical: 1,
};
