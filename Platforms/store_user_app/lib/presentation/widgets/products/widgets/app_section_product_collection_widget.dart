import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/catalog_product_list_item_view.dart';

import 'product_item_widget.dart';

class AppSectionProductCollectionWidget extends HookConsumerWidget {
  final String title;
  final List<ProductOverviewModel> products;
  final FutureOr<void> Function()? onSeeAllPressed;
  final bool showTitle;
  final Axis scrollDirection;

  const AppSectionProductCollectionWidget({
    super.key,
    required this.products,
    required this.title,
    this.onSeeAllPressed,
    this.showTitle = true,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get screen width
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onSeeAllPressed != null)
                  TextButton(
                    onPressed: () {
                      // context.router.push(const DiscountedProductsRoute());
                    },
                    child: Text(
                      seeAll,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        scrollDirection == Axis.horizontal
            ? Container(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? colorGrey800
                      : colorGrey100,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: screenWidth * .95, // Adjust height based on screen size
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == products.length - 1 ? 0 : 15,
                      ),
                      child: ProductItemWidget(
                        product: products[index],
                        onPressed: () {
                          context.router.navigate(
                            ProductRoute(productId: products[index].id ?? ''),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            )
            :
            // HorizontalList(
            //     padding: EdgeInsets.zero,
            //     itemCount: products.length,
            //     itemBuilder: (context, index) {
            //       return CatalogProductListItemView(
            //           product: products[index], onPressed: () {});
            //     },
            //   )
            Container(
              color: colorGrey100,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemExtent: screenWidth * 0.4,
                itemBuilder: (context, index) {
                  return CatalogProductListItemView(
                    product: products[index],
                    onPressed: () {
                      context.router.push(
                        ProductRoute(productId: products[index].id ?? ''),
                      );
                    },
                  );
                },
              ),
            ),
      ],
    );
  }
}
