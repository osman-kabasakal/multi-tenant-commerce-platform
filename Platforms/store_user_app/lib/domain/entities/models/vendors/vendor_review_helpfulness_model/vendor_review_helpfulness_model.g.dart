// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_helpfulness_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorReviewHelpfulnessModelImpl _$$VendorReviewHelpfulnessModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorReviewHelpfulnessModelImpl(
  vendorReviewId: json['VendorReviewId'] as String?,
  vendorId: json['VendorId'] as String?,
  helpfulYesTotal: (json['HelpfulYesTotal'] as num?)?.toInt(),
  helpfulNoTotal: (json['HelpfulNoTotal'] as num?)?.toInt(),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorReviewHelpfulnessModelImplToJson(
  _$VendorReviewHelpfulnessModelImpl instance,
) => <String, dynamic>{
  if (instance.vendorReviewId case final value?) 'VendorReviewId': value,
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.helpfulYesTotal case final value?) 'HelpfulYesTotal': value,
  if (instance.helpfulNoTotal case final value?) 'HelpfulNoTotal': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
