import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../customer_product_review_model/customer_product_review_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_product_reviews_model.freezed.dart';
part 'customer_product_reviews_model.g.dart';

@freezed
class CustomerProductReviewsModel
    extends StoreJsonSerializable<CustomerProductReviewsModel>
    with _$CustomerProductReviewsModel {
  factory CustomerProductReviewsModel(
      {@JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'CustomerInfo', includeIfNull: false) String? customerInfo,
      @JsonKey(name: 'Reviews', includeIfNull: false)
      @Default([])
      List<CustomerProductReviewModel>? reviews,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerProductReviewsModel;

  factory CustomerProductReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerProductReviewsModelFromJson(json);
}
