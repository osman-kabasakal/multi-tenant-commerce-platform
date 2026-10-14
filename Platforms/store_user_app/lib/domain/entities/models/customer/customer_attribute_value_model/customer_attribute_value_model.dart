import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_attribute_value_model.freezed.dart';
part 'customer_attribute_value_model.g.dart';

@freezed
class CustomerAttributeValueModel
    extends StoreJsonSerializable<CustomerAttributeValueModel>
    with _$CustomerAttributeValueModel {
  factory CustomerAttributeValueModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'IsPreSelected', includeIfNull: false)
      @Default(false)
      bool? isPreSelected,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerAttributeValueModel;

  factory CustomerAttributeValueModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAttributeValueModelFromJson(json);
}
