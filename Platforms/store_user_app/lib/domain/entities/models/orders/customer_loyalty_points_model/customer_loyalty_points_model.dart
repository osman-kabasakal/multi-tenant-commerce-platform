import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import './loyalty_points_history_model/loyalty_points_history_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_loyalty_points_model.freezed.dart';
part 'customer_loyalty_points_model.g.dart';

@freezed
class CustomerLoyaltyPointsModel
    extends StoreJsonSerializable<CustomerLoyaltyPointsModel>
    with _$CustomerLoyaltyPointsModel {
  factory CustomerLoyaltyPointsModel(
      {@JsonKey(name: 'LoyaltyPoints', includeIfNull: false)
      @Default([])
      List<LoyaltyPointsHistoryModel>? loyaltyPoints,
      @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
      int? loyaltyPointsBalance,
      @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
      String? loyaltyPointsAmount,
      @JsonKey(name: 'MinimumLoyaltyPointsBalance', includeIfNull: false)
      int? minimumLoyaltyPointsBalance,
      @JsonKey(name: 'MinimumLoyaltyPointsAmount', includeIfNull: false)
      String? minimumLoyaltyPointsAmount,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerLoyaltyPointsModel;

  factory CustomerLoyaltyPointsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerLoyaltyPointsModelFromJson(json);
}
