import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

part 'checkout_attribute_selected_model.freezed.dart';
part 'checkout_attribute_selected_model.g.dart';

@freezed
class CheckoutAttributeSelectedModel
    extends StoreJsonSerializable<CheckoutAttributeSelectedModel>
    with _$CheckoutAttributeSelectedModel {
  factory CheckoutAttributeSelectedModel(
          {@JsonKey(name: 'Attributes', includeIfNull: false)
          @Default([])
          List<CustomAttributeModel>? attributes}) =
      _CheckoutAttributeSelectedModel;

  factory CheckoutAttributeSelectedModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutAttributeSelectedModelFromJson(json);
}
