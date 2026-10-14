import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/billing/billing_step_address_picker_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_picker.dart';

class BillingStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final CheckoutBillingAddressModel billingAddressModel;
  const BillingStep({
    super.key,
    required this.routeData,
    required this.billingAddressModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillingStepState();
}

class _BillingStepState extends ConsumerState<BillingStep> {
  late final ValueNotifier<CheckoutBillingAddressModel> _adressModelState;
  @override
  void initState() {
    _adressModelState = ValueNotifier(widget.billingAddressModel);
    super.initState();
  }

  @override
  void dispose() {
    _adressModelState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var checkoutState = ref.watch(
      checkoutControllerProvider(
        widget.routeData,
      ).select((n) => n.requireValue),
    );

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText:
            checkoutState.currentStep == CheckoutStep.shippingAddress
                ? 'Teslimat Adresi Seçimi'
                : 'Fatura Adresi Seçimi',
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          8.height,
          ValueListenableBuilder(
            valueListenable: _adressModelState,
            builder: (context, value, child) {
              return AppCommonButton(
                bgColor:
                    value.billingAddressId != null ? colorPrimary : Colors.grey,
                text:
                    value.billingAddressId != null
                        ? 'Devam Et'
                        : 'Adres seçiniz!',
                onPressed:
                    value.billingAddressId != null
                        ? () async {
                          return ref
                              .read(
                                billingStepAddressPickerControllerProvider(
                                  widget.routeData,
                                ).notifier,
                              )
                              .selectAddress(
                                _adressModelState.value.billingAddressId,
                              );
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
    return LoadComponentWhenVisible(
      onVisible: () async {
        ref.invalidate(
          billingStepAddressPickerControllerProvider(widget.routeData),
        );
      },
      builder: (isVisible) {
        return ValueListenableBuilder(
          valueListenable: _adressModelState,
          builder: (context, state, child) {
            return Consumer(
              builder: (context, cnsRef, child) {
                return switch (cnsRef.watch(
                  billingStepAddressPickerControllerProvider(widget.routeData),
                )) {
                  AsyncValue() => AddressPicker(
                    selectedAddressId: state.billingAddressId,
                    selectable: true,
                    onAddressSelected: (model) async {
                      _adressModelState.value = _adressModelState.value
                          .copyWith(billingAddressId: model.id);
                    },
                    provider: billingStepAddressPickerControllerProvider(
                      widget.routeData,
                    ),
                    controller: cnsRef.read(
                      billingStepAddressPickerControllerProvider(
                        widget.routeData,
                      ).notifier,
                    ),
                  ),
                };
              },
            );
          },
        );
      },
    );
  }
}
