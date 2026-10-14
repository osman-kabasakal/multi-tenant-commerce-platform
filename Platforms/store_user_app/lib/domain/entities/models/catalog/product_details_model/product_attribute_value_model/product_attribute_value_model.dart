import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_attribute_value_model.freezed.dart';
part 'product_attribute_value_model.g.dart';

@freezed
class ProductAttributeValueModel
    extends StoreJsonSerializable<ProductAttributeValueModel>
    with _$ProductAttributeValueModel {
  factory ProductAttributeValueModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
      String? colorSquaresRgb,
      @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
      PictureModel? imageSquaresPictureModel,
      @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
      String? priceAdjustment,
      @JsonKey(name: 'PriceAdjustmentValue', includeIfNull: false)
      double? priceAdjustmentValue,
      @JsonKey(name: 'StockAvailability', includeIfNull: false)
      String? stockAvailability,
      @JsonKey(name: 'IsPreSelected', includeIfNull: false)
      @Default(false)
      bool? isPreSelected,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductAttributeValueModel;

  factory ProductAttributeValueModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeValueModelFromJson(json);
}
