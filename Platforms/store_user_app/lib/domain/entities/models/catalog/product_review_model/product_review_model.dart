import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../product_review_helpfulness_model/product_review_helpfulness_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_review_model.freezed.dart';
part 'product_review_model.g.dart';

@freezed
class ProductReviewModel extends StoreJsonSerializable<ProductReviewModel>
    with _$ProductReviewModel {
  factory ProductReviewModel(
      {@JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
      @JsonKey(name: 'ReplyText', includeIfNull: false) String? replyText,
      @JsonKey(name: 'Signature', includeIfNull: false) String? signature,
      @JsonKey(name: 'ConfirmedPurchase', includeIfNull: false)
      @Default(false)
      bool? confirmedPurchase,
      @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
      @JsonKey(name: 'Helpfulness', includeIfNull: false)
      ProductReviewHelpfulnessModel? helpfulness,
      @JsonKey(name: 'WrittenOnStr', includeIfNull: false) String? writtenOnStr,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductReviewModel;

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewModelFromJson(json);
}
