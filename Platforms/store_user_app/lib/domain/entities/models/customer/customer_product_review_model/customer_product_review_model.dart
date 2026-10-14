import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_product_review_model.freezed.dart';
part 'customer_product_review_model.g.dart';

@freezed
class CustomerProductReviewModel
    extends StoreJsonSerializable<CustomerProductReviewModel>
    with _$CustomerProductReviewModel {
  factory CustomerProductReviewModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'StoreName', includeIfNull: false) String? storeName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
      @JsonKey(name: 'ReplyText', includeIfNull: false) String? replyText,
      @JsonKey(name: 'Signature', includeIfNull: false) String? signature,
      @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
      @JsonKey(name: 'IsApproved', includeIfNull: false)
      @Default(false)
      bool? isApproved,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerProductReviewModel;

  factory CustomerProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerProductReviewModelFromJson(json);
}
