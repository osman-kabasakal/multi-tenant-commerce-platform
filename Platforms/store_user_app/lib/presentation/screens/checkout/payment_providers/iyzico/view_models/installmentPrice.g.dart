// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installmentPrice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPrice _$InstallmentPriceFromJson(Map<String, dynamic> json) =>
    InstallmentPrice(
      price: json['Price'] as String?,
      totalPrice: json['TotalPrice'] as String?,
      installmentNumber: (json['InstallmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InstallmentPriceToJson(InstallmentPrice instance) =>
    <String, dynamic>{
      'Price': instance.price,
      'TotalPrice': instance.totalPrice,
      'InstallmentNumber': instance.installmentNumber,
    };
