import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/repositories/catalog/catalog_repository.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/product_catalog_widget.dart';
import 'package:store_user_app/presentation/widgets/shopping_cart_info/widgets/shopping_cart_info_widget.dart';

@RoutePage()
class CategoryScreen extends HookConsumerWidget {
  final String categoryId;
  final ValueNotifier<CategoryModel?> category = ValueNotifier(null);
  int totalProducts = 0;
  CategoryScreen(
      {super.key, @PathParam('categoryId') required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      return () {
        category.dispose();
      };
    }, [category]);
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          const ShoppingCartInfoWidget(
            variant: ShoppingCartInfoVariant.fixed,
            dismissible: true,
          ),
          Expanded(
            child: ProductCatalogWidget(
              title: 'Category',
              priceFilterEnabled: false,
              categoryId: categoryId,
              onStateUpdated: (state) {
                totalProducts = state.totalProducts;
                category.value = state.filter.selectedCategoryModel;
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.router.maybePop(context);
        },
      ),
      backgroundColor:
          getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white,
      title: ValueListenableBuilder(
        valueListenable: category,
        builder: (context, categoryState, child) {
          return Text(
            '${categoryState?.name ?? '...'} | $totalProducts Ürün',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
                fontSize: 20),
          );
        },
      ),
    );
  }
}
