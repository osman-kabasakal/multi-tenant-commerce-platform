import 'package:auto_route/auto_route.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: boxShadow.withValues(alpha: 0.08),
      semanticContainer: false,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: themeController.isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SeparatedRow(
                  children: [
                    SvgPicture.asset(
                      orderIcon,
                      height: context.textTheme.titleMedium?.fontSize ?? 12,
                      colorFilter: ColorFilter.mode(
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : colorPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      '#${order.orderCode}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: primaryColor200,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ],
                  separatorBuilder: () => const Gap(8),
                ),
                _buildStatusChip(context, order.orderStatus ?? ''),
              ],
            ),
            const SizedBox(height: 8),

            Divider(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? darkPrimary
                      : borderColor,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 8),

            _buildInfoRow(
              context,
              'Sipariş Tarihi',
              DateFormat('dd MM yyyy, HH:mm').format(order.createdOn!),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Ödeme Durumu', order.paymentStatus ?? ''),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Toplam', order.orderTotal ?? '', true),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Gönderi Durumu',
              order.shippingStatus ?? '',
            ),
            const SizedBox(height: 8),

            Divider(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 8),
            _buildActionRow(context, order),
            // if (order.isMerchandiseReturnAllowed ?? false) ...[
            //   const SizedBox(height: 16),
            //   SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // Handle return
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: colorPrimary,
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.symmetric(vertical: 12),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //       child: const Text('Request Return'),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: context.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontFamily: AppTheme.fontFamily,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, [
    bool priceValue = false,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color:
                getIt<ThemeController>().isDarkMode
                    ? colorGrey300
                    : colorGrey700,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: priceValue ? '' : AppTheme.fontFamily,
            color:
                priceValue
                    ? (getIt<ThemeController>().isDarkMode
                        ? primaryColor100
                        : colorPrimary)
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, OrderDetailsModel order) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      runAlignment: WrapAlignment.spaceBetween,
      children: [
        AppCommonButton(
          textStyle: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
          onPressed: () {
            context.router.pushPath(
              AppPaths.orderDetails(orderId: order.id ?? ''),
            );
          },
          text: 'Detay',
          height: MediaQuery.of(context).size.width * 0.12,
        ),
        if (order.isMerchandiseReturnAllowed ?? false)
          AppCommonButton(
            onPressed: () {
              context.router.pushPath(
                AppPaths.merchandiseReturn(orderId: order.id ?? ''),
              );
            },
            text: 'İade İsteği',
            height: MediaQuery.of(context).size.width * 0.12,
            borderColor: colorPrimary,
            bgColor:
                getIt<ThemeController>().isDarkMode ? cardDark : Colors.white,
            textColor: colorPrimary,
            textStyle: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorPrimary,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
      ],
    );
  }
}
