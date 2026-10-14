import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'shipment_status_event_model.freezed.dart';
part 'shipment_status_event_model.g.dart';

@freezed
class ShipmentStatusEventModel
    extends StoreJsonSerializable<ShipmentStatusEventModel>
    with _$ShipmentStatusEventModel {
  factory ShipmentStatusEventModel(
      {@JsonKey(name: 'EventName', includeIfNull: false) String? eventName,
      @JsonKey(name: 'Location', includeIfNull: false) String? location,
      @JsonKey(name: 'Country', includeIfNull: false) String? country,
      @JsonKey(name: 'Date', includeIfNull: false)
      @Default(null)
      DateTime? date,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShipmentStatusEventModel;

  factory ShipmentStatusEventModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentStatusEventModelFromJson(json);
}
