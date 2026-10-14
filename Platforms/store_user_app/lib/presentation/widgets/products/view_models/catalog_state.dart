import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/catalog/brand_brief_info_model/brand_brief_info_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/brand_model/brand_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/specification_filter_model/specification_filter_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/collection_model/collection_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/vendor_model/vendor_model.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/filter_state.dart';

import 'product_view_type.dart';

part 'catalog_state.freezed.dart';

@freezed
class CatalogState with _$CatalogState {
  const factory CatalogState({
    @Default([]) List<ProductOverviewModel> products,
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<BrandModel> brands,
    @Default([]) List<CollectionModel> collections,
    @Default([]) List<VendorModel> vendors,
    @Default(FilterState()) FilterState filter,
    @Default(ProductViewType.list) ProductViewType viewType,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    String? error,
    @Default(0) int totalProducts,
  }) = _CatalogState;

  const CatalogState._();

  bool get isEmpty => products.isEmpty && !isLoading && error == null;
  bool get hasData => products.isNotEmpty;
}
