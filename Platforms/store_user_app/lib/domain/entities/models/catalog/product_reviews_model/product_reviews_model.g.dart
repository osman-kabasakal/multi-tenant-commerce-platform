// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductReviewsModelImpl _$$ProductReviewsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductReviewsModelImpl(
  productId: json['ProductId'] as String?,
  captchaValid: json['CaptchaValid'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  addProductReview:
      json['AddProductReview'] == null
          ? null
          : AddProductReviewModel.fromJson(
            json['AddProductReview'] as Map<String, dynamic>,
          ),
  productReviewOverviewModel:
      json['ProductReviewOverviewModel'] == null
          ? null
          : ProductReviewOverviewModel.fromJson(
            json['ProductReviewOverviewModel'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductReviewsModelImplToJson(
  _$ProductReviewsModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.captchaValid case final value?) 'CaptchaValid': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.addProductReview case final value?) 'AddProductReview': value,
  if (instance.productReviewOverviewModel case final value?)
    'ProductReviewOverviewModel': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
