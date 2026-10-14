// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installmentDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentDetail _$InstallmentDetailFromJson(Map<String, dynamic> json) =>
    InstallmentDetail(
      binNumber: json['BinNumber'] as String?,
      commercial: (json['Commercial'] as num?)?.toInt(),
      price: json['Price'] as String?,
      cardType: json['CardType'] as String?,
      cardAssociation: json['CardAssociation'] as String?,
      cardFamilyName: json['CardFamilyName'] as String?,
      force3Ds: (json['Force3Ds'] as num?)?.toInt(),
      bankCode: (json['BankCode'] as num?)?.toInt(),
      bankName: json['BankName'] as String?,
      forceCvc: (json['ForceCvc'] as num?)?.toInt(),
      installmentPrices:
          (json['InstallmentPrices'] as List<dynamic>?)
              ?.map((e) => InstallmentPrice.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$InstallmentDetailToJson(InstallmentDetail instance) =>
    <String, dynamic>{
      'BinNumber': instance.binNumber,
      'Commercial': instance.commercial,
      'Price': instance.price,
      'CardType': instance.cardType,
      'CardAssociation': instance.cardAssociation,
      'CardFamilyName': instance.cardFamilyName,
      'Force3Ds': instance.force3Ds,
      'BankCode': instance.bankCode,
      'BankName': instance.bankName,
      'ForceCvc': instance.forceCvc,
      'InstallmentPrices': instance.installmentPrices,
    };
