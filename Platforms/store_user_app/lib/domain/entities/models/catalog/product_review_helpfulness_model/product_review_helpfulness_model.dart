import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'product_review_helpfulness_model.freezed.dart';
part 'product_review_helpfulness_model.g.dart';

@freezed
class ProductReviewHelpfulnessModel
    extends StoreJsonSerializable<ProductReviewHelpfulnessModel>
    with _$ProductReviewHelpfulnessModel {
  factory ProductReviewHelpfulnessModel(
      {@JsonKey(name: 'ProductReviewId', includeIfNull: false)
      String? productReviewId,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
      int? helpfulYesTotal,
      @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
      int? helpfulNoTotal,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductReviewHelpfulnessModel;

  factory ProductReviewHelpfulnessModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewHelpfulnessModelFromJson(json);
}
