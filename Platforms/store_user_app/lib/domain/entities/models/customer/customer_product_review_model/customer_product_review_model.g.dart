// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_product_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerProductReviewModelImpl _$$CustomerProductReviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerProductReviewModelImpl(
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  storeName: json['StoreName'] as String?,
  title: json['Title'] as String?,
  reviewText: json['ReviewText'] as String?,
  replyText: json['ReplyText'] as String?,
  signature: json['Signature'] as String?,
  rating: (json['Rating'] as num?)?.toInt(),
  isApproved: json['IsApproved'] as bool? ?? false,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerProductReviewModelImplToJson(
  _$CustomerProductReviewModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.storeName case final value?) 'StoreName': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.reviewText case final value?) 'ReviewText': value,
  if (instance.replyText case final value?) 'ReplyText': value,
  if (instance.signature case final value?) 'Signature': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.isApproved case final value?) 'IsApproved': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
