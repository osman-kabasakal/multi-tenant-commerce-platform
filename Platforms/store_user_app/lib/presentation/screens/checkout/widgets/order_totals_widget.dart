import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/shimmer.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class OrderTotalsWidget extends ConsumerWidget {
  const OrderTotalsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(shoppingCartUseCaseProvider).when(
          data: (cardState) {
            var orderTotal = cardState.orderTotal!;
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (orderTotal.subTotal != null)
                    AppSummaryRowWidget('Ara Toplam', orderTotal.subTotal!,
                        isPrice: true),
                  if (orderTotal.subTotalDiscount != null) ...[
                    const SizedBox(height: 8),
                    AppSummaryRowWidget('İndirim', orderTotal.subTotalDiscount!,
                        isPrice: true),
                  ],
                  if (orderTotal.shipping != null &&
                      orderTotal.requiresShipping == true) ...[
                    const SizedBox(height: 8),
                    AppSummaryRowWidget('Kargo', orderTotal.shipping!,
                        isHighlight: true, isPrice: true),
                    if (orderTotal.selectedShippingMethod != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          orderTotal.selectedShippingMethod!,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                  ],
                  if (orderTotal.giftVouchers?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Hediye Kartları',
                      style: context.textTheme.titleMedium,
                    ),
                    ...orderTotal.giftVouchers!.map((voucher) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                voucher.couponCode ?? '',
                                style: context.textTheme.titleSmall,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '-${voucher.amount ?? ''}',
                                    style: context.textTheme.titleSmall,
                                  ),
                                  if (orderTotal.isEditable == true) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () {
                                        if (voucher.id != null) {
                                          ref
                                              .read(shoppingCartUseCaseProvider
                                                  .notifier)
                                              .removeGiftVoucher(voucher.id!);
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                  if (orderTotal.displayTax == true &&
                      orderTotal.tax != null) ...[
                    const SizedBox(height: 8),
                    AppSummaryRowWidget('KDV', orderTotal.tax!, isPrice: true),
                    if (orderTotal.displayTaxRates == true)
                      ...orderTotal.taxRates
                              ?.map((rate) => Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: AppSummaryRowWidget(
                                        '${rate.rate} KDV', rate.value ?? '',
                                        isSmall: true, isPrice: true),
                                  ))
                              .toList() ??
                          [],
                  ],
                  if (orderTotal.redeemedLoyaltyPoints != null &&
                      orderTotal.redeemedLoyaltyPointsAmount != null) ...[
                    const SizedBox(height: 8),
                    AppSummaryRowWidget(
                      'Kullanılan Puan (${orderTotal.redeemedLoyaltyPoints})',
                      '-${orderTotal.redeemedLoyaltyPointsAmount}',
                    ),
                  ],
                  if (!(orderTotal.orderTotalDiscount?.isEmptyOrNull ??
                      true)) ...[
                    const SizedBox(height: 8),
                    AppSummaryRowWidget(
                        'Toplam indirim', orderTotal.orderTotalDiscount!,
                        isPrice: true, isHighlight: true),
                  ],
                  if (!(orderTotal.orderTotal.isEmptyOrNull)) ...[
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Genel Toplam',
                          style: context.textTheme.titleLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          orderTotal.orderTotal ?? '',
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: '',
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (orderTotal.willEarnLoyaltyPoints != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Bu siparişten ${orderTotal.willEarnLoyaltyPoints} puan kazanacaksınız',
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const ShimmerWidget(
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(lines: 5),
            ),
          ),
          error: (error, _) => AppErrorWidget(message: error.toString()),
        );
  }
}
