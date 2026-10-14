// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_review_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductReviewOverviewModelImpl _$$ProductReviewOverviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductReviewOverviewModelImpl(
  productId: json['ProductId'] as String?,
  ratingSum: (json['RatingSum'] as num?)?.toInt(),
  totalReviews: (json['TotalReviews'] as num?)?.toInt(),
  avgRating: (json['AvgRating'] as num?)?.toDouble(),
  allowCustomerReviews: json['AllowCustomerReviews'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductReviewOverviewModelImplToJson(
  _$ProductReviewOverviewModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.ratingSum case final value?) 'RatingSum': value,
  if (instance.totalReviews case final value?) 'TotalReviews': value,
  if (instance.avgRating case final value?) 'AvgRating': value,
  if (instance.allowCustomerReviews case final value?)
    'AllowCustomerReviews': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
