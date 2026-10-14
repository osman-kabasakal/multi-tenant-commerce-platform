import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/presentation/screens/profile/providers/customer_merchandise_return_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/shimmer.dart';

import '../../../../core/constants/colors.dart' as app_colors;
import '../../../../core/constants/images.dart';
import '../../../../core/services/theme/theme_controller.dart';

@RoutePage()
class CustomerMerchandiseReturnScreen extends HookConsumerWidget {
  const CustomerMerchandiseReturnScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'İadelerim'),
      body: ref.watch(customerMerchandiseReturnControllerProvider).when(
            data: (data) {
              final items = data.items;

              if (items == null || items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment_return_outlined,
                        size: 64,
                        color: themeController.isDarkMode
                            ? app_colors.colorGrey700
                            : app_colors.colorGrey400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz iade işleminiz bulunmamaktadır',
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? app_colors.colorGrey300
                              : app_colors.colorGrey800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return AppInifiniteScrollList(
                key: const ValueKey('CustomerMerchandiseReturns_list'),
                isLoading: false,
                hasMore: false,
                onLoadMore: () => Future.value(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  // Get status color based on merchandise return status
                  Color statusColor =
                      _getStatusColor(item.merchandiseReturnStatus);

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'İade No: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: themeController.isDarkMode
                                          ? app_colors.colorGrey300
                                          : app_colors.colorGrey800,
                                    ),
                                  ),
                                  Text(
                                    '#${item.returnNumber}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : app_colors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: statusColor, width: 1),
                                ),
                                child: Text(
                                  item.merchandiseReturnStatus ?? 'Belirsiz',
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    calendarIcon,
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                      app_colors.colorGrey500,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (item.createdOn ?? DateTime.now())
                                        .formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: app_colors.colorGrey600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 16,
                                    color: app_colors.colorGrey500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.productsCount} Ürün',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: app_colors.colorGrey600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                item.returnTotal ?? '0.00 ₺',
                                style: TextStyle(
                                  fontFamily: '',
                                  fontWeight: FontWeight.bold,
                                  color: themeController.isDarkMode
                                      ? app_colors.colorGrey300
                                      : app_colors.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.router.push(MerchandiseReturnDetailsRoute(
                                  merchandiseReturnId: item.id ?? ''));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: app_colors.colorPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            child: const Text('Detayları Görüntüle'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (err, stack) => AppErrorWidget(
              message: err.toString(),
              type: ErrorType.error,
              onRetry: () =>
                  ref.refresh(customerMerchandiseReturnControllerProvider),
            ),
            loading: () => _buildLoadingWidget(),
          ),
    );
  }

  Widget _buildLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShimmerWidget(
        child: Column(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'pending':
      case 'beklemede':
        return Colors.orange;
      case 'approved':
      case 'onaylandı':
        return Colors.green;
      case 'rejected':
      case 'reddedildi':
        return Colors.red;
      case 'completed':
      case 'tamamlandı':
        return app_colors.colorPrimary;
      case 'cancelled':
      case 'iptal edildi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
