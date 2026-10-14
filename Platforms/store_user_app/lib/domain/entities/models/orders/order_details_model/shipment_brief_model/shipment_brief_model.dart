import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'shipment_brief_model.freezed.dart';
part 'shipment_brief_model.g.dart';

@freezed
class ShipmentBriefModel extends StoreJsonSerializable<ShipmentBriefModel>
    with _$ShipmentBriefModel {
  factory ShipmentBriefModel(
      {@JsonKey(name: 'TrackingNumber', includeIfNull: false)
      String? trackingNumber,
      @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
      int? shipmentNumber,
      @JsonKey(name: 'ShippedDate', includeIfNull: false)
      @Default(null)
      DateTime? shippedDate,
      @JsonKey(name: 'DeliveryDate', includeIfNull: false)
      @Default(null)
      DateTime? deliveryDate,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShipmentBriefModel;

  factory ShipmentBriefModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentBriefModelFromJson(json);
}
