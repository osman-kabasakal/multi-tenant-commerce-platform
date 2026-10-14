// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactVendorModelImpl _$$ContactVendorModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContactVendorModelImpl(
  vendorId: json['VendorId'] as String?,
  vendorName: json['VendorName'] as String?,
  email: json['Email'] as String?,
  subject: json['Subject'] as String?,
  subjectEnabled: json['SubjectEnabled'] as bool? ?? false,
  enquiry: json['Enquiry'] as String?,
  fullName: json['FullName'] as String?,
  successfullySent: json['SuccessfullySent'] as bool? ?? false,
  result: json['Result'] as String?,
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ContactVendorModelImplToJson(
  _$ContactVendorModelImpl instance,
) => <String, dynamic>{
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.vendorName case final value?) 'VendorName': value,
  if (instance.email case final value?) 'Email': value,
  if (instance.subject case final value?) 'Subject': value,
  if (instance.subjectEnabled case final value?) 'SubjectEnabled': value,
  if (instance.enquiry case final value?) 'Enquiry': value,
  if (instance.fullName case final value?) 'FullName': value,
  if (instance.successfullySent case final value?) 'SuccessfullySent': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
