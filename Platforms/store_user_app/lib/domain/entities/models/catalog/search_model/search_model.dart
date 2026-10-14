import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../catalog_paging_filtering_model/catalog_paging_filtering_model.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

@freezed
class SearchModel extends StoreJsonSerializable<SearchModel>
    with _$SearchModel {
  factory SearchModel(
      {@JsonKey(name: 'Warning', includeIfNull: false) String? warning,
      @JsonKey(name: 'NoResults', includeIfNull: false)
      @Default(false)
      bool? noResults,
      @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
      String? searchCategoryId,
      @JsonKey(name: 'q', includeIfNull: false) String? q,
      @JsonKey(name: 'cid', includeIfNull: false) String? cid,
      @JsonKey(name: 'isc', includeIfNull: false) @Default(false) bool? isc,
      @JsonKey(name: 'mid', includeIfNull: false) String? mid,
      @JsonKey(name: 'vid', includeIfNull: false) String? vid,
      @JsonKey(name: 'pf', includeIfNull: false) String? pf,
      @JsonKey(name: 'pt', includeIfNull: false) String? pt,
      @JsonKey(name: 'sid', includeIfNull: false) @Default(false) bool? sid,
      @JsonKey(name: 'adv', includeIfNull: false) @Default(false) bool? adv,
      @JsonKey(name: 'asv', includeIfNull: false) @Default(false) bool? asv,
      @JsonKey(name: 'Box', includeIfNull: false) @Default(false) bool? box,
      @JsonKey(name: 'AvailableCategories', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCategories,
      @JsonKey(name: 'AvailableCollections', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCollections,
      @JsonKey(name: 'AvailableVendors', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableVendors,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      CatalogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _SearchModel;

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
}
