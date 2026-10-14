import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/presentation/screens/product/widgets/prices_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_async_waiter_button.dart';

class AddToCartBottomBar extends ConsumerWidget {
  final ProductDetailsModel product;
  final FutureOr<void> Function() onAddToCart;
  final FutureOr<void> Function() onBuyNow;
  final FutureOr<void> Function() onOutOfStockSubscription;

  const AddToCartBottomBar({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.onOutOfStockSubscription,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.primaryColor
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.grey
                : const Color(0xffE85C31).withValues(alpha: 0.10),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      // Remove fixed height to allow dynamic sizing based on content
      // Add minimum constraints for better UI
      constraints: const BoxConstraints(
        minHeight: 83,
      ),
      // SafeArea.bottom ensures we respect safe areas on devices with notches or home indicators
      padding: EdgeInsets.only(
        left: 15, 
        right: 15, 
        top: 15,
        bottom: mediaQuery.padding.bottom + 10, // Added extra bottom padding for more space
      ),
      child: IntrinsicHeight( // This makes the children have the same height
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price section
            Expanded(
              flex: 3,
              child: PricesWidget(
                model: product.productPrice!,
                productId: product.id!,
                onCallForPrice: () {},
              ),
            ),
            // Button section fixed at the right
            Container(
              width: mediaQuery.size.width * 0.4, // Fixed width based on screen width
              alignment: Alignment.centerRight,
              // Use alignment to keep buttons at the bottom when content height increases
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildActionButtons(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(ThemeData theme) {
    if (!((product.productPrice?.disableBuyButton ?? false) &&
        !(product.productPrice?.enteredPrice ?? false))) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Cart button
            AppAsyncWaiterButton(
              onPressed: onAddToCart,
              child: Container(
                height: 36,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffE85C31)),
                    left: BorderSide(color: Color(0xffE85C31)),
                    bottom: BorderSide(color: Color(0xffE85C31)),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    LineIcons.shopping_cart_arrow_down,
                    size: 20,
                    color: theme.brightness == Brightness.dark
                        ? colorSecondary
                        : limeGreen,
                  ),
                ),
              ),
            ),

            // Buy now button
            Expanded(
              child: AppAsyncWaiterButton(
                onPressed: onBuyNow,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : theme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product.addToCart?.updatedShoppingCartItemId != null
                          ? 'Sepeti Güncelle'
                          : 'Sepete Ekle',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? theme.primaryColor
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (((product.productPrice?.disableBuyButton ?? false) &&
            !(product.productPrice?.enteredPrice ?? false)) &&
        !(product.stockAvailability.isEmptyOrNull &&
            !(product.displayOutOfStockSubscription ?? false))) {
      return SizedBox(
        height: 36,
        child: GestureDetector(
          onTap: onBuyNow,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : theme.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'Gelince Haber Ver',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? theme.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
