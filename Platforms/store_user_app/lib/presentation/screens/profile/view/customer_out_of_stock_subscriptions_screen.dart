import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/app/widgets/app_widget.dart';
import '../../../widgets/app/widgets/app_error_widget.dart';
import '../providers/customer_out_of_stock_subscriptions_controller.dart';
import '../../../widgets/layout/view/app_inifinite_scroll_list.dart';
import '../../../widgets/buttons/view/app_common_button.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/theme/theme_controller.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../domain/entities/models/catalog/customer_out_of_stock_subscriptions_model/out_of_stock_subscription_model/out_of_stock_subscription_model.dart';

@RoutePage()
class CustomerOutOfStockSubscriptionsScreen extends HookConsumerWidget {
  const CustomerOutOfStockSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();
    final selectedItems = useState<List<String>>([]);
    final isSelectAllChecked = useState<bool>(false);

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Stok Aboneliklerim',
      ),
      body: ref.watch(customerOutOfStockSubscriptionsControllerProvider).when(
            data: (model) {
              if (model.subscriptions?.isEmpty ?? true) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 64,
                          color: themeController.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Stok takip aboneliğiniz bulunmamaktadır.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Stok bildirimi almak istediğiniz ürünler aşağıdadır. Listeden çıkarmak istediğiniz ürünleri seçerek silebilirsiniz.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelectAllChecked.value,
                          onChanged: (value) {
                            isSelectAllChecked.value = value ?? false;
                            if (value == true) {
                              selectedItems.value = model.subscriptions!
                                  .map((item) => item.id!)
                                  .toList();
                            } else {
                              selectedItems.value = [];
                            }
                          },
                          activeColor: colorPrimary,
                        ),
                        Text(
                          'Tümünü Seç',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        if (selectedItems.value.isNotEmpty)
                          TextButton.icon(
                            onPressed: () async {
                              if (selectedItems.value.isEmpty) return;

                              // İlgili abonelikleri silme işlemi
                              await ref
                                  .read(
                                      customerOutOfStockSubscriptionsControllerProvider
                                          .notifier)
                                  .deleteSubscriptions(selectedItems.value);

                              selectedItems.value = [];
                              isSelectAllChecked.value = false;
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: appRedColor,
                            ),
                            label: Text(
                              'Seçilenleri Sil',
                              style: TextStyle(color: appRedColor),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: AppInifiniteScrollList(
                      key:
                          const ValueKey('CustomerOutOfStockSubscription_list'),
                      isLoading: false,
                      hasMore: model.pagerModel?.hasNextPage ?? false,
                      onLoadMore: ref
                          .read(
                              customerOutOfStockSubscriptionsControllerProvider
                                  .notifier)
                          .loadMore,
                      refresh: ref
                          .read(
                              customerOutOfStockSubscriptionsControllerProvider
                                  .notifier)
                          .refresh,
                      itemCount: model.subscriptions!.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemBuilder: (context, index) {
                        final subscription = model.subscriptions![index];
                        return SubscriptionItem(
                          subscription: subscription,
                          isSelected:
                              selectedItems.value.contains(subscription.id),
                          onToggleSelect: (selected) {
                            if (selected) {
                              selectedItems.value = [
                                ...selectedItems.value,
                                subscription.id!
                              ];
                            } else {
                              selectedItems.value = selectedItems.value
                                  .where((id) => id != subscription.id)
                                  .toList();
                            }

                            // Tüm öğeler seçili mi kontrolü
                            isSelectAllChecked.value =
                                selectedItems.value.length ==
                                    model.subscriptions!.length;
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => AppErrorWidget(
              message: error.toString(),
              type: ErrorType.error,
              onRetry: () => ref
                  .read(customerOutOfStockSubscriptionsControllerProvider
                      .notifier)
                  .refresh(),
            ),
          ),
      bottomNavigationBar: ref
          .watch(customerOutOfStockSubscriptionsControllerProvider)
          .maybeWhen(
            data: (model) {
              if (selectedItems.value.isEmpty || model.subscriptions!.isEmpty) {
                return null;
              }

              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppCommonButton(
                  text: 'Seçili Abonelikleri Sil',
                  onPressed: () async {
                    if (selectedItems.value.isEmpty) return;

                    // İlgili abonelikleri silme işlemi
                    await ref
                        .read(customerOutOfStockSubscriptionsControllerProvider
                            .notifier)
                        .deleteSubscriptions(selectedItems.value);

                    selectedItems.value = [];
                    isSelectAllChecked.value = false;
                  },
                  bgColor: appRedColor,
                ),
              );
            },
            orElse: () => null,
          ),
    );
  }
}

class SubscriptionItem extends StatelessWidget {
  final OutOfStockSubscriptionModel subscription;
  final bool isSelected;
  final Function(bool) onToggleSelect;

  const SubscriptionItem({
    super.key,
    required this.subscription,
    required this.isSelected,
    required this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (value) => onToggleSelect(value ?? false),
              activeColor: colorPrimary,
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      subscription.productName ?? 'Ürün Adı',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : textColor,
                          ),
                    ),

                    // Attribute description if available
                    if (subscription.attributeDescription != null &&
                        subscription.attributeDescription!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          subscription.attributeDescription!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeController.isDarkMode
                                        ? colorGrey300
                                        : colorGrey600,
                                  ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // View Product Button
                    InkWell(
                      onTap: () {
                        // Navigate to product detail
                        if (subscription.seName != null) {
                          context.router.navigateNamed(
                              '/product/${subscription.productId}');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: colorPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ürünü Görüntüle',
                            style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
