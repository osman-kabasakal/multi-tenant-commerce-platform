import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/list_extensions.dart';
import 'package:store_user_app/domain/entities/catalog/product_type/product_type.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_add_to_cart_button.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_add_to_wishlist_button.dart';

class CatalogProductListItemView extends HookConsumerWidget {
  final ProductOverviewModel product;
  final VoidCallback onPressed;
  final bool readOnly;

  const CatalogProductListItemView({
    super.key,
    required this.product,
    required this.onPressed,
    this.readOnly = false,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var discountRate = _calculateDiscountRate(product);
    final sperator = Text(
      "|",
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: themeController.isDarkMode ? colorGrey300 : colorGrey700,
      ),
    );

    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, boxSize) {
              // Get screen width
              var screenWidth =
                  boxSize.hasBoundedWidth
                      ? boxSize.maxWidth
                      : MediaQuery.of(context).size.width;
              return Stack(
                children: [
                  Builder(
                    builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildProductImage(
                            context,
                            themeController,
                            screenWidth,
                          ),
                          10.width,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight:
                                            20.0, // Minimum height for title
                                        maxHeight:
                                            44.0, // Maximum height for title (approx 2 lines)
                                      ),
                                      child: Text(
                                        product.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 4.0), // Consistent spacing
                                    if (product.shortDescription != null &&
                                        product.shortDescription!.isNotEmpty)
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight:
                                              16.0, // Minimum height for description
                                          maxHeight:
                                              36.0, // Maximum height for description (approx 2 lines)
                                        ),
                                        child: Text(
                                          product.shortDescription.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    themeController.isDarkMode
                                                        ? colorGrey300
                                                        : colorGrey700,
                                              ),
                                        ),
                                      ),
                                    SizedBox(height: 8.0), // Consistent spacing
                                  ],
                                ),
                                Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 5,
                                  children: [
                                    if (product.lowStock ?? false)
                                      Text(
                                        'Tükenmek Üzere',
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: appRedColor,
                                            ),
                                      ),
                                    if (product.brandName != null &&
                                        product.brandName!.isNotEmpty)
                                      Text(
                                        product.brandName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  themeController.isDarkMode
                                                      ? colorGrey300
                                                      : colorGrey700,
                                            ),
                                      ),
                                    _buildRating(
                                      context,
                                      themeController,
                                      context.theme,
                                    ),
                                  ].joinBySperatedWidget(sperator),
                                ),
                                SizedBox(height: 8.0), // Fixed spacing
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (product.isFreeShipping ?? false)
                                      _buildShippingInfo(
                                        context,
                                        themeController,
                                        context.theme,
                                      ),
                                    _buildPrice(
                                      context,
                                      themeController,
                                      context.theme,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 8,
                      children: [
                        if (product.productType == ProductType.auction &&
                            product.endTimeLocalTime != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: dodgerBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child:
                                product.endTimeLocalTime!.isAfter(
                                      DateTime.now(),
                                    )
                                    ? Text(
                                      'Devam Ediyor',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    )
                                    : Text(
                                      'Bitti',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                          ),
                        if (!product.flag.isEmptyOrNull)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: dodgerBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.flag!,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (product.markAsNew ?? false)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Yeni',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (discountRate != null &&
                            discountRate.isNotEmpty &&
                            (int.tryParse(discountRate) ?? 0) > 0)
                          Container(
                            // width: 46,
                            // height: 24,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: colorPrimary,
                            ),
                            child: Center(
                              child: Text(
                                '-%$discountRate',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!readOnly)
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: AppAddToWishlistButton(product: product),
                    ),
                  if (!readOnly)
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: AppAddToCartButton(product: product),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String? _calculateDiscountRate(ProductOverviewModel product) {
    final price = product.productPrice?.priceValue;
    final oldPrice = _getOldPriceValue();

    if (price != null && oldPrice != null && oldPrice > 0) {
      return ((oldPrice - price) / oldPrice * 100).toStringAsFixed(0);
    }
    return null;
  }

  Widget _buildRating(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    if (product.reviewOverviewModel != null) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        direction: Axis.horizontal,
        children: [
          Icon(
            Icons.star,
            size: theme.textTheme.labelSmall!.fontSize,
            color: colorSecondary,
          ),
          Text(
            '${product.reviewOverviewModel?.avgRating?.toStringAsFixed(1)} (${product.reviewOverviewModel?.totalReviews})',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildProductImage(
    BuildContext context,
    ThemeController themeController,
    double screenWidth,
  ) {
    // Use fixed, consistent dimensions for the product image
    final imageSize = min(screenWidth * 0.30, 100.0);

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: OptimizedCacheImage(
              imageUrl: product.defaultPictureModel?.imageUrl ?? '',
              sizeConfig: ImageSizeConfig(width: imageSize, height: imageSize),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingInfo(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    if (product.isFreeShipping ?? false) {
      return Row(
        children: [
          SvgPicture.asset(vehicleIcon, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(
            'Ücretsiz',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  double? _getOldPriceValue() {
    if (product.productType != ProductType.auction) {
      return product.productPrice?.oldPriceValue;
    } else {
      return (product.productPrice?.highestBidValue ?? 0) > 0
          ? product.productPrice?.highestBidValue
          : product.productPrice?.startPriceValue;
    }
  }

  String _getOldPrice() {
    if (product.productType != ProductType.auction) {
      return product.productPrice?.oldPrice ??
          ((product.productPrice?.callForPrice ?? false)
              ? 'Fiyat için arayınız'
              : '');
    } else {
      return (product.productPrice?.highestBidValue ?? 0) > 0
          ? product.productPrice?.highestBid ?? ''
          : product.productPrice?.startPrice ?? '';
    }
  }

  Widget _buildPrice(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    var oldPrice = _getOldPriceValue();
    var priceSuffix =
        oldPrice != null && product.productPrice?.preferredTierPrice != null
            ? '(En düşük)'
            : null;
    return Wrap(
      spacing: 4,
      direction: Axis.horizontal,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        if (oldPrice != null) ...[
          Text(
            _getOldPrice(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: '',
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w500,
              color: themeController.isDarkMode ? colorGrey300 : colorGrey500,
            ),
          ),
        ],
        if (priceSuffix != null) ...[
          Text(
            priceSuffix,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: themeController.isDarkMode ? colorGrey300 : colorGrey500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        Text(
          product.productPrice?.price ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: '',
            color: colorPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
