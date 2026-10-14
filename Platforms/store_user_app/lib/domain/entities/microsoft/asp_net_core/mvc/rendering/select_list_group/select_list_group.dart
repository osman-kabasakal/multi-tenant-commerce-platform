import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'select_list_group.freezed.dart';
part 'select_list_group.g.dart';

@freezed
class SelectListGroup extends StoreJsonSerializable<SelectListGroup>
    with _$SelectListGroup {
  factory SelectListGroup(
          {@JsonKey(name: 'Disabled', includeIfNull: false)
          @Default(false)
          bool? disabled,
          @JsonKey(name: 'Name', includeIfNull: false) String? name}) =
      _SelectListGroup;

  factory SelectListGroup.fromJson(Map<String, dynamic> json) =>
      _$SelectListGroupFromJson(json);
}
