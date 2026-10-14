import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../product_attribute_model/product_attribute_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_bundle_model.freezed.dart';
part 'product_bundle_model.g.dart';

@freezed
class ProductBundleModel extends StoreJsonSerializable<ProductBundleModel>
    with _$ProductBundleModel {
  factory ProductBundleModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
      @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'Price', includeIfNull: false) String? price,
      @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
      @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
      PictureModel? defaultPictureModel,
      @JsonKey(name: 'ProductAttributes', includeIfNull: false)
      @Default([])
      List<ProductAttributeModel>? productAttributes,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductBundleModel;

  factory ProductBundleModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBundleModelFromJson(json);
}
