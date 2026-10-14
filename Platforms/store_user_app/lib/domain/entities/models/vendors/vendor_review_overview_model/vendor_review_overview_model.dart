import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_review_overview_model.freezed.dart';
part 'vendor_review_overview_model.g.dart';

@freezed
class VendorReviewOverviewModel
    extends StoreJsonSerializable<VendorReviewOverviewModel>
    with _$VendorReviewOverviewModel {
  factory VendorReviewOverviewModel(
      {@JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
      @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
      @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
      @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
      @Default(false)
      bool? allowCustomerReviews,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorReviewOverviewModel;

  factory VendorReviewOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$VendorReviewOverviewModelFromJson(json);
}
