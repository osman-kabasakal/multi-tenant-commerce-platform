import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../catalog_paging_filtering_model/catalog_paging_filtering_model.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'products_by_tag_model.freezed.dart';
part 'products_by_tag_model.g.dart';

@freezed
class ProductsByTagModel extends StoreJsonSerializable<ProductsByTagModel>
    with _$ProductsByTagModel {
  factory ProductsByTagModel(
      {@JsonKey(name: 'TagName', includeIfNull: false) String? tagName,
      @JsonKey(name: 'TagSeName', includeIfNull: false) String? tagSeName,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      CatalogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductsByTagModel;

  factory ProductsByTagModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsByTagModelFromJson(json);
}
