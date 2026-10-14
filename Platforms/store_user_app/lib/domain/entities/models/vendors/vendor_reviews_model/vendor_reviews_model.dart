import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../vendor_review_model/vendor_review_model.dart';

import '../add_vendor_review_model/add_vendor_review_model.dart';

import '../vendor_review_overview_model/vendor_review_overview_model.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_reviews_model.freezed.dart';
part 'vendor_reviews_model.g.dart';

@freezed
class VendorReviewsModel extends StoreJsonSerializable<VendorReviewsModel>
    with _$VendorReviewsModel {
  factory VendorReviewsModel(
      {@JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
      @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
      @JsonKey(name: 'VendorSeName', includeIfNull: false) String? vendorSeName,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<VendorReviewModel>? items,
      @JsonKey(name: 'AddVendorReview', includeIfNull: false)
      AddVendorReviewModel? addVendorReview,
      @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
      VendorReviewOverviewModel? vendorReviewOverview,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorReviewsModel;

  factory VendorReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$VendorReviewsModelFromJson(json);
}
