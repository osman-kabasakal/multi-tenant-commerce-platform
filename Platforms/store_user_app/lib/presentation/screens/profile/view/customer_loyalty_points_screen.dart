import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/services/theme/theme_controller.dart';
import '../../../../domain/entities/models/orders/customer_loyalty_points_model/customer_loyalty_points_model.dart';
import '../../../../presentation/widgets/app/widgets/app_error_widget.dart';
import '../../../widgets/app/widgets/app_widget.dart';
import '../providers/customer_loyalty_points_controller.dart';

@RoutePage()
class CustomerLoyaltyPointsScreen extends HookConsumerWidget {
  const CustomerLoyaltyPointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Sadakat Puanlarım'),
      body: ref.watch(customerLoyaltyPointsControllerProvider).when(
            data: (loyaltyPoints) {
              if (loyaltyPoints.loyaltyPoints == null ||
                  loyaltyPoints.loyaltyPoints!.isEmpty) {
                return _buildEmptyState(context);
              }

              return _buildLoyaltyPointsContent(
                  context, loyaltyPoints, themeController);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: AppErrorWidget(
                message: 'Sadakat puanlarınız yüklenirken bir hata oluştu.',
                type: ErrorType.error,
                onRetry: () {
                  ref
                      .watch(customerLoyaltyPointsControllerProvider.notifier)
                      .refresh();
                },
              ),
            ),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_border_rounded,
            size: 64,
            color: colorGrey500,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz hiç sadakat puanı geçmişiniz bulunmuyor.',
            style: context.textTheme.titleMedium?.copyWith(
              color: colorGrey500,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyPointsContent(
      BuildContext context,
      CustomerLoyaltyPointsModel loyaltyPoints,
      ThemeController themeController) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Balance Card
          _buildCurrentBalanceCard(context, loyaltyPoints, themeController),

          const SizedBox(height: 24),

          // Loyalty Points History Title
          Text(
            'Puan Geçmişi',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // History Table
          _buildLoyaltyPointsHistoryTable(
              context, loyaltyPoints, themeController),
        ],
      ),
    );
  }

  Widget _buildCurrentBalanceCard(BuildContext context,
      CustomerLoyaltyPointsModel model, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current balance card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? colorPrimary.withOpacity(0.2)
                : primaryColor100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorPrimary,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: colorPrimary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Mevcut Puan Bakiyeniz',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '${model.loyaltyPointsBalance}',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          themeController.isDarkMode ? Colors.white : textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Puan',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: themeController.isDarkMode
                          ? Colors.white70
                          : textColor.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    model.loyaltyPointsAmount ?? '',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      fontFamily: '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Minimum balance card (if applicable)
        if (model.minimumLoyaltyPointsBalance != null &&
            model.minimumLoyaltyPointsBalance! > 0)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? Colors.red.withOpacity(0.2)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Minimum puan bakiyesi: ${model.minimumLoyaltyPointsBalance} puan (${model.minimumLoyaltyPointsAmount})',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLoyaltyPointsHistoryTable(BuildContext context,
      CustomerLoyaltyPointsModel model, ThemeController themeController) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.isDarkMode ? borderDark : borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              themeController.isDarkMode ? darkPrimary : colorGrey100,
            ),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 80,
            columnSpacing: 24,
            horizontalMargin: 16,
            columns: [
              DataColumn(
                label: Text(
                  'Tarih',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeController.isDarkMode ? Colors.white : textColor,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Puanlar',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeController.isDarkMode ? Colors.white : textColor,
                  ),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'Bakiye',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeController.isDarkMode ? Colors.white : textColor,
                  ),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'Açıklama',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeController.isDarkMode ? Colors.white : textColor,
                  ),
                ),
              ),
            ],
            rows: model.loyaltyPoints!.map((point) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 100,
                      child: Text(
                        point.createdOn != null
                            ? dateFormat.format(point.createdOn!)
                            : '-',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: themeController.isDarkMode
                              ? Colors.white70
                              : textColor,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${point.points ?? 0}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: (point.points ?? 0) > 0
                            ? Colors.green
                            : (point.points ?? 0) < 0
                                ? Colors.red
                                : themeController.isDarkMode
                                    ? Colors.white70
                                    : textColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${point.pointsBalance ?? 0}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : textColor,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 200,
                      child: Text(
                        point.message ?? '-',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: themeController.isDarkMode
                              ? Colors.white70
                              : textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
