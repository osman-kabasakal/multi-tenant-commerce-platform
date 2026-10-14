import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'merchandise_return_note.freezed.dart';
part 'merchandise_return_note.g.dart';

@freezed
class MerchandiseReturnNote extends StoreJsonSerializable<MerchandiseReturnNote>
    with _$MerchandiseReturnNote {
  factory MerchandiseReturnNote(
      {@JsonKey(name: 'HasDownload', includeIfNull: false)
      @Default(false)
      bool? hasDownload,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'MerchandiseReturnId', includeIfNull: false)
      String? merchandiseReturnId,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnNote;

  factory MerchandiseReturnNote.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnNoteFromJson(json);
}
