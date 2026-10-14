// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplyDiscountImpl _$$ApplyDiscountImplFromJson(Map<String, dynamic> json) =>
    _$ApplyDiscountImpl(
      discountId: json['DiscountId'] as String?,
      couponCode: json['CouponCode'] as String?,
      isCumulative: json['IsCumulative'] as bool? ?? false,
    );

Map<String, dynamic> _$$ApplyDiscountImplToJson(_$ApplyDiscountImpl instance) =>
    <String, dynamic>{
      if (instance.discountId case final value?) 'DiscountId': value,
      if (instance.couponCode case final value?) 'CouponCode': value,
      if (instance.isCumulative case final value?) 'IsCumulative': value,
    };
