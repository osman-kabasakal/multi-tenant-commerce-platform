// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorReviewModelImpl _$$VendorReviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorReviewModelImpl(
  customerId: json['CustomerId'] as String?,
  customerName: json['CustomerName'] as String?,
  title: json['Title'] as String?,
  reviewText: json['ReviewText'] as String?,
  rating: (json['Rating'] as num?)?.toInt(),
  helpfulness:
      json['Helpfulness'] == null
          ? null
          : VendorReviewHelpfulnessModel.fromJson(
            json['Helpfulness'] as Map<String, dynamic>,
          ),
  writtenOnStr: json['WrittenOnStr'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorReviewModelImplToJson(
  _$VendorReviewModelImpl instance,
) => <String, dynamic>{
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.customerName case final value?) 'CustomerName': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.reviewText case final value?) 'ReviewText': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.helpfulness case final value?) 'Helpfulness': value,
  if (instance.writtenOnStr case final value?) 'WrittenOnStr': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
