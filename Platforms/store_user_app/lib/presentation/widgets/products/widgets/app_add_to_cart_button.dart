import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_catalog_cart/product_catalog_cart.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/quick_add_to_cart_bottom_sheet.dart';

import '../../buttons/view/app_icon_button.dart';

class AppAddToCartButton extends HookConsumerWidget {
  final ProductOverviewModel product;
  const AppAddToCartButton({super.key, required this.product});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cartState = ref.watch(shoppingCartUseCaseProvider);
    return cartState.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (value) {
        if (value.cart?.items?.any(
              (element) => element.productId == product.id,
            ) ??
            false) {
          return AppIconButton(
            icon: Icon(LineIcons.check_circle_1, size: 32),
            iconLightColor: limeGreen,
            iconDarkColor: colorSecondary,
            onPressed: () async {
              var shoppingCartItem = value.cart?.items?.firstWhere(
                (element) => element.productId == product.id,
              );
              await ref
                  .read(shoppingCartUseCaseProvider.notifier)
                  .removeItem(shoppingCartItem!.id!);
            },
          );
        }
        return AppIconButton(
          icon: Icon(LineIcons.shopping_cart_arrow_down, size: 32),
          iconLightColor: peru,
          iconDarkColor: colorSecondary,
          onPressed: () async {
            if ((product.productAttributeModels != null &&
                    product.productAttributeModels!.isNotEmpty) ||
                (product.showQty != null && !product.showQty!)) {
              var quickViewModel = await (await getIt
                      .getAsync<ProductRepository>())
                  .getProductQuickView(product.id!);
              var detailResponse =
                  await showModalBottomSheet<ProductDetailsCart>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (bottomSheetContext) {
                      return QuickAddToCartBottomSheet(
                        product: quickViewModel!.data!.model!,
                      );
                    },
                  );
              if (detailResponse != null) {
                await ref
                    .read(shoppingCartUseCaseProvider.notifier)
                    .addToCart(detailResponse);
              }
              return;
            } else {
              await ref
                  .read(shoppingCartUseCaseProvider.notifier)
                  .addToCardCatalog(
                    ProductCatalogCart(
                      productId: product.id,
                      quantity: 1,
                      shoppingCartTypeId: ShoppingCartType.shoppingCart,
                      forceRedirection:
                          product
                              .productPrice
                              ?.forceRedirectionAfterAddingToCart,
                    ),
                  );
            }
          },
        );
      },
      error: (err, stack) => Icon(Icons.error, color: redColor, size: 32),
      loading:
          () => SizedBox(
            width: 32,
            height: 32,
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
