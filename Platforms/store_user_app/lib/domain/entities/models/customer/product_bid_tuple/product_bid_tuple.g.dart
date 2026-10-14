// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bid_tuple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductBidTupleImpl _$$ProductBidTupleImplFromJson(
  Map<String, dynamic> json,
) => _$ProductBidTupleImpl(
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  currentBidAmount: json['CurrentBidAmount'] as String?,
  currentBidAmountValue: (json['CurrentBidAmountValue'] as num?)?.toDouble(),
  bidAmount: json['BidAmount'] as String?,
  bidAmountValue: (json['BidAmountValue'] as num?)?.toDouble(),
  endBidDate:
      json['EndBidDate'] == null
          ? null
          : DateTime.parse(json['EndBidDate'] as String),
  ended: json['Ended'] as bool? ?? false,
  highestBidder: json['HighestBidder'] as bool? ?? false,
  orderId: json['OrderId'] as String?,
);

Map<String, dynamic> _$$ProductBidTupleImplToJson(
  _$ProductBidTupleImpl instance,
) => <String, dynamic>{
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.currentBidAmount case final value?) 'CurrentBidAmount': value,
  if (instance.currentBidAmountValue case final value?)
    'CurrentBidAmountValue': value,
  if (instance.bidAmount case final value?) 'BidAmount': value,
  if (instance.bidAmountValue case final value?) 'BidAmountValue': value,
  if (instance.endBidDate?.toIso8601String() case final value?)
    'EndBidDate': value,
  if (instance.ended case final value?) 'Ended': value,
  if (instance.highestBidder case final value?) 'HighestBidder': value,
  if (instance.orderId case final value?) 'OrderId': value,
};
