import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import './out_of_stock_subscription_model/out_of_stock_subscription_model.dart';

import '../../common/pager_model/pager_model.dart';

part 'customer_out_of_stock_subscriptions_model.freezed.dart';
part 'customer_out_of_stock_subscriptions_model.g.dart';

@freezed
class CustomerOutOfStockSubscriptionsModel
    extends StoreJsonSerializable<CustomerOutOfStockSubscriptionsModel>
    with _$CustomerOutOfStockSubscriptionsModel {
  factory CustomerOutOfStockSubscriptionsModel(
      {@JsonKey(name: 'Subscriptions', includeIfNull: false)
      @Default([])
      List<OutOfStockSubscriptionModel>? subscriptions,
      @JsonKey(name: 'PagerModel', includeIfNull: false)
      PagerModel? pagerModel}) = _CustomerOutOfStockSubscriptionsModel;

  factory CustomerOutOfStockSubscriptionsModel.fromJson(
          Map<String, dynamic> json) =>
      _$CustomerOutOfStockSubscriptionsModelFromJson(json);
}
