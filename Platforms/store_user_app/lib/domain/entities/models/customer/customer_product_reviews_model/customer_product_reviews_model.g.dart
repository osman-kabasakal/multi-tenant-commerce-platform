// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_product_reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerProductReviewsModelImpl _$$CustomerProductReviewsModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerProductReviewsModelImpl(
  customerId: json['CustomerId'] as String?,
  customerInfo: json['CustomerInfo'] as String?,
  reviews:
      (json['Reviews'] as List<dynamic>?)
          ?.map(
            (e) =>
                CustomerProductReviewModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerProductReviewsModelImplToJson(
  _$CustomerProductReviewsModelImpl instance,
) => <String, dynamic>{
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.customerInfo case final value?) 'CustomerInfo': value,
  if (instance.reviews case final value?) 'Reviews': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
