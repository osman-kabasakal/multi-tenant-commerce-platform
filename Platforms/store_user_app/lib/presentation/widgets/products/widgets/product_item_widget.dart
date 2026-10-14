import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/list_extensions.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/catalog/product_type/product_type.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_add_to_cart_button.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_add_to_wishlist_button.dart';
import 'package:store_user_app/presentation/widgets/slider/view/colored_text_slider.dart';
import 'package:store_user_app/presentation/widgets/slider/view_models/colored_text_item_model.dart';

class ProductItemWidget extends HookConsumerWidget {
  final ProductOverviewModel product;
  final VoidCallback onPressed;

  const ProductItemWidget({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var theme = context.theme;

    return GestureDetector(
      onTap: onPressed,
      child: LayoutBuilder(
        builder: (context, boxSize) {
          var referelSize =
              !boxSize.hasBoundedWidth
                  ? context.width() * 0.6
                  : boxSize.maxWidth;
          return Card(
            elevation: 3,
            child: Container(
              width: referelSize, // Adjust width based on screen size
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: themeController.isDarkMode ? cardDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildProductImage(
                        context,
                        themeController,
                        theme,
                        referelSize,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 16,
                            right: 16,
                            bottom: 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _buildProductTitle(
                                context,
                                themeController,
                                theme,
                              ),
                              const SizedBox(height: 2),
                              _buildProductDetails(
                                context,
                                themeController,
                                theme,
                              ),
                              const Spacer(), // Esnek boşluk
                              _buildPriceAndRating(
                                context,
                                themeController,
                                theme,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Badges
                  Positioned(
                    top: 12,
                    left: 16,
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 8,
                      children: [
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
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child:
                        (product.productPrice?.disableWishlistButton ?? true)
                            ? const SizedBox.shrink()
                            : AppAddToWishlistButton(product: product),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child:
                        (product.productPrice?.disableBuyButton ?? true)
                            ? const SizedBox.shrink()
                            : AppAddToCartButton(product: product),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget _buildProductImage(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
    double screenWidth,
  ) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: OptimizedCacheImage(
            imageUrl: product.defaultPictureModel?.imageUrl ?? '',
            sizeConfig: ImageSizeConfig(
              width: screenWidth * 1.1,
              height: screenWidth,
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          width: screenWidth,
          child: ColoredTextSlider(
            autoSlideDuration: Duration(seconds: 2),
            borderRadius: 0,
            textStyle: context.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            items: [
              if (product.productType == ProductType.auction &&
                  product.endTimeLocalTime != null)
                ColoredTextItemModel(
                  text:
                      product.endTimeLocalTime!.isAfter(DateTime.now())
                          ? 'Devam Ediyor'
                          : 'Bitti',
                  color:
                      product.endTimeLocalTime!.isAfter(DateTime.now())
                          ? dodgerBlue
                          : colorGrey600,
                ),
              if (product.productPrice?.appliedDiscounts != null &&
                  (product.productPrice?.appliedDiscounts!.isNotEmpty ??
                      false)) ...[
                ...product.productPrice!.appliedDiscounts!.map(
                  (e) => ColoredTextItemModel(
                    text: '🏷️ ${e.couponCode ?? 'İndirimli'}',
                    color: const Color.fromARGB(255, 0, 162, 255),
                  ),
                ),
              ],
              if (product.productPrice?.preferredTierPrice != null)
                ColoredTextItemModel(
                  text: '🏷️ Çok Al Az Öde',
                  color: const Color.fromARGB(255, 175, 11, 200),
                ),
              if (!product.flag.isEmptyOrNull)
                ColoredTextItemModel(text: product.flag!, color: dodgerBlue),
              if (product.lowStock ?? false)
                ColoredTextItemModel(
                  text: '🛍️ Tükenmek Üzere',
                  color: appRedColor,
                ),
              if (product.markAsNew ?? false)
                ColoredTextItemModel(text: '🎉 Yeni', color: colorPrimary),
              if (_calculateDiscountRate(product) != null)
                ColoredTextItemModel(
                  text: '🏷️ -%${_calculateDiscountRate(product)}',
                  color: colorSecondary,
                ),
            ],
          ),
        ),
        if ((product.productAttributeModels?.isNotEmpty ?? false) &&
            product.productAttributeModels!.any(
              (element) =>
                  element.attributeControlType ==
                      AttributeControlType.colorSquares &&
                  element.values!.any(
                    (av) => !av.colorSquaresRgb.isEmptyOrNull,
                  ),
            ))
          Positioned(
            top: 0,
            left: 10,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    ((product.productAttributeModels!
                            .where(
                              (element) =>
                                  element.attributeControlType ==
                                      AttributeControlType.colorSquares &&
                                  element.values!.any(
                                    (av) => !av.colorSquaresRgb.isEmptyOrNull,
                                  ),
                            )
                            .fold(
                              0,
                              (v, e) =>
                                  v +
                                  e.values!
                                      .where(
                                        (av) =>
                                            !av.colorSquaresRgb.isEmptyOrNull,
                                      )
                                      .length,
                            )) *
                        20),
                maxHeight: 30,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children:
                      product.productAttributeModels!
                          .where(
                            (element) =>
                                element.attributeControlType ==
                                    AttributeControlType.colorSquares &&
                                element.values!.any(
                                  (av) => !av.colorSquaresRgb.isEmptyOrNull,
                                ),
                          )
                          .indexed
                          .expand((a) sync* {
                            for (var v in a.$2.values!) {
                              if (v.colorSquaresRgb.isEmptyOrNull) {
                                continue;
                              }
                              yield Positioned(
                                top: 0,
                                left: a.$2.values!.indexOf(v) * 10.0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                        '0xFF${v.colorSquaresRgb!.replaceAll('#', '')}',
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          })
                          .toList(),
                ),
              ),
            ),
          ),
      ],
    );
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

  Widget _buildProductDetails(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    final List<Widget> detailWidgets = [];

    if (product.brandName != null && product.brandName!.isNotEmpty) {
      detailWidgets.add(
        Text(
          product.brandName!,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode ? colorGrey300 : colorGrey700,
          ),
        ),
      );
    }

    if (product.reviewOverviewModel != null) {
      if (detailWidgets.isNotEmpty) {
        detailWidgets.add(
          Text(
            "|",
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: themeController.isDarkMode ? colorGrey300 : colorGrey700,
            ),
          ),
        );
      }
      detailWidgets.add(_buildRating(context, themeController, context.theme));
    }

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 5,
      children: detailWidgets,
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
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
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

  double? _getOldPriceValue() {
    if (product.productType != ProductType.auction) {
      return product.productPrice?.oldPriceValue;
    } else {
      return (product.productPrice?.highestBidValue ?? 0) > 0
          ? product.productPrice?.highestBidValue
          : product.productPrice?.startPriceValue;
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
      alignment: WrapAlignment.start,
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

  Widget _buildPriceAndRating(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (product.isFreeShipping ?? false)
          _buildShippingInfo(context, themeController, context.theme),
        Expanded(child: _buildPrice(context, themeController, context.theme)),
      ],
    );
  }

  Widget _buildProductTitle(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Başlık - satır yüksekliği azaltılmış text
        Text(
          product.name.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Maksimum 2 satır
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.0, // Satır yüksekliğini sıkıştır
          ),
        ),

        // Açıklama - varsa
        if (product.shortDescription != null && product.shortDescription!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              product.shortDescription.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // Tek satır
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: themeController.isDarkMode ? colorGrey300 : colorGrey700,
                height: 1.0, // Satır yüksekliğini sıkıştır
                fontSize: 10.0, // Yazı boyutunu küçült
              ),
            ),
          ),
      ],
    );
  }
}