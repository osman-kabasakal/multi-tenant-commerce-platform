import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class WishlistCartItemListTile extends HookConsumerWidget {
  final ShoppingCartItemModel cartItem;
  final FutureOr<void> Function()? onRemove;
  final FutureOr<void> Function()? onIncrease;
  final FutureOr<void> Function()? onDecrease;
  final FutureOr<void> Function(int selectedQuantity)? onChanged;
  final FutureOr<void> Function()? onAddToCart;
  final FutureOr<void> Function()? onItemEdit;
  final bool showDetailedView;

  const WishlistCartItemListTile({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onDecrease,
    this.onIncrease,
    this.onChanged,
    this.onAddToCart,
    this.onItemEdit,
    this.showDetailedView = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      :pending,
      :snapshot,
      hasError: _,
      loaderColor: _,
      loaderStrokeWidth: _,
    ) = useAsyncTask<void>();

    var allowedQuantityBuilder = FormBuilder<ShoppingCartItemModel>(cartItem)
      ..addDropDownField(
        'Quantity',
        (model) => (model.quantity ?? 0),
        (option) => (option.allowedQuantities ?? <SelectListItem>[]),
        (opt) => opt.text ?? '',
        (opt) => int.parse(opt.value ?? '0'),
        initalSelectedValues: [cartItem.quantity],
      );

    var formController = AppFormController(
      allowedQuantityBuilder.build(),
      onFieldChange: (field, value) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return;
        }
        pending.value = (() async => await onChanged?.call(value))();
      },
    );

    var themeController = getIt<ThemeController>();

    final isDarkMode = themeController.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main content - Image and Details
          InkWell(
            onTap: () {
              context.router.pushNamed('/product/${cartItem.productId}');
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDarkMode ? darkPrimary : colorGrey100,
                      ),
                      child: OptimizedCacheImage(
                        imageUrl: cartItem.picture?.imageUrl ?? '',
                        sizeConfig: const ImageSizeConfig(
                          width: 100,
                          height: 100,
                        ),
                        fit: BoxFit.cover,
                        placeholder: Container(
                          color: isDarkMode ? darkPrimary : colorGrey100,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 30,
                              color: colorGrey400,
                            ),
                          ),
                        ),
                        errorWidget: Container(
                          color: isDarkMode ? darkPrimary : colorGrey100,
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 30,
                              color: colorGrey400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name & Edit Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                cartItem.productName ?? '',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if ((cartItem.allowItemEditing ?? false) &&
                                !cartItem.attributeInfo.isEmptyOrNull)
                              AppIconButton(
                                icon: SvgPicture.asset(
                                  editIcon,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () async {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return;
                                  }
                                  pending.value =
                                      (() async => await onItemEdit?.call())();
                                },
                              ),
                          ],
                        ),

                        // SKU
                        if (cartItem.sku != null && showDetailedView)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'SKU: ${cartItem.sku}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colorGrey500),
                            ),
                          ),

                        // Attributes
                        if (cartItem.attributeInfo != null &&
                            cartItem.attributeInfo!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Html(
                              data: cartItem.attributeInfo.toString(),
                              style: {
                                "body": Style(
                                  fontSize: FontSize(12),
                                  color: grey,
                                  fontWeight: FontWeight.normal,
                                  fontFamily:
                                      context.textTheme.bodyMedium?.fontFamily,
                                ),
                              },
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              // style: context.textTheme.bodyMedium?.copyWith(
                              //   fontWeight: FontWeight.normal,
                              // ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Price Information
                        Text(
                          cartItem.unitPrice ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: '',
                          ),
                        ),

                        if (cartItem.discount != null && showDetailedView)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.discount_outlined,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'İndirim: ${cartItem.discount}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontFamily: '',
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Item Warnings
                        if (cartItem.warnings != null &&
                            cartItem.warnings!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    cartItem.warnings!
                                        .map(
                                          (warning) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.warning_amber_rounded,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    warning,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Colors.red,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quantity Control Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? darkPrimary.withValues(alpha: 0.3) : colorGrey50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Subtotal Row with Delete Button
                if (showDetailedView)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Toplam:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cartItem.subTotal ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: '',
                            ),
                          ),
                        ],
                      ),
                      AppIconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: appRedColor,
                        ),
                        onPressed: () async {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return;
                          }
                          pending.value =
                              (() async => await onRemove?.call())();
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                // Quantity Controls and Add to Cart Button
                Row(
                  children: [
                    // Quantity label and controls section
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Miktar:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 12),
                          if (cartItem.allowedQuantities?.isNotEmpty ?? false)
                            // Dropdown for allowed quantities
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isDarkMode ? darkPrimary : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        isDarkMode ? borderDark : borderColor,
                                  ),
                                ),
                                child: GenericForm(
                                  formBuilder: allowedQuantityBuilder,
                                  formController: formController,
                                ),
                              ),
                            )
                          else
                            // Quantity adjustment controls
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      isDarkMode ? darkPrimary : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        isDarkMode ? borderDark : borderColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Decrease button
                                    AppIconButton(
                                      icon:
                                          (cartItem.quantity ?? 0) <= 1
                                              ? const Icon(
                                                Icons.delete_outline,
                                                color: appRedColor,
                                                size: 20,
                                              )
                                              : SvgPicture.asset(
                                                themeController.isDarkMode
                                                    ? minusDarkIcon
                                                    : minusIcon,
                                                width: 20,
                                                height: 20,
                                              ),
                                      onPressed: () async {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return;
                                        }
                                        if ((cartItem.quantity ?? 0) <= 1) {
                                          pending.value =
                                              (() async =>
                                                  await onRemove?.call())();
                                        } else {
                                          pending.value =
                                              (() async =>
                                                  await onDecrease?.call())();
                                        }
                                      },
                                    ),

                                    // Current quantity
                                    Text(
                                      '${cartItem.quantity ?? 0}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Increase button
                                    AppIconButton(
                                      icon: SvgPicture.asset(
                                        themeController.isDarkMode
                                            ? addDarkIcon
                                            : addIcon,
                                        width: 20,
                                        height: 20,
                                      ),
                                      onPressed: () async {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return;
                                        }
                                        pending.value =
                                            (() async =>
                                                await onIncrease?.call())();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Add to cart button
                    if (onAddToCart != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          height: 40,
                          child: AppCommonButton.adaptive(
                            text: 'Sepete Ekle',
                            fontSizeRate: .2,
                            onPressed: () async {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return;
                              }
                              pending.value =
                                  (() async => await onAddToCart?.call())();
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Loading indicator
          if (snapshot.connectionState == ConnectionState.waiting)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              height: 3,
              width: double.infinity,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
