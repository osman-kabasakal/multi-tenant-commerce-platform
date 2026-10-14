// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentInfoStepModelImpl _$$PaymentInfoStepModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentInfoStepModelImpl(
  paymentUrl: json['PaymentUrl'] as String?,
  systemName: json['SystemName'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaymentInfoStepModelImplToJson(
  _$PaymentInfoStepModelImpl instance,
) => <String, dynamic>{
  if (instance.paymentUrl case final value?) 'PaymentUrl': value,
  if (instance.systemName case final value?) 'SystemName': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
