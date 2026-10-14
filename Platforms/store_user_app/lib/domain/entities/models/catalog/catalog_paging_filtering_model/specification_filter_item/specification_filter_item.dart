import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'specification_filter_item.freezed.dart';
part 'specification_filter_item.g.dart';

@freezed
class SpecificationFilterItem
    extends StoreJsonSerializable<SpecificationFilterItem>
    with _$SpecificationFilterItem {
  factory SpecificationFilterItem(
      {@JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
      String? specificationAttributeName,
      @JsonKey(name: 'SpecificationAttributeSeName', includeIfNull: false)
      String? specificationAttributeSeName,
      @JsonKey(name: 'SpecificationAttributeOptionName', includeIfNull: false)
      String? specificationAttributeOptionName,
      @JsonKey(name: 'SpecificationAttributeOptionSeName', includeIfNull: false)
      String? specificationAttributeOptionSeName,
      @JsonKey(
          name: 'SpecificationAttributeOptionColorRgb', includeIfNull: false)
      String? specificationAttributeOptionColorRgb,
      @JsonKey(name: 'FilterUrl', includeIfNull: false) String? filterUrl,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _SpecificationFilterItem;

  factory SpecificationFilterItem.fromJson(Map<String, dynamic> json) =>
      _$SpecificationFilterItemFromJson(json);
}
