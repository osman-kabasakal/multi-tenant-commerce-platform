// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscountInfoModelImpl _$$DiscountInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscountInfoModelImpl(
  couponCode: json['CouponCode'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DiscountInfoModelImplToJson(
  _$DiscountInfoModelImpl instance,
) => <String, dynamic>{
  if (instance.couponCode case final value?) 'CouponCode': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
