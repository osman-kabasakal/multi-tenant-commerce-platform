import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/iyzico_payment_info_model/iyzico_payment_info_model.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/providers/iyzipay_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/view_models/installmentPrice.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/view_models/iyzipay_state_model.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/card_selection_dialog.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/installment_selection_dialog.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/new_card_dialog.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';
import 'package:store_user_app/domain/entities/model/card/card.dart'
    as iyzi_stored_card;
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class Iyzipay extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final PaymentInfoStepModel paymentInfoModel;

  const Iyzipay({
    super.key,
    required this.paymentInfoModel,
    required this.routeData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IyzipayClaudeStateModel();
}

class _IyzipayClaudeStateModel extends ConsumerState<Iyzipay> {
  late final IyzipayController _controller;

  @override
  void initState() {
    _controller = ref.read(
      iyzipayControllerProvider(widget.paymentInfoModel).notifier,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText: 'Ödeme Bilgileri',
      ),
      body: ref
          .watch(iyzipayControllerProvider(widget.paymentInfoModel))
          .when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data:
                (state) => Column(
                  children: [
                    // İyzico Logo
                    _buildIyzicoLogo(state.paymentInfo!),

                    // Ana İçerik
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, boxConstrait) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: boxConstrait.maxHeight - 50,
                                minWidth: boxConstrait.maxWidth,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Kart Bilgi Kutusu
                                  _buildCardInfoBox(state),

                                  const SizedBox(height: 8),

                                  // 3D Secure Seçeneği
                                  _build3DSecureOption(state),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Alt Bar - İleri Butonu
                    _buildBottomBar(state),
                  ],
                ),
            loading:
                () => const Skeleton(
                  isLoading: true,
                  skeleton: SkeletonListView(scrollable: true, itemCount: 50),
                  child: SizedBox.shrink(),
                ),
            error:
                (error, stack) =>
                    Center(child: AppErrorWidget(message: error.toString())),
          ),
    );
  }

  Widget _buildCardInfoBox(IyzipayStateModel? state) {
    if (state == null) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.selectedCardToken != null || state.newCardData != null)
          _buildCreditCard(state)
        else
          _buildAddCardButton(context, () => _showCardSelectionDialog(state)),
      ],
    );
  }

  Widget _build3DSecureOption(IyzipayStateModel? state) {
    if (state == null) return SizedBox.shrink();
    return SelectableCard(
      isSelected: state.useSecure3D,
      showSelectionCheckbox: false,
      margin: const EdgeInsets.all(0),
      onTap:
          () =>
              ref
                  .read(
                    iyzipayControllerProvider(widget.paymentInfoModel).notifier,
                  )
                  .toggleSecure3D(),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: state.useSecure3D ? colorPrimary : colorGrey500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3D Secure ile Öde',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            activeColor: colorPrimary,
            value: state.useSecure3D,
            onChanged:
                (value) =>
                    ref
                        .read(
                          iyzipayControllerProvider(
                            widget.paymentInfoModel,
                          ).notifier,
                        )
                        .toggleSecure3D(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(IyzipayStateModel? state) {
    if (state == null) return SizedBox.shrink();
    final bool isValid =
        state.selectedCardToken != null ||
        (state.newCardData != null && state.installmentPrice != null);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AppCommonButton(
        text: 'Devam Et',
        bgColor: isValid ? colorPrimary : Colors.grey,
        onPressed: isValid ? () => _handleContinue(state) : null,
      ),
    );
  }

  Future<void> _showCardSelectionDialog(IyzipayStateModel state) async {
    if ((state.paymentInfo?.storedUserCards!.isEmpty ?? true)) {
      var result = await context.router.pushWidget<Map<String, dynamic>>(
        NewCardDialog(
          storedCards: state.paymentInfo?.storedUserCards,
          creditCardFormData: state.paymentInfo?.creditCardFormData,
          paymentInfoStepModel: widget.paymentInfoModel,
        ),
      );
      if (result != null) {
        ref
            .read(iyzipayControllerProvider(widget.paymentInfoModel).notifier)
            .updateNewCardData(result);
      }
    } else {
      var result = await context.router.pushWidget<Map<String, dynamic>>(
        Dialog.fullscreen(
          child: CardSelectionDialog(
            storedCards: state.paymentInfo!.storedUserCards,
            creditCardFormData: state.paymentInfo!.creditCardFormData,
            paymentInfoStepModel: widget.paymentInfoModel,
            selectedCardToken: state.selectedCardToken,
          ),
        ),
      );

      if (result != null) {
        if (result['cardToken'] != null) {
          await ref
              .read(iyzipayControllerProvider(widget.paymentInfoModel).notifier)
              .updateSelectedCard(result['cardToken']);
        } else {
          ref
              .read(iyzipayControllerProvider(widget.paymentInfoModel).notifier)
              .updateNewCardData(result);
        }
      }
    }
  }

  Future<void> _showInstallmentSelectionDialog() async {
    final result = await showModalBottomSheet<InstallmentPrice>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder:
          (context) => InstallmentSelectionDialog(
            installmentDetail:
                ref
                    .read(iyzipayControllerProvider(widget.paymentInfoModel))
                    .requireValue
                    .installmentDetail!,
          ),
    );

    if (result != null) {
      ref
          .read(iyzipayControllerProvider(widget.paymentInfoModel).notifier)
          .updateInstallmentPrice(result);
    }
  }

  Future<void> _handleContinue(IyzipayStateModel state) async {
    var model = <String, dynamic>{};

    if (state.selectedCardToken != null) {
      model['cardToken'] = state.selectedCardToken;
    } else if (state.newCardData != null) {
      model.addAll(state.newCardData!);
    }

    model['installment'] = state.installmentPrice?.installmentNumber ?? 1;
    model['use3dPayment'] = state.useSecure3D;

    await ref
        .read(checkoutControllerProvider(widget.routeData).notifier)
        .execute(model.map((key, value) => MapEntry(key, value.toString())));
  }

  OptimizedCacheImage? cacheImage;
  Widget _buildIyzicoLogo(IyzicoPaymentInfoModel infoModel) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child:
              cacheImage ??
              (cacheImage = OptimizedCacheImage(
                fit: BoxFit.scaleDown,
                imageUrl: infoModel.iyzicoBrandImageUrl ?? '',
                sizeConfig: ImageSizeConfig(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 48,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildAddCardButton(BuildContext context, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [cardBoxShadow2],
          borderRadius: BorderRadius.circular(36),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.theme.primaryColor.withValues(alpha: 0.7),
              context.theme.primaryColor,
            ],
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add_card, color: Colors.white, size: 48),
              15.height,
              Text(
                "Kart Ekle",
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              5.height,
              Text(
                "Ödeme yapmak için kart bilgilerinizi ekleyin",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCard(IyzipayStateModel state) {
    final card =
        state.selectedCardToken != null
            ? state.paymentInfo!.storedUserCards!.firstWhere(
              (e) => e.cardToken == state.selectedCardToken,
            )
            : iyzi_stored_card.Card(
              cardAlias: state.newCardData!['cardAlias'],
              cardBankName: state.installmentDetail?.bankName,
              cardAssociation: state.installmentDetail?.cardAssociation,
              lastFourDigits: state.newCardData!['cardNumber']
                  ?.toString()
                  .substring(
                    state.newCardData!['cardNumber']!.toString().length - 5,
                  ),
            );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [cardBoxShadow2],
        borderRadius: BorderRadius.circular(36),
        image: DecorationImage(
          image: AssetImage(creditCardBg),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            context.theme.primaryColor,
            BlendMode.color,
          ),
        ),
      ),
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
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (card.cardBankName != null && card.cardFamily != null)
                        Text(
                          '${card.cardBankName ?? ''} (${card.cardFamily ?? ''})',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Text(
                        '●●●● ●●●● ●●●● ${card.lastFourDigits ?? ''}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCardTypeIcon(card.cardAssociation),
                _buildEditButton(() async => _showCardSelectionDialog(state)),
              ],
            ),
            30.height,
            if (state.installmentPrice != null) ...[
              Text(
                'Taksit (${state.installmentPrice?.totalPrice?.replaceAll('.', ',').formatNumberWithComma(seperator: '.') ?? '0,00'})',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(color: Colors.white, thickness: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${state.installmentPrice?.installmentNumber ?? '1'} X ${state.installmentPrice?.price?.replaceAll('.', ',').formatNumberWithComma(seperator: '.') ?? '0.00'}',
                    style: context.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildEditButton(
                    () async => await _showInstallmentSelectionDialog(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(VoidCallback onTap) {
    return IconButton(
      icon: SvgPicture.asset(
        edit1Icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.onSecondary,
          BlendMode.srcIn,
        ),
      ),
      onPressed: onTap,
      splashRadius: 24,
      color: colorWhite1,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
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
      child:
          iconPath.endsWith('.svg')
              ? SvgPicture.asset(iconPath, fit: BoxFit.contain)
              : Image.asset(iconPath, fit: BoxFit.contain),
    );
  }
}
