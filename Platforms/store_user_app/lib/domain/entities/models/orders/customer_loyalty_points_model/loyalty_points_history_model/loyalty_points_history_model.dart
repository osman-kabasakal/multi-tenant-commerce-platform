import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'loyalty_points_history_model.freezed.dart';
part 'loyalty_points_history_model.g.dart';

@freezed
class LoyaltyPointsHistoryModel
    extends StoreJsonSerializable<LoyaltyPointsHistoryModel>
    with _$LoyaltyPointsHistoryModel {
  factory LoyaltyPointsHistoryModel(
      {@JsonKey(name: 'Points', includeIfNull: false) int? points,
      @JsonKey(name: 'PointsBalance', includeIfNull: false) int? pointsBalance,
      @JsonKey(name: 'Message', includeIfNull: false) String? message,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _LoyaltyPointsHistoryModel;

  factory LoyaltyPointsHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyPointsHistoryModelFromJson(json);
}
