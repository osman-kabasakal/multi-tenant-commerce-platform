import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

import '../../../common/custom_attribute/custom_attribute.dart';

import 'contact_attribute_model/contact_attribute_model.dart';

import '../../../common/user_field/user_field.dart';

part 'contact_us_model.freezed.dart';
part 'contact_us_model.g.dart';

@freezed
class ContactUsModel extends StoreJsonSerializable<ContactUsModel>
    with _$ContactUsModel {
  factory ContactUsModel(
      {@JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'Subject', includeIfNull: false) String? subject,
      @JsonKey(name: 'SubjectEnabled', includeIfNull: false)
      @Default(false)
      bool? subjectEnabled,
      @JsonKey(name: 'Enquiry', includeIfNull: false) String? enquiry,
      @JsonKey(name: 'FullName', includeIfNull: false) String? fullName,
      @JsonKey(name: 'SuccessfullySent', includeIfNull: false)
      @Default(false)
      bool? successfullySent,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'Attributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? attributes,
      @JsonKey(name: 'ContactAttributeInfo', includeIfNull: false)
      String? contactAttributeInfo,
      @JsonKey(name: 'ContactAttribute', includeIfNull: false)
      @Default([])
      List<CustomAttribute>? contactAttribute,
      @JsonKey(name: 'ContactAttributes', includeIfNull: false)
      @Default([])
      List<ContactAttributeModel>? contactAttributes,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ContactUsModel;

  factory ContactUsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactUsModelFromJson(json);
}
