// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_loyalty_points_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerLoyaltyPointsModelImpl _$$CustomerLoyaltyPointsModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerLoyaltyPointsModelImpl(
  loyaltyPoints:
      (json['LoyaltyPoints'] as List<dynamic>?)
          ?.map(
            (e) =>
                LoyaltyPointsHistoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  loyaltyPointsBalance: (json['LoyaltyPointsBalance'] as num?)?.toInt(),
  loyaltyPointsAmount: json['LoyaltyPointsAmount'] as String?,
  minimumLoyaltyPointsBalance:
      (json['MinimumLoyaltyPointsBalance'] as num?)?.toInt(),
  minimumLoyaltyPointsAmount: json['MinimumLoyaltyPointsAmount'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerLoyaltyPointsModelImplToJson(
  _$CustomerLoyaltyPointsModelImpl instance,
) => <String, dynamic>{
  if (instance.loyaltyPoints case final value?) 'LoyaltyPoints': value,
  if (instance.loyaltyPointsBalance case final value?)
    'LoyaltyPointsBalance': value,
  if (instance.loyaltyPointsAmount case final value?)
    'LoyaltyPointsAmount': value,
  if (instance.minimumLoyaltyPointsBalance case final value?)
    'MinimumLoyaltyPointsBalance': value,
  if (instance.minimumLoyaltyPointsAmount case final value?)
    'MinimumLoyaltyPointsAmount': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
