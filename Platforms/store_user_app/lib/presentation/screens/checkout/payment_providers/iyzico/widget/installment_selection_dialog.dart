import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/view_models/installmentPrice.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';

import '../view_models/installmentDetail.dart';

class InstallmentSelectionDialog extends HookConsumerWidget {
  final InstallmentDetail installmentDetail;

  const InstallmentSelectionDialog({
    super.key,
    required this.installmentDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInstallment = useState<InstallmentPrice>(
      installmentDetail.installmentPrices?.firstOrNull ?? InstallmentPrice(),
    );

    return BaseBottomSheet(
      title: 'Taksit Seçenekleri',
      maxWidthPercentage: 1,
      contentBuilder: (contentContext) => Column(
        children: installmentDetail.installmentPrices
                ?.map(
                  (installment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SelectableCard(
                      isSelected: selectedInstallment.value == installment,
                      showSelectionCheckbox: false,
                      onTap: () => selectedInstallment.value = installment,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Taksit Sayısı ve Aylık Tutar
                            AppSummaryRowWidget(
                              '${installment.installmentNumber} Taksit',
                              'Aylık ${installment.price!.formatNumberWithComma(seperator: ".")} TL',
                              isSmall: false,
                              isHighlight: true,
                              isPrice: true,
                            ),
                            const SizedBox(height: 8),
                            // Toplam Tutar
                            AppSummaryRowWidget(
                              'Toplam',
                              '${installment.totalPrice.formatNumberWithComma(seperator: ".")} TL',
                              isHighlight: false,
                              isSmall: true,
                              isPrice: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList() ??
            [],
      ),
      footerBuilder: (fContext) => Container(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Expanded(
              child: AppCommonButton(
                text: 'Vazgeç',
                height: 48,
                bgColor: getIt<ThemeController>().isDarkMode
                    ? borderDark
                    : primaryColor100,
                textColor: getIt<ThemeController>().isDarkMode
                    ? whiteColor
                    : colorPrimary,
                onPressed: () => context.router.maybePop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppCommonButton(
                text: 'Seç',
                height: 48,
                onPressed: () =>
                    context.router.maybePop(selectedInstallment.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
