import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../specification_filter_item/specification_filter_item.dart';

import '../../../../common/user_field/user_field.dart';

part 'specification_filter_model.freezed.dart';
part 'specification_filter_model.g.dart';

@freezed
class SpecificationFilterModel
    extends StoreJsonSerializable<SpecificationFilterModel>
    with _$SpecificationFilterModel {
  factory SpecificationFilterModel(
      {@JsonKey(name: 'Enabled', includeIfNull: false)
      @Default(false)
      bool? enabled,
      @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
      @Default([])
      List<SpecificationFilterItem>? alreadyFilteredItems,
      @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
      @Default([])
      List<SpecificationFilterItem>? notFilteredItems,
      @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
      String? removeFilterUrl,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _SpecificationFilterModel;

  factory SpecificationFilterModel.fromJson(Map<String, dynamic> json) =>
      _$SpecificationFilterModelFromJson(json);
}
