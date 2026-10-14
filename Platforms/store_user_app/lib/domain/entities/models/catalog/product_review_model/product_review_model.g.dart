// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductReviewModelImpl _$$ProductReviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductReviewModelImpl(
  customerId: json['CustomerId'] as String?,
  customerName: json['CustomerName'] as String?,
  title: json['Title'] as String?,
  reviewText: json['ReviewText'] as String?,
  replyText: json['ReplyText'] as String?,
  signature: json['Signature'] as String?,
  confirmedPurchase: json['ConfirmedPurchase'] as bool? ?? false,
  rating: (json['Rating'] as num?)?.toInt(),
  helpfulness:
      json['Helpfulness'] == null
          ? null
          : ProductReviewHelpfulnessModel.fromJson(
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

Map<String, dynamic> _$$ProductReviewModelImplToJson(
  _$ProductReviewModelImpl instance,
) => <String, dynamic>{
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.customerName case final value?) 'CustomerName': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.reviewText case final value?) 'ReviewText': value,
  if (instance.replyText case final value?) 'ReplyText': value,
  if (instance.signature case final value?) 'Signature': value,
  if (instance.confirmedPurchase case final value?) 'ConfirmedPurchase': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.helpfulness case final value?) 'Helpfulness': value,
  if (instance.writtenOnStr case final value?) 'WrittenOnStr': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
