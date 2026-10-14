import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_payment_method_model/checkout_payment_method_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_payment_method_model/payment_method_model/payment_method_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/selectable_shipping_info_view_model.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/selectable_step_info.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';
import 'package:uuid/uuid.dart';

class PaymentMethodStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final CheckoutPaymentMethodModel paymentMethodModel;
  const PaymentMethodStep({
    super.key,
    required this.routeData,
    required this.paymentMethodModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentMethodStepState();
}

class _PaymentMethodStepState extends ConsumerState<PaymentMethodStep> {
  late final ValueNotifier<CheckoutPaymentMethodModel> _paymentMethodModelState;
  late final FormBuilder<bool> loyalityPointFormBuilder;
  late final AppFormController<bool> loyalityPointFormController;
  @override
  void initState() {
    super.initState();
    _paymentMethodModelState = ValueNotifier(widget.paymentMethodModel);
    loyalityPointFormBuilder = FormBuilder<bool>(
      widget.paymentMethodModel.useLoyaltyPoints ?? false,
    );
    loyalityPointFormBuilder.addSwitchField(
      'UseLoyaltyPoints',
      'Puanlarımla Öde',
      (m) => m,
      isRequired: false,
      configurations: {
        'description':
            '${widget.paymentMethodModel.loyaltyPointsBalance} (${widget.paymentMethodModel.loyaltyPointsAmount}) Puan',
      },
    );
    loyalityPointFormController = AppFormController<bool>(
      loyalityPointFormBuilder.build(),
      onFieldChange: (fieldName, value) {
        _paymentMethodModelState.value = _paymentMethodModelState.value
            .copyWith(useLoyaltyPoints: value);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _paymentMethodModelState.dispose();
    if (!(widget.paymentMethodModel.displayLoyaltyPoints ?? false)) {
      loyalityPointFormController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText: 'Ödeme yöntemi seçimi',
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          8.height,
          ValueListenableBuilder(
            valueListenable: _paymentMethodModelState,
            builder: (context, value, child) {
              return AppCommonButton(
                bgColor:
                    value.paymentMethod != null ? colorPrimary : Colors.grey,
                text:
                    value.paymentMethod != null
                        ? 'İleri'
                        : 'Ödeme yöntemi seçiniz!',
                onPressed:
                    value.paymentMethod != null
                        ? () async {
                          return ref
                              .watch(
                                checkoutControllerProvider(
                                  widget.routeData,
                                ).notifier,
                              )
                              .execute(_paymentMethodModelState.value.toJson());
                        }
                        : null,
              ).paddingOnly(left: 16, right: 16, bottom: 16);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(child: _buildPaymentMethods()),
        if (widget.paymentMethodModel.displayLoyaltyPoints ?? false)
          _buildLoyaltyPoints(),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return AppInifiniteScrollList(
      key: ValueKey(Uuid().v4()),
      isLoading: false,
      hasMore: false,
      onLoadMore: () => Future.value(),
      itemCount: widget.paymentMethodModel.paymentMethods?.length ?? 0,
      itemBuilder: (context, index) {
        var paymentMethod = widget.paymentMethodModel.paymentMethods![index];
        return _buildPaymentMethodItem(paymentMethod);
      },
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodModel paymentMethod) {
    return ValueListenableBuilder(
      valueListenable: _paymentMethodModelState,
      builder: (context, value, child) {
        return SelectableCard(
          isSelected:
              _paymentMethodModelState.value.paymentMethod ==
              paymentMethod.paymentMethodSystemName,
          onTap:
              () async => await _paymentMethodSelectionHandler(paymentMethod),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SelectableStepInfo(
                  viewModel: SelectableStepInfoViewModel(
                    name: paymentMethod.name,
                    description: paymentMethod.description,
                    fee: paymentMethod.fee,
                    userFields: paymentMethod.userFields,
                  ),
                ),
              ),
              8.width,
              if (paymentMethod.logoUrl != null)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: OptimizedCacheImage(
                    imageUrl: paymentMethod.logoUrl!,
                    isAbsolute: true,
                    sizeConfig: ImageSizeConfig(width: 40, height: 40),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  FutureOr<void> _paymentMethodSelectionHandler(
    PaymentMethodModel paymentMethod,
  ) async {
    _paymentMethodModelState.value = _paymentMethodModelState.value.copyWith(
      paymentMethod: paymentMethod.paymentMethodSystemName,
    );
  }

  Widget _buildLoyaltyPoints() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardTitle.active(
            svgIcon: loyalityPointsIcon,
            title: 'Kullanılabilir Puanlar',
            hasDivider: true,
          ),
          GenericForm(
            formBuilder: loyalityPointFormBuilder,
            formController: loyalityPointFormController,
          ),
        ],
      ),
    );
  }
}
