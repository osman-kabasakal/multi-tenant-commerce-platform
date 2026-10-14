import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/entities/model/card/card.dart'
    as iyzi_card;
import 'package:store_user_app/domain/entities/utilities/field_definition/field_definition.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/new_card_dialog.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';

class CardSelectionDialog extends StatefulHookConsumerWidget {
  final List<iyzi_card.Card>? storedCards;
  final Map<String, FieldDefinition>? creditCardFormData;
  final PaymentInfoStepModel paymentInfoStepModel;
  final String? selectedCardToken;
  const CardSelectionDialog(
      {super.key,
      required this.storedCards,
      required this.creditCardFormData,
      required this.paymentInfoStepModel,
      this.selectedCardToken});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CardSelectionDialogState();
}

class _CardSelectionDialogState extends ConsumerState<CardSelectionDialog> {
  late final ValueNotifier<String?> selectedCardToken;

  @override
  void initState() {
    super.initState();
    selectedCardToken = ValueNotifier(widget.selectedCardToken);
  }

  @override
  void dispose() {
    selectedCardToken.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var newCardTask = useAsyncTask<bool>();
    return SafeArea(
      child: Scaffold(
        appBar: fdCommonAppBarWidget(context, titleText: 'Kart Seçimi'),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Orta Kısım - Kaydırılabilir İçerik
            Expanded(
              child: SingleChildScrollView(
                child: _buildStoredCardsList(context, widget.storedCards!),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: isSnapshotLoading(newCardTask.snapshot)
              ? null
              : () => newCardTask.pending.value = _showNewCardForm(),
          child: Icon(
            Icons.add,
            color: colorPrimary,
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
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
                      ? colorWhite1
                      : colorPrimary,
                  onPressed: () => context.router.maybePop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppCommonButton(
                  text: 'Seç',
                  height: 48,
                  onPressed: () => context.router.maybePop(
                      selectedCardToken.value != null
                          ? {'cardToken': selectedCardToken.value}
                          : null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showNewCardForm() async {
    var r = await context.router.pushWidget<Map<String, dynamic>>(
      NewCardDialog(
        storedCards: widget.storedCards,
        creditCardFormData: widget.creditCardFormData,
        paymentInfoStepModel: widget.paymentInfoStepModel,
      ),
    );

    if (r != null) {
      return await context.router.maybePop(r);
    }
    return false;
  }

  Widget _buildStoredCardsList(
      BuildContext context, List<iyzi_card.Card> cards) {
    return Column(
      spacing: 16,
      children: cards
          .map(
            (card) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildCreditCard(card)),
          )
          .toList(),
    );
  }

  Widget _buildCreditCard(iyzi_card.Card card) {
    return ValueListenableBuilder(
        valueListenable: selectedCardToken,
        builder: (context, state, child) {
          return InkWell(
            onTap: () => selectedCardToken.value = card.cardToken,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [cardBoxShadow2],
                  borderRadius: BorderRadius.circular(36),
                  image: DecorationImage(
                      image: AssetImage(creditCardBg),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          state == card.cardToken
                              ? context.theme.primaryColor
                              : grey,
                          BlendMode.color))),
              // height: 250,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.cardAlias ?? '',
                                style: context.theme.textTheme.titleLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${card.cardBankName ?? ''} (${card.cardFamily ?? ''})',
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '●●●● ●●●● ●●●● ${card.lastFourDigits ?? ''}',
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        _buildCardTypeIcon(card.cardAssociation),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildCardTypeIcon(String? cardAssociation) {
    String iconPath;
    if (cardAssociation?.toLowerCase() == 'VISA'.toLowerCase()) {
      iconPath = visaIcon;
    } else if (cardAssociation?.toLowerCase() == 'MASTER_CARD'.toLowerCase()) {
      iconPath = masterCardIcon;
    } else if (cardAssociation?.toLowerCase() == 'TROY'.toLowerCase()) {
      iconPath = troyCardIcon;
    } else if (cardAssociation?.toLowerCase() ==
        'AMERICAN_EXPRESS'.toLowerCase()) {
      iconPath = amexCardIcon;
    } else {
      iconPath = creditCardIcon;
    }

    return Container(
      width: 48,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
        ),
      ),
      child: iconPath.endsWith('.svg')
          ? SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
            )
          : Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
    );
  }
}
