import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../vendor_address_model/vendor_address_model.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'apply_vendor_model.freezed.dart';
part 'apply_vendor_model.g.dart';

@freezed
class ApplyVendorModel extends StoreJsonSerializable<ApplyVendorModel>
    with _$ApplyVendorModel {
  factory ApplyVendorModel(
      {@JsonKey(name: 'Address', includeIfNull: false)
      VendorAddressModel? address,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'TermsOfServiceEnabled', includeIfNull: false)
      @Default(false)
      bool? termsOfServiceEnabled,
      @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
      @Default(false)
      bool? termsOfServicePopup,
      @JsonKey(name: 'DisableFormInput', includeIfNull: false)
      @Default(false)
      bool? disableFormInput,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ApplyVendorModel;

  factory ApplyVendorModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyVendorModelFromJson(json);
}
