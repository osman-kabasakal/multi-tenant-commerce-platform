import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../vendor_review_helpfulness_model/vendor_review_helpfulness_model.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_review_model.freezed.dart';
part 'vendor_review_model.g.dart';

@freezed
class VendorReviewModel extends StoreJsonSerializable<VendorReviewModel>
    with _$VendorReviewModel {
  factory VendorReviewModel(
      {@JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
      @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
      @JsonKey(name: 'Helpfulness', includeIfNull: false)
      VendorReviewHelpfulnessModel? helpfulness,
      @JsonKey(name: 'WrittenOnStr', includeIfNull: false) String? writtenOnStr,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorReviewModel;

  factory VendorReviewModel.fromJson(Map<String, dynamic> json) =>
      _$VendorReviewModelFromJson(json);
}
