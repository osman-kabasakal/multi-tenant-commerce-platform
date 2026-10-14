import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'tier_price_model.freezed.dart';
part 'tier_price_model.g.dart';

@freezed
class TierPriceModel extends StoreJsonSerializable<TierPriceModel>
    with _$TierPriceModel {
  factory TierPriceModel(
      {@JsonKey(name: 'Price', includeIfNull: false) String? price,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _TierPriceModel;

  factory TierPriceModel.fromJson(Map<String, dynamic> json) =>
      _$TierPriceModelFromJson(json);
}
