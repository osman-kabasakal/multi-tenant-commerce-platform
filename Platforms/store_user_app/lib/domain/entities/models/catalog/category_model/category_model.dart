import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../catalog_paging_filtering_model/catalog_paging_filtering_model.dart';
import 'sub_category_model/sub_category_model.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel extends StoreJsonSerializable<CategoryModel>
    with _$CategoryModel {
  factory CategoryModel(
      {@JsonKey(name: 'ParentCategoryId', includeIfNull: false)
      String? parentCategoryId,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'BottomDescription', includeIfNull: false)
      String? bottomDescription,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
      @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
      @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      CatalogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
      @Default(false)
      bool? displayCategoryBreadcrumb,
      @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
      @Default([])
      List<CategoryModel>? categoryBreadcrumb,
      @JsonKey(name: 'SubCategories', includeIfNull: false)
      @Default([])
      List<SubCategoryModel>? subCategories,
      @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? featuredProducts,
      @JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
