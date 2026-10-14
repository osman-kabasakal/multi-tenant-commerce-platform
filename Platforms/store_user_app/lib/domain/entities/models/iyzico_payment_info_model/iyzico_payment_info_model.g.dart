// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iyzico_payment_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IyzicoPaymentInfoModelImpl _$$IyzicoPaymentInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$IyzicoPaymentInfoModelImpl(
  creditCardFormData:
      (json['CreditCardFormData'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, FieldDefinition.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  storedUserCards:
      (json['StoredUserCards'] as List<dynamic>?)
          ?.map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sandBox: json['SandBox'] as bool? ?? false,
  selectedCardToken: json['SelectedCardToken'] as String?,
  installmentQueryUrl: json['InstallmentQueryUrl'] as String?,
  iyzicoBrandImageUrl: json['IyzicoBrandImageUrl'] as String?,
  creditCardBrandUrl: json['CreditCardBrandUrl'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$IyzicoPaymentInfoModelImplToJson(
  _$IyzicoPaymentInfoModelImpl instance,
) => <String, dynamic>{
  if (instance.creditCardFormData case final value?)
    'CreditCardFormData': value,
  if (instance.storedUserCards case final value?) 'StoredUserCards': value,
  if (instance.sandBox case final value?) 'SandBox': value,
  if (instance.selectedCardToken case final value?) 'SelectedCardToken': value,
  if (instance.installmentQueryUrl case final value?)
    'InstallmentQueryUrl': value,
  if (instance.iyzicoBrandImageUrl case final value?)
    'IyzicoBrandImageUrl': value,
  if (instance.creditCardBrandUrl case final value?)
    'CreditCardBrandUrl': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
