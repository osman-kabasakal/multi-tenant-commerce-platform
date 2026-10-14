// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorReviewOverviewModelImpl _$$VendorReviewOverviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorReviewOverviewModelImpl(
  vendorId: json['VendorId'] as String?,
  ratingSum: (json['RatingSum'] as num?)?.toInt(),
  totalReviews: (json['TotalReviews'] as num?)?.toInt(),
  allowCustomerReviews: json['AllowCustomerReviews'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorReviewOverviewModelImplToJson(
  _$VendorReviewOverviewModelImpl instance,
) => <String, dynamic>{
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.ratingSum case final value?) 'RatingSum': value,
  if (instance.totalReviews case final value?) 'TotalReviews': value,
  if (instance.allowCustomerReviews case final value?)
    'AllowCustomerReviews': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
