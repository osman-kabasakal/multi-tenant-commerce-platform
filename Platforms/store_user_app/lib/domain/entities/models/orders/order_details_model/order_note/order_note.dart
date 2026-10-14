import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'order_note.freezed.dart';
part 'order_note.g.dart';

@freezed
class OrderNote extends StoreJsonSerializable<OrderNote> with _$OrderNote {
  factory OrderNote(
      {@JsonKey(name: 'HasDownload', includeIfNull: false)
      @Default(false)
      bool? hasDownload,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderNote;

  factory OrderNote.fromJson(Map<String, dynamic> json) =>
      _$OrderNoteFromJson(json);
}
