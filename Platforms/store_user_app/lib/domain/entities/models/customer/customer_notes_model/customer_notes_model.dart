import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../customer_note/customer_note.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_notes_model.freezed.dart';
part 'customer_notes_model.g.dart';

@freezed
class CustomerNotesModel extends StoreJsonSerializable<CustomerNotesModel>
    with _$CustomerNotesModel {
  factory CustomerNotesModel(
      {@JsonKey(name: 'CustomerNoteList', includeIfNull: false)
      @Default([])
      List<CustomerNote>? customerNoteList,
      @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerNotesModel;

  factory CustomerNotesModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerNotesModelFromJson(json);
}
