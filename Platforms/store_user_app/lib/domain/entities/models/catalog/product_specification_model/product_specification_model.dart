import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'product_specification_model.freezed.dart';
part 'product_specification_model.g.dart';

@freezed
class ProductSpecificationModel
    extends StoreJsonSerializable<ProductSpecificationModel>
    with _$ProductSpecificationModel {
  factory ProductSpecificationModel(
      {@JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
      String? specificationAttributeId,
      @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
      String? specificationAttributeName,
      @JsonKey(name: 'ValueRaw', includeIfNull: false) String? valueRaw,
      @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
      String? colorSquaresRgb,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductSpecificationModel;

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecificationModelFromJson(json);
}
