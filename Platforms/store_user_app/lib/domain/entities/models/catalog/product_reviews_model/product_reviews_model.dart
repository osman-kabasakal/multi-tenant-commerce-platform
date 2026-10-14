import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../icaptcha_valid_model/icaptcha_valid_model.dart';

import '../product_review_model/product_review_model.dart';

import '../add_product_review_model/add_product_review_model.dart';

import '../product_review_overview_model/product_review_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_reviews_model.freezed.dart';
part 'product_reviews_model.g.dart';

@freezed
class ProductReviewsModel extends StoreJsonSerializable<ProductReviewsModel>
    with _$ProductReviewsModel {
  factory ProductReviewsModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'CaptchaValid', includeIfNull: false)
      @Default(false)
      bool? captchaValid,
      @JsonKey(name: 'Captcha', includeIfNull: false)
      ICaptchaValidModel? captcha,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<ProductReviewModel>? items,
      @JsonKey(name: 'AddProductReview', includeIfNull: false)
      AddProductReviewModel? addProductReview,
      @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
      ProductReviewOverviewModel? productReviewOverviewModel,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductReviewsModel;

  factory ProductReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewsModelFromJson(json);
}
