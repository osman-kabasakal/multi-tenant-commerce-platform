// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_us_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactUsModelImpl _$$ContactUsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContactUsModelImpl(
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
  attributes:
      (json['Attributes'] as List<dynamic>?)
          ?.map((e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contactAttributeInfo: json['ContactAttributeInfo'] as String?,
  contactAttribute:
      (json['ContactAttribute'] as List<dynamic>?)
          ?.map((e) => CustomAttribute.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contactAttributes:
      (json['ContactAttributes'] as List<dynamic>?)
          ?.map(
            (e) => ContactAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ContactUsModelImplToJson(
  _$ContactUsModelImpl instance,
) => <String, dynamic>{
  if (instance.email case final value?) 'Email': value,
  if (instance.subject case final value?) 'Subject': value,
  if (instance.subjectEnabled case final value?) 'SubjectEnabled': value,
  if (instance.enquiry case final value?) 'Enquiry': value,
  if (instance.fullName case final value?) 'FullName': value,
  if (instance.successfullySent case final value?) 'SuccessfullySent': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.attributes case final value?) 'Attributes': value,
  if (instance.contactAttributeInfo case final value?)
    'ContactAttributeInfo': value,
  if (instance.contactAttribute case final value?) 'ContactAttribute': value,
  if (instance.contactAttributes case final value?) 'ContactAttributes': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
