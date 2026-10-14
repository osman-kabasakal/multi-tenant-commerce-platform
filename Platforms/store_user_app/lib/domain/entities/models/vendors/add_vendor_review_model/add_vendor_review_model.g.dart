// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_vendor_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddVendorReviewModelImpl _$$AddVendorReviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddVendorReviewModelImpl(
  title: json['Title'] as String?,
  reviewText: json['ReviewText'] as String?,
  rating: (json['Rating'] as num?)?.toInt(),
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  canCurrentCustomerLeaveReview:
      json['CanCurrentCustomerLeaveReview'] as bool? ?? false,
  successfullyAdded: json['SuccessfullyAdded'] as bool? ?? false,
  result: json['Result'] as String?,
  notAllowAnonymousUsersToReviewVendor:
      json['NotAllowAnonymousUsersToReviewVendor'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AddVendorReviewModelImplToJson(
  _$AddVendorReviewModelImpl instance,
) => <String, dynamic>{
  if (instance.title case final value?) 'Title': value,
  if (instance.reviewText case final value?) 'ReviewText': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.canCurrentCustomerLeaveReview case final value?)
    'CanCurrentCustomerLeaveReview': value,
  if (instance.successfullyAdded case final value?) 'SuccessfullyAdded': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.notAllowAnonymousUsersToReviewVendor case final value?)
    'NotAllowAnonymousUsersToReviewVendor': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
