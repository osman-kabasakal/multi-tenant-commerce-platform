import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'contact_attribute_value_model.freezed.dart';
part 'contact_attribute_value_model.g.dart';

@freezed
class ContactAttributeValueModel
    extends StoreJsonSerializable<ContactAttributeValueModel>
    with _$ContactAttributeValueModel {
  factory ContactAttributeValueModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
      @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
      String? colorSquaresRgb,
      @JsonKey(name: 'IsPreSelected', includeIfNull: false)
      @Default(false)
      bool? isPreSelected,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ContactAttributeValueModel;

  factory ContactAttributeValueModel.fromJson(Map<String, dynamic> json) =>
      _$ContactAttributeValueModelFromJson(json);
}
