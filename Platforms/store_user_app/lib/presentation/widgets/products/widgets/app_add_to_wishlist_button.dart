import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';
import 'package:store_user_app/domain/usecases/wish_list/wish_list_use_case.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/quick_add_to_cart_bottom_sheet.dart';

import '../../buttons/view/app_icon_button.dart';

class AppAddToWishlistButton extends HookConsumerWidget {
  final ProductOverviewModel product;
  const AppAddToWishlistButton({super.key, required this.product});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cartState = ref.watch(wishListUseCaseProvider);
    return cartState.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (value) {
        return AppIconButton(
            icon: SvgPicture.asset(
              value.wishListItems.containsKey(product.id)
                  ? heartFillIcon
                  : heartIcon,
              width: 24,
              height: 24,
            ),
            onPressed: () async {
              if (value.wishListItems.containsKey(product.id)) {
                await ref
                    .read(wishListUseCaseProvider.notifier)
                    .removeFromWishListByProductId(product.id!);
              } else {
                if ((product.productAttributeModels != null &&
                        product.productAttributeModels!.isNotEmpty) ||
                    (product.showQty != null && !product.showQty!)) {
                  var quickViewModel =
                      await (await getIt.getAsync<ProductRepository>())
                          .getProductQuickView(product.id!);
                  var detailResponse = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      builder: (bottomSheetContext) {
                        return QuickAddToCartBottomSheet(
                          product: quickViewModel!.data!.model!,
                        );
                      });
                  if (detailResponse != null &&
                      detailResponse is ProductDetailsCart) {
                    await ref
                        .read(wishListUseCaseProvider.notifier)
                        .addToWisList(detailResponse.copyWith(
                          shoppingCartTypeId: ShoppingCartType.wishlist,
                        ));
                  }
                  return;
                } else {
                  await ref
                      .read(wishListUseCaseProvider.notifier)
                      .addToWisList(ProductDetailsCart(
                        productId: product.id,
                        shoppingCartTypeId: ShoppingCartType.wishlist,
                        enteredQuantity: 1,
                      ));
                }
              }
            });
      },
      error: (err, stack) => Icon(
        Icons.error,
        color: redColor,
        size: 32,
      ),
      loading: () => SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
