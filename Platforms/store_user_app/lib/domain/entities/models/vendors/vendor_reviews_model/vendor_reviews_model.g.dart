// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorReviewsModelImpl _$$VendorReviewsModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorReviewsModelImpl(
  vendorId: json['VendorId'] as String?,
  vendorName: json['VendorName'] as String?,
  vendorSeName: json['VendorSeName'] as String?,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => VendorReviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  addVendorReview:
      json['AddVendorReview'] == null
          ? null
          : AddVendorReviewModel.fromJson(
            json['AddVendorReview'] as Map<String, dynamic>,
          ),
  vendorReviewOverview:
      json['VendorReviewOverview'] == null
          ? null
          : VendorReviewOverviewModel.fromJson(
            json['VendorReviewOverview'] as Map<String, dynamic>,
          ),
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorReviewsModelImplToJson(
  _$VendorReviewsModelImpl instance,
) => <String, dynamic>{
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.vendorName case final value?) 'VendorName': value,
  if (instance.vendorSeName case final value?) 'VendorSeName': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.addVendorReview case final value?) 'AddVendorReview': value,
  if (instance.vendorReviewOverview case final value?)
    'VendorReviewOverview': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
