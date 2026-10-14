import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../catalog_paging_filtering_model/catalog_paging_filtering_model.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@freezed
class BrandModel extends StoreJsonSerializable<BrandModel> with _$BrandModel {
  factory BrandModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'BottomDescription', includeIfNull: false)
      String? bottomDescription,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      CatalogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);
}
