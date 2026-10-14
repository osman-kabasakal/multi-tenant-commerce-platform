import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_review_helpfulness_model.freezed.dart';
part 'vendor_review_helpfulness_model.g.dart';

@freezed
class VendorReviewHelpfulnessModel
    extends StoreJsonSerializable<VendorReviewHelpfulnessModel>
    with _$VendorReviewHelpfulnessModel {
  factory VendorReviewHelpfulnessModel(
      {@JsonKey(name: 'VendorReviewId', includeIfNull: false)
      String? vendorReviewId,
      @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
      @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
      int? helpfulYesTotal,
      @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
      int? helpfulNoTotal,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorReviewHelpfulnessModel;

  factory VendorReviewHelpfulnessModel.fromJson(Map<String, dynamic> json) =>
      _$VendorReviewHelpfulnessModelFromJson(json);
}
