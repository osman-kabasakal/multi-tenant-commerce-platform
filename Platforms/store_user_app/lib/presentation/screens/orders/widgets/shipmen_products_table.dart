import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/orders/shipment_details_model/shipment_item_model/shipment_item_model.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';

class ShipmentProductsTable extends ConsumerWidget {
  final List<ShipmentItemModel> shipmentItems;
  final bool showSku;

  const ShipmentProductsTable({
    super.key,
    required this.shipmentItems,
    this.showSku = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Ürünler',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorPrimary,
              fontFamily: 'Urbanist',
            ),
          ),

          const Gap(16),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? darkPrimary
                      : colorGrey100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (showSku)
                  Expanded(flex: 2, child: _buildHeaderCell(context, 'SKU')),
                Expanded(flex: 6, child: _buildHeaderCell(context, 'Ürün Adı')),
                Expanded(flex: 2, child: _buildHeaderCell(context, 'Miktar')),
              ],
            ),
          ),

          // Table Divider
          Divider(
            height: 1,
            thickness: 1,
            color:
                getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
          ),

          // Table Body
          ...shipmentItems.map((item) => _buildProductRow(context, item)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontFamily: 'Urbanist',
        color: getIt<ThemeController>().isDarkMode ? whiteColor : textColor,
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, ShipmentItemModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSku)
            Expanded(
              flex: 2,
              child: Text(
                item.sku ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (item.productId != null) {
                      context.router.navigatePath('/product/${item.productId}');
                    }
                  },
                  child: Text(
                    item.productName ?? '',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorPrimary,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                if (item.attributeInfo != null &&
                    item.attributeInfo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Html(
                      data: item.attributeInfo.toString(),
                      style: {
                        "body": Style(
                          fontSize: FontSize(12),
                          color:
                              getIt<ThemeController>().isDarkMode
                                  ? colorGrey300
                                  : colorGrey600,
                          fontWeight: FontWeight.normal,
                          fontFamily: context.textTheme.bodyMedium?.fontFamily,
                        ),
                      },
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      // style: context.textTheme.bodyMedium?.copyWith(
                      //   fontWeight: FontWeight.normal,
                      // ),
                    ),
                  ),
                if (item.rentalInfo != null && item.rentalInfo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.rentalInfo!.replaceAll(
                        RegExp(r'<[^>]*>'),
                        '',
                      ), // Remove HTML tags
                      style: context.textTheme.bodySmall?.copyWith(
                        color:
                            getIt<ThemeController>().isDarkMode
                                ? colorGrey300
                                : colorGrey600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.quantityShipped}',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
