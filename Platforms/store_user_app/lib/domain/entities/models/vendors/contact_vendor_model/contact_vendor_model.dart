import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'contact_vendor_model.freezed.dart';
part 'contact_vendor_model.g.dart';

@freezed
class ContactVendorModel extends StoreJsonSerializable<ContactVendorModel>
    with _$ContactVendorModel {
  factory ContactVendorModel(
      {@JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
      @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
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
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ContactVendorModel;

  factory ContactVendorModel.fromJson(Map<String, dynamic> json) =>
      _$ContactVendorModelFromJson(json);
}
