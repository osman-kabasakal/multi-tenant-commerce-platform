// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentMethodModelImpl(
  paymentMethodSystemName: json['PaymentMethodSystemName'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  fee: json['Fee'] as String?,
  selected: json['Selected'] as bool? ?? false,
  logoUrl: json['LogoUrl'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
  _$PaymentMethodModelImpl instance,
) => <String, dynamic>{
  if (instance.paymentMethodSystemName case final value?)
    'PaymentMethodSystemName': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.fee case final value?) 'Fee': value,
  if (instance.selected case final value?) 'Selected': value,
  if (instance.logoUrl case final value?) 'LogoUrl': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
