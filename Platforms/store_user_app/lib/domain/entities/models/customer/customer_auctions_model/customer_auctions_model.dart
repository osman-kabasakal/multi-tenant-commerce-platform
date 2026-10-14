import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../product_bid_tuple/product_bid_tuple.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_auctions_model.freezed.dart';
part 'customer_auctions_model.g.dart';

@freezed
class CustomerAuctionsModel extends StoreJsonSerializable<CustomerAuctionsModel>
    with _$CustomerAuctionsModel {
  // Add const constructor
  const CustomerAuctionsModel._();

  factory CustomerAuctionsModel(
      {@JsonKey(name: 'ProductBidList', includeIfNull: false)
      @Default([])
      List<ProductBidTuple>? productBidList,
      @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerAuctionsModel;

  factory CustomerAuctionsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAuctionsModelFromJson(json);
}
