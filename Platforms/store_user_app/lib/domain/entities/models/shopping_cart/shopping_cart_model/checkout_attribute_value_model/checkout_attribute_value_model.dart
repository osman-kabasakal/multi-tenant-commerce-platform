import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'checkout_attribute_value_model.freezed.dart';
part 'checkout_attribute_value_model.g.dart';

@freezed
class CheckoutAttributeValueModel
    extends StoreJsonSerializable<CheckoutAttributeValueModel>
    with _$CheckoutAttributeValueModel {
  factory CheckoutAttributeValueModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
      String? colorSquaresRgb,
      @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
      String? priceAdjustment,
      @JsonKey(name: 'IsPreSelected', includeIfNull: false)
      @Default(false)
      bool? isPreSelected,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutAttributeValueModel;

  factory CheckoutAttributeValueModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutAttributeValueModelFromJson(json);
}
