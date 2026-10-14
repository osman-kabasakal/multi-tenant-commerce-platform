// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GiftVoucherImpl _$$GiftVoucherImplFromJson(Map<String, dynamic> json) =>
    _$GiftVoucherImpl(
      couponCode: json['CouponCode'] as String?,
      amount: json['Amount'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GiftVoucherImplToJson(_$GiftVoucherImpl instance) =>
    <String, dynamic>{
      if (instance.couponCode case final value?) 'CouponCode': value,
      if (instance.amount case final value?) 'Amount': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
