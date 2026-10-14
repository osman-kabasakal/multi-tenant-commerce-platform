import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'product_bid_tuple.freezed.dart';
part 'product_bid_tuple.g.dart';

@freezed
class ProductBidTuple extends StoreJsonSerializable<ProductBidTuple>
    with _$ProductBidTuple {
  factory ProductBidTuple(
      {@JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
      String? currentBidAmount,
      @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
      double? currentBidAmountValue,
      @JsonKey(name: 'BidAmount', includeIfNull: false) String? bidAmount,
      @JsonKey(name: 'BidAmountValue', includeIfNull: false)
      double? bidAmountValue,
      @JsonKey(name: 'EndBidDate', includeIfNull: false) DateTime? endBidDate,
      @JsonKey(name: 'Ended', includeIfNull: false) @Default(false) bool? ended,
      @JsonKey(name: 'HighestBidder', includeIfNull: false)
      @Default(false)
      bool? highestBidder,
      @JsonKey(name: 'OrderId', includeIfNull: false)
      String? orderId}) = _ProductBidTuple;

  factory ProductBidTuple.fromJson(Map<String, dynamic> json) =>
      _$ProductBidTupleFromJson(json);
}
