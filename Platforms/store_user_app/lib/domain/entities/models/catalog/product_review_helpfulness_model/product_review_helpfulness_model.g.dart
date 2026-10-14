// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_review_helpfulness_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductReviewHelpfulnessModelImpl
_$$ProductReviewHelpfulnessModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductReviewHelpfulnessModelImpl(
      productReviewId: json['ProductReviewId'] as String?,
      productId: json['ProductId'] as String?,
      helpfulYesTotal: (json['HelpfulYesTotal'] as num?)?.toInt(),
      helpfulNoTotal: (json['HelpfulNoTotal'] as num?)?.toInt(),
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProductReviewHelpfulnessModelImplToJson(
  _$ProductReviewHelpfulnessModelImpl instance,
) => <String, dynamic>{
  if (instance.productReviewId case final value?) 'ProductReviewId': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.helpfulYesTotal case final value?) 'HelpfulYesTotal': value,
  if (instance.helpfulNoTotal case final value?) 'HelpfulNoTotal': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
