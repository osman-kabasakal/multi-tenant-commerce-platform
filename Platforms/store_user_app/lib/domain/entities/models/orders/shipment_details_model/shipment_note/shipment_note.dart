import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'shipment_note.freezed.dart';
part 'shipment_note.g.dart';

@freezed
class ShipmentNote extends StoreJsonSerializable<ShipmentNote>
    with _$ShipmentNote {
  factory ShipmentNote(
      {@JsonKey(name: 'HasDownload', includeIfNull: false)
      @Default(false)
      bool? hasDownload,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'ShipmentId', includeIfNull: false) String? shipmentId,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShipmentNote;

  factory ShipmentNote.fromJson(Map<String, dynamic> json) =>
      _$ShipmentNoteFromJson(json);
}
