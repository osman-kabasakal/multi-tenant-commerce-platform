import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'add_order_note_model.freezed.dart';
part 'add_order_note_model.g.dart';

@freezed
class AddOrderNoteModel extends StoreJsonSerializable<AddOrderNoteModel>
    with _$AddOrderNoteModel {
  factory AddOrderNoteModel(
      {@JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
      @JsonKey(name: 'Note', includeIfNull: false) String? note,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddOrderNoteModel;

  factory AddOrderNoteModel.fromJson(Map<String, dynamic> json) =>
      _$AddOrderNoteModelFromJson(json);
}
