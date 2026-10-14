import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

import '../view_models/category_featured_products_view_model.dart';

part 'category_featured_products_controller.g.dart';

@riverpod
class CategoryFeaturedProducts extends _$CategoryFeaturedProducts
    with CacheInvalidationBase, CacheAwareAsyncProvider<List<CategoryModel>> {
  @override
  FutureOr<List<CategoryModel>> build() async {
    await registerCorrelation();
    var compoenentRepository = await getIt.getAsync<ComponentRepository>();
    try {
      var products =
          await correlationService.runRepositoryMethodWithCorrelation(
              correlationId,
              () async =>
                  await compoenentRepository.getCategoryFeaturedProducts(200));
      return products ?? [];
    } catch (e) {
      return [];
    }
  }
}

@riverpod
class CategoryFeaturedProductsController
    extends _$CategoryFeaturedProductsController {
  @override
  CategoryFeaturedProductsViewModel build(List<CategoryModel> categories) {
    var activeCategories = categories
        .where((element) =>
            element.featuredProducts != null &&
            element.featuredProducts!.isNotEmpty)
        .toList();

    return CategoryFeaturedProductsViewModel(
      categories: categories,
      featuredProducts: activeCategories.isNotEmpty
          ? activeCategories[0].featuredProducts ?? []
          : [],
      activeCategories: activeCategories,
    );
  }

  void setIndex(int categoryIndex) {
    if (categoryIndex == state.selectedCategoryIndex) return;

    state = state.copyWith(
      selectedCategoryIndex: categoryIndex,
      featuredProducts:
          state.activeCategories[categoryIndex].featuredProducts ?? [],
    );
  }

  // New method to get products without causing a rebuild
  List<ProductOverviewModel> getProductsForCategory(int categoryIndex) {
    if (state.activeCategories.isEmpty ||
        categoryIndex >= state.activeCategories.length) {
      return [];
    }

    return state.activeCategories[categoryIndex].featuredProducts ?? [];
  }
}
