// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutPaymentMethodModelImpl _$$CheckoutPaymentMethodModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutPaymentMethodModelImpl(
  paymentMethods:
      (json['PaymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  displayLoyaltyPoints: json['DisplayLoyaltyPoints'] as bool? ?? false,
  loyaltyPointsBalance: (json['LoyaltyPointsBalance'] as num?)?.toInt(),
  loyaltyPointsAmount: json['LoyaltyPointsAmount'] as String?,
  loyaltyPointsEnoughToPayForOrder:
      json['LoyaltyPointsEnoughToPayForOrder'] as bool? ?? false,
  useLoyaltyPoints: json['UseLoyaltyPoints'] as bool? ?? false,
  paymentMethod: json['PaymentMethod'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutPaymentMethodModelImplToJson(
  _$CheckoutPaymentMethodModelImpl instance,
) => <String, dynamic>{
  if (instance.paymentMethods case final value?) 'PaymentMethods': value,
  if (instance.displayLoyaltyPoints case final value?)
    'DisplayLoyaltyPoints': value,
  if (instance.loyaltyPointsBalance case final value?)
    'LoyaltyPointsBalance': value,
  if (instance.loyaltyPointsAmount case final value?)
    'LoyaltyPointsAmount': value,
  if (instance.loyaltyPointsEnoughToPayForOrder case final value?)
    'LoyaltyPointsEnoughToPayForOrder': value,
  if (instance.useLoyaltyPoints case final value?) 'UseLoyaltyPoints': value,
  if (instance.paymentMethod case final value?) 'PaymentMethod': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
