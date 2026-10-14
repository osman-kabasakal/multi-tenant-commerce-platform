import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';

part 'category_featured_products_view_model.freezed.dart';

@freezed
class CategoryFeaturedProductsViewModel
    with _$CategoryFeaturedProductsViewModel {
  const factory CategoryFeaturedProductsViewModel({
    @Default(0) selectedCategoryIndex,
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<ProductOverviewModel> featuredProducts,
    @Default([]) List<CategoryModel> activeCategories,
  }) = _CategoryFeaturedProductsViewModel;
}
