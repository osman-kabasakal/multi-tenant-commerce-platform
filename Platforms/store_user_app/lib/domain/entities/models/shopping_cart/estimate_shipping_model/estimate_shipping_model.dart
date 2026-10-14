import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../../../common/user_field/user_field.dart';

part 'estimate_shipping_model.freezed.dart';
part 'estimate_shipping_model.g.dart';

@freezed
class EstimateShippingModel extends StoreJsonSerializable<EstimateShippingModel>
    with _$EstimateShippingModel {
  factory EstimateShippingModel(
      {@JsonKey(name: 'Enabled', includeIfNull: false)
      @Default(false)
      bool? enabled,
      @JsonKey(name: 'CountryId', includeIfNull: false) String? countryId,
      @JsonKey(name: 'StateProvinceId', includeIfNull: false)
      String? stateProvinceId,
      @JsonKey(name: 'ZipPostalCode', includeIfNull: false)
      String? zipPostalCode,
      @JsonKey(name: 'AvailableCountries', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCountries,
      @JsonKey(name: 'AvailableStates', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableStates,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _EstimateShippingModel;

  factory EstimateShippingModel.fromJson(Map<String, dynamic> json) =>
      _$EstimateShippingModelFromJson(json);
}
