import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/address/address.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_pickup_point_model.freezed.dart';
part 'checkout_pickup_point_model.g.dart';

@freezed
class CheckoutPickupPointModel
    extends StoreJsonSerializable<CheckoutPickupPointModel>
    with _$CheckoutPickupPointModel {
  factory CheckoutPickupPointModel(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'Address', includeIfNull: false) Address? address,
      @JsonKey(name: 'PickupFee', includeIfNull: false) String? pickupFee,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutPickupPointModel;

  factory CheckoutPickupPointModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPickupPointModelFromJson(json);
}
