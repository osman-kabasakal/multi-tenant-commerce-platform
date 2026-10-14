import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'customer_note.freezed.dart';
part 'customer_note.g.dart';

@freezed
class CustomerNote extends StoreJsonSerializable<CustomerNote>
    with _$CustomerNote {
  factory CustomerNote(
      {@JsonKey(name: 'NoteId', includeIfNull: false) String? noteId,
      @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'CreatedOn', includeIfNull: false)
      DateTime? createdOn}) = _CustomerNote;

  factory CustomerNote.fromJson(Map<String, dynamic> json) =>
      _$CustomerNoteFromJson(json);
}
