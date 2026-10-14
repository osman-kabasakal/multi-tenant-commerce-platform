import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/catalog_product_list_item_view.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/category_featured_products_skeleton.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../providers/category_featured_products_controller.dart';
import 'category_chip.dart';

class CategoryFeaturedProductsWidget extends StatefulHookConsumerWidget {
  const CategoryFeaturedProductsWidget({super.key});

  @override
  ConsumerState<CategoryFeaturedProductsWidget> createState() =>
      _CategoryFeaturedProductsWidgetState();
}

class _CategoryFeaturedProductsWidgetState
    extends ConsumerState<CategoryFeaturedProductsWidget> {
  bool _isVisible = false;
  int _selectedCategoryIndex = 0;

  // Dedicated scroll controllers for smoother scrolling
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void dispose() {
    _productScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('CategoryFeaturedProductsVisibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible ? _buildContent() : _buildPlaceholder(),
    );
  }

  Widget _buildContent() {
    return ref.watch(categoryFeaturedProductsProvider).when(
          data: (categories) {
            if (categories.isEmpty) return const SizedBox.shrink();

            // Extract active categories only once
            final activeCategories = categories
                .where((element) =>
                    element.featuredProducts != null &&
                    element.featuredProducts!.isNotEmpty)
                .toList();

            if (activeCategories.isEmpty) return const SizedBox.shrink();

            // Get featured products directly from the provider to avoid rebuilds
            final featuredProducts = ref
                .read(categoryFeaturedProductsControllerProvider(categories)
                    .notifier)
                .getProductsForCategory(_selectedCategoryIndex);

            return _buildCategoriesWithProducts(
                activeCategories, featuredProducts);
          },
          loading: () => _buildPlaceholder(),
          error: (error, stack) => AppErrorWidget(
            message:
                'Kategoriler yüklenirken beklenmedik bir hata oluştu! Lütfen tekrar deneyiniz.',
          ),
        );
  }

  Widget _buildCategoriesWithProducts(List<CategoryModel> activeCategories,
      List<ProductOverviewModel> featuredProducts) {
    final isDarkMode = getIt<ThemeController>().isDarkMode;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section - use const where possible
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Kategorilerden öne çıkanlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Categories horizontal list - optimized with RepaintBoundary
        RepaintBoundary(
          child: SizedBox(
            height: isSmallScreen ? 40 : 60,
            child: ListView.builder(
              controller: _categoryScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // Optimize by using itemExtent
              itemExtent: 120,
              itemCount: activeCategories.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final category = activeCategories[index];
                final isSelected = _selectedCategoryIndex == index;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == activeCategories.length - 1 ? 0 : 16,
                  ),
                  child: CategoryChip(
                    category: category,
                    isSelected: isSelected,
                    isDarkMode: isDarkMode,
                    onTap: () =>
                        _selectCategory(index, categories: activeCategories),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Products list - optimized with fixed height and caching
        if (featuredProducts.isNotEmpty)
          SizedBox(
            // Fixed height container instead of expanding list
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              controller: _productScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: featuredProducts.length,
              // Fixed itemExtent for better performance
              itemExtent: MediaQuery.of(context).size.width * 0.4,
              // Increase cacheExtent to prevent blank areas during fast scrolling
              cacheExtent: MediaQuery.of(context).size.width * 1.2,
              // Use better physics for smoother scrolling
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                // Use keys for better reconciliation
                return RepaintBoundary(
                  key: ValueKey('product-${product.id}'),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CatalogProductListItemView(
                      product: product,
                      onPressed: () {
                        context.router.push(
                          ProductRoute(productId: product.id ?? ''),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _selectCategory(int index, {required List<CategoryModel> categories}) {
    if (_selectedCategoryIndex != index) {
      setState(() {
        // Update the controller
        ref
            .read(categoryFeaturedProductsControllerProvider(
                    ref.read(categoryFeaturedProductsProvider).value ?? [])
                .notifier)
            .setIndex(index);

        // Scroll to top when switching categories
        if (_productScrollController.hasClients) {
          _productScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
        _selectedCategoryIndex = index;
      });
    }
  }

  Widget _buildPlaceholder() {
    return const CategoryFeaturedProductsSkeleton();
  }
}
