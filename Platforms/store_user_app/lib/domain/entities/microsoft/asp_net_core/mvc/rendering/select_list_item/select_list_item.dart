import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../select_list_group/select_list_group.dart';

part 'select_list_item.freezed.dart';
part 'select_list_item.g.dart';

@freezed
class SelectListItem extends StoreJsonSerializable<SelectListItem>
    with _$SelectListItem {
  factory SelectListItem(
          {@JsonKey(name: 'Disabled', includeIfNull: false)
          @Default(false)
          bool? disabled,
          @JsonKey(name: 'Group', includeIfNull: false) SelectListGroup? group,
          @JsonKey(name: 'Selected', includeIfNull: false)
          @Default(false)
          bool? selected,
          @JsonKey(name: 'Text', includeIfNull: false) String? text,
          @JsonKey(name: 'Value', includeIfNull: false) String? value}) =
      _SelectListItem;

  factory SelectListItem.fromJson(Map<String, dynamic> json) =>
      _$SelectListItemFromJson(json);
}
