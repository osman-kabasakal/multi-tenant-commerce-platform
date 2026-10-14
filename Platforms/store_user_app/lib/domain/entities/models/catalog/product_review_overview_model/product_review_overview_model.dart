import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'product_review_overview_model.freezed.dart';
part 'product_review_overview_model.g.dart';

@freezed
class ProductReviewOverviewModel
    extends StoreJsonSerializable<ProductReviewOverviewModel>
    with _$ProductReviewOverviewModel {
  factory ProductReviewOverviewModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
      @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
      @JsonKey(name: 'AvgRating', includeIfNull: false) double? avgRating,
      @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
      @Default(false)
      bool? allowCustomerReviews,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductReviewOverviewModel;

  factory ProductReviewOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewOverviewModelFromJson(json);
}
