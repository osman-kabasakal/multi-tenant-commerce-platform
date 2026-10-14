// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_step_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutStepResponseImpl _$$CheckoutStepResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutStepResponseImpl(
  UpdateSection:
      json['update_section'] == null
          ? null
          : UpdateSectionJsonModel.fromJson(
            json['update_section'] as Map<String, dynamic>,
          ),
  goToSection: json['goto_section'] as String?,
  wrongBillingAddress: json['wrong_billing_address'] as bool? ?? false,
  modelState:
      (json['model_state'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  error: (json['error'] as num?)?.toInt(),
  message: json['message'] as String?,
  success: (json['success'] as num?)?.toInt(),
  redirect: json['redirect'] as String?,
);

Map<String, dynamic> _$$CheckoutStepResponseImplToJson(
  _$CheckoutStepResponseImpl instance,
) => <String, dynamic>{
  if (instance.UpdateSection case final value?) 'update_section': value,
  if (instance.goToSection case final value?) 'goto_section': value,
  'wrong_billing_address': instance.wrongBillingAddress,
  'model_state': instance.modelState,
  if (instance.error case final value?) 'error': value,
  if (instance.message case final value?) 'message': value,
  if (instance.success case final value?) 'success': value,
  if (instance.redirect case final value?) 'redirect': value,
};
