import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class OrderProductListItem extends StatelessWidget {
  final ShoppingCartItemModel item;
  final VoidCallback? onTap;
  final bool showQuantityControls;

  const OrderProductListItem({
    super.key,
    required this.item,
    this.onTap,
    this.showQuantityControls = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(),
              const SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      item.productName ?? '',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontFamily,
                        color: isDarkMode ? colorWhite1 : textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // SKU (if available and should be shown)
                    if (item.sku != null && item.sku!.isNotEmpty)
                      Text(
                        'SKU: ${item.sku}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorGrey500,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    // Attributes (if available)
                    if (item.attributeInfo != null &&
                        item.attributeInfo!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Html(
                          data: item.attributeInfo.toString(),
                          style: {
                            "body": Style(
                              fontSize: FontSize(12),
                              color: isDarkMode ? colorGrey400 : colorGrey600,
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
                    // Price and Quantity Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity
                        Text(
                          '${quantity}x',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontFamily,
                            color: isDarkMode ? colorWhite1 : textColor,
                          ),
                        ),
                        // Unit Price
                        Flexible(
                          child: Text(
                            item.unitPrice ?? '',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: '',
                              color: isDarkMode ? colorWhite1 : textColor,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam:',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontFamily,
                            color: isDarkMode ? colorWhite1 : textColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            item.subTotal ?? '',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: '',
                              color: colorPrimary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    // Discount (if available)
                    if (item.discount != null && item.discount!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'İndirim:',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontFamily: AppTheme.fontFamily,
                                color: appRedColor,
                              ),
                            ),
                            Text(
                              item.discount!,
                              style: context.textTheme.bodySmall?.copyWith(
                                fontFamily: '',
                                color: appRedColor,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    // Warnings (if any)
                    if (item.warnings != null && item.warnings!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              item.warnings!
                                  .map(
                                    (warning) => Text(
                                      warning,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: appRedColor,
                                            fontFamily: AppTheme.fontFamily,
                                          ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    // Quantity controls if needed
                    if (showQuantityControls &&
                        (item.allowItemEditing ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildQuantityControls(context),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorGrey100,
      ),
      child:
          item.picture?.imageUrl != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OptimizedCacheImage(
                  imageUrl: item.picture!.imageUrl!,
                  fit: BoxFit.cover,
                  sizeConfig: const ImageSizeConfig(width: 80, height: 80),
                  placeholder: Container(
                    color: colorGrey100,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: Container(
                    color: colorGrey100,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: colorGrey400,
                    ),
                  ),
                ),
              )
              : const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: colorGrey400,
                ),
              ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQuantityButton(
          icon: SvgPicture.asset(
            minusDarkIcon,
            colorFilter: ColorFilter.mode(
              getIt<ThemeController>().isDarkMode ? colorWhite1 : colorGrey800,
              BlendMode.srcIn,
            ),
          ),
          onTap: () {
            if ((item.quantity ?? 0) > 1) {
              // Implement decrease quantity functionality
            }
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
            ),
          ),
          child: Text(
            '${item.quantity ?? 0}',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.fontFamily,
              color:
                  getIt<ThemeController>().isDarkMode ? colorWhite1 : textColor,
            ),
          ),
        ),
        _buildQuantityButton(
          icon: SvgPicture.asset(
            addDarkIcon,
            colorFilter: ColorFilter.mode(
              getIt<ThemeController>().isDarkMode ? colorWhite1 : colorGrey800,
              BlendMode.srcIn,
            ),
          ),
          onTap: () {
            // Implement increase quantity functionality
          },
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              getIt<ThemeController>().isDarkMode ? borderDark : colorGrey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon,
      ),
    );
  }

  int get quantity => item.quantity ?? 0;
}
