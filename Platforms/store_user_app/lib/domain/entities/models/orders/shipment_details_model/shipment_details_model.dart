import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import './shipment_status_event_model/shipment_status_event_model.dart';

import './shipment_item_model/shipment_item_model.dart';

import './shipment_note/shipment_note.dart';

import './order_model/order_model.dart';

import '../../../common/user_field/user_field.dart';

part 'shipment_details_model.freezed.dart';
part 'shipment_details_model.g.dart';

@freezed
class ShipmentDetailsModel extends StoreJsonSerializable<ShipmentDetailsModel>
    with _$ShipmentDetailsModel {
  factory ShipmentDetailsModel(
      {@JsonKey(name: 'ShipmentNumber', includeIfNull: false)
      int? shipmentNumber,
      @JsonKey(name: 'TrackingNumber', includeIfNull: false)
      String? trackingNumber,
      @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
      String? trackingNumberUrl,
      @JsonKey(name: 'ShippedDate', includeIfNull: false)
      @Default(null)
      DateTime? shippedDate,
      @JsonKey(name: 'DeliveryDate', includeIfNull: false)
      @Default(null)
      DateTime? deliveryDate,
      @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
      @Default([])
      List<ShipmentStatusEventModel>? shipmentStatusEvents,
      @JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<ShipmentItemModel>? items,
      @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
      @Default([])
      List<ShipmentNote>? shipmentNotes,
      @JsonKey(name: 'Order', includeIfNull: false) OrderModel? order,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShipmentDetailsModel;

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDetailsModelFromJson(json);
}
