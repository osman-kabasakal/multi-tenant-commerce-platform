// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_auctions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerAuctionsModelImpl _$$CustomerAuctionsModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerAuctionsModelImpl(
  productBidList:
      (json['ProductBidList'] as List<dynamic>?)
          ?.map((e) => ProductBidTuple.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customerId: json['CustomerId'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerAuctionsModelImplToJson(
  _$CustomerAuctionsModelImpl instance,
) => <String, dynamic>{
  if (instance.productBidList case final value?) 'ProductBidList': value,
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
