import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../catalog/product_type/product_type.dart';

import '../../../tax/tax_display_type/tax_display_type.dart';

import '../../../catalog/interval_unit/interval_unit.dart';

import 'product_price_model/product_price_model.dart';

import '../../media/picture_model/picture_model.dart';

import '../product_specification_model/product_specification_model.dart';

import 'product_attribute_model/product_attribute_model.dart';

import '../product_review_overview_model/product_review_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_overview_model.freezed.dart';
part 'product_overview_model.g.dart';

@freezed
class ProductOverviewModel extends StoreJsonSerializable<ProductOverviewModel>
    with _$ProductOverviewModel {
  factory ProductOverviewModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'FullDescription', includeIfNull: false)
      String? fullDescription,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Url', includeIfNull: false) String? url,
      @JsonKey(name: 'ProductType', includeIfNull: false)
      @Default(ProductType.simpleProduct)
      ProductType? productType,
      @JsonKey(name: 'MarkAsNew', includeIfNull: false)
      @Default(false)
      bool? markAsNew,
      @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
      @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
      @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
      @JsonKey(name: 'BrandName', includeIfNull: false) String? brandName,
      @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
      @Default(false)
      bool? isFreeShipping,
      @JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'ShowQty', includeIfNull: false)
      @Default(false)
      bool? showQty,
      @JsonKey(name: 'LowStock', includeIfNull: false)
      @Default(false)
      bool? lowStock,
      @JsonKey(name: 'EndTime', includeIfNull: false)
      @Default(null)
      DateTime? endTime,
      @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
      @Default(null)
      DateTime? endTimeLocalTime,
      @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
      @Default(TaxDisplayType.includingTax)
      TaxDisplayType? taxDisplayType,
      @JsonKey(name: 'Interval', includeIfNull: false) int? interval,
      @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
      @Default(IntervalUnit.minute)
      IntervalUnit? intervalUnitId,
      @JsonKey(name: 'ProductPrice', includeIfNull: false)
      ProductPriceModel? productPrice,
      @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
      PictureModel? defaultPictureModel,
      @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
      PictureModel? secondPictureModel,
      @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
      @Default([])
      List<ProductSpecificationModel>? specificationAttributeModels,
      @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
      @Default([])
      List<ProductAttributeModel>? productAttributeModels,
      @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
      ProductReviewOverviewModel? reviewOverviewModel,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductOverviewModel;

  factory ProductOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductOverviewModelFromJson(json);
}
