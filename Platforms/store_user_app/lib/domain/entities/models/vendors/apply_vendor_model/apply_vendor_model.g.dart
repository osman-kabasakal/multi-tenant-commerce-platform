// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplyVendorModelImpl _$$ApplyVendorModelImplFromJson(
  Map<String, dynamic> json,
) => _$ApplyVendorModelImpl(
  address:
      json['Address'] == null
          ? null
          : VendorAddressModel.fromJson(
            json['Address'] as Map<String, dynamic>,
          ),
  name: json['Name'] as String?,
  email: json['Email'] as String?,
  description: json['Description'] as String?,
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  termsOfServiceEnabled: json['TermsOfServiceEnabled'] as bool? ?? false,
  termsOfServicePopup: json['TermsOfServicePopup'] as bool? ?? false,
  disableFormInput: json['DisableFormInput'] as bool? ?? false,
  result: json['Result'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ApplyVendorModelImplToJson(
  _$ApplyVendorModelImpl instance,
) => <String, dynamic>{
  if (instance.address case final value?) 'Address': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.email case final value?) 'Email': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.termsOfServiceEnabled case final value?)
    'TermsOfServiceEnabled': value,
  if (instance.termsOfServicePopup case final value?)
    'TermsOfServicePopup': value,
  if (instance.disableFormInput case final value?) 'DisableFormInput': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
