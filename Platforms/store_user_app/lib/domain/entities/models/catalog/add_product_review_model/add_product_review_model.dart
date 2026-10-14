import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'add_product_review_model.freezed.dart';
part 'add_product_review_model.g.dart';

@freezed
class AddProductReviewModel extends StoreJsonSerializable<AddProductReviewModel>
    with _$AddProductReviewModel {
  factory AddProductReviewModel(
      {@JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
      @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
      @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
      @Default(false)
      bool? displayCaptcha,
      @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
      @Default(false)
      bool? canCurrentCustomerLeaveReview,
      @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
      @Default(false)
      bool? successfullyAdded,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddProductReviewModel;

  factory AddProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductReviewModelFromJson(json);
}
