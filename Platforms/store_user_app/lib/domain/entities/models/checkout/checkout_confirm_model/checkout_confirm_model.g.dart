// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_confirm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutConfirmModelImpl _$$CheckoutConfirmModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutConfirmModelImpl(
  termsOfServiceOnOrderConfirmPage:
      json['TermsOfServiceOnOrderConfirmPage'] as bool? ?? false,
  minOrderTotalWarning: json['MinOrderTotalWarning'] as String?,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  orderReviewData:
      json['OrderReviewData'] == null
          ? null
          : OrderReviewDataModel.fromJson(
            json['OrderReviewData'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutConfirmModelImplToJson(
  _$CheckoutConfirmModelImpl instance,
) => <String, dynamic>{
  if (instance.termsOfServiceOnOrderConfirmPage case final value?)
    'TermsOfServiceOnOrderConfirmPage': value,
  if (instance.minOrderTotalWarning case final value?)
    'MinOrderTotalWarning': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.orderReviewData case final value?) 'OrderReviewData': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
