import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

part 'contact_attribute_change_model.freezed.dart';
part 'contact_attribute_change_model.g.dart';

@freezed
class ContactAttributeChangeModel
    extends StoreJsonSerializable<ContactAttributeChangeModel>
    with _$ContactAttributeChangeModel {
  factory ContactAttributeChangeModel(
      {@JsonKey(name: 'Attributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? attributes}) = _ContactAttributeChangeModel;

  factory ContactAttributeChangeModel.fromJson(Map<String, dynamic> json) =>
      _$ContactAttributeChangeModelFromJson(json);
}
