import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/shipping/shipping_step_address_picker_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_picker.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/pickup_point_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/location/view_models/adress_detail.dart';

class ShippingStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final CheckoutShippingAddressModel shippingAddressModel;
  const ShippingStep({
    super.key,
    required this.routeData,
    required this.shippingAddressModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShippingStepState();
}

class _ShippingStepState extends ConsumerState<ShippingStep>
    with TickerProviderStateMixin {
  late final CheckoutController _checkoutNotifier;
  AddressDetail? _geoReverseAddress;
  bool newAddress = false;
  String? selectedAddressId;
  late final ValueNotifier<CheckoutShippingAddressModel> _adressModelState;
  late final TabController _tabController;

  @override
  void initState() {
    _checkoutNotifier = ref.read(
      checkoutControllerProvider(widget.routeData).notifier,
    );

    _adressModelState = ValueNotifier(widget.shippingAddressModel);
    int tabLength = 0;
    if (!(_adressModelState.value.pickUpInStoreOnly ?? false)) tabLength++;
    if ((_adressModelState.value.allowPickUpInStore ?? false) &&
        (_adressModelState.value.pickupPoints?.isNotEmpty ?? false)) {
      tabLength++;
    }
    _tabController = TabController(length: tabLength, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _adressModelState.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var checkoutState = ref.watch(
      checkoutControllerProvider(
        widget.routeData,
      ).select((n) => n.requireValue),
    );

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,

      body: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TabBar(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    getIt<ThemeController>().isDarkMode
                        ? colorGrey700
                        : colorGrey500,
              ),
              labelColor: colorPrimary,
              indicator: const UnderlineTabIndicator(
                // Use UnderlineTabIndicator
                borderSide: BorderSide(
                  width: 4.0,
                  color: colorPrimary,
                ), // Customize the indicator
              ),
              tabs: [
                if (!(_adressModelState.value.pickUpInStoreOnly ?? false))
                  Tab(text: 'Adresleriniz'),
                if ((_adressModelState.value.allowPickUpInStore ?? false) &&
                    (_adressModelState.value.pickupPoints?.isNotEmpty ?? false))
                  Tab(text: 'Teslim alma noktaları'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
              height: 1,
              thickness: 1,
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                if (!(_adressModelState.value.pickUpInStoreOnly ?? false))
                  _adressSelectionTab(),
                if ((_adressModelState.value.allowPickUpInStore ?? false) &&
                    (_adressModelState.value.pickupPoints?.isNotEmpty ?? false))
                  _pickPointSelectionTab(),
              ],
            ),
          ),
        ],
      ),
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText:
            checkoutState.currentStep == CheckoutStep.shippingAddress
                ? 'Teslimat Adresi Seçimi'
                : 'Fatura Adresi Seçimi',
      ),
    );
  }

  Column _adressSelectionTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _buildContent()),
        8.height,
        ValueListenableBuilder(
          valueListenable: _adressModelState,
          builder: (context, value, child) {
            return AppCommonButton(
              bgColor:
                  value.shippingAddressId != null ? colorPrimary : Colors.grey,
              text:
                  value.shippingAddressId != null ? 'İleri' : 'Adres seçiniz!',
              onPressed:
                  value.shippingAddressId != null
                      ? () async {
                        return ref
                            .read(
                              shippingStepAddressPickerControllerProvider(
                                widget.routeData,
                              ).notifier,
                            )
                            .selectAddress(
                              _adressModelState.value.shippingAddressId,
                            );
                      }
                      : null,
            ).paddingOnly(left: 16, right: 16, bottom: 16);
          },
        ),
      ],
    );
  }

  Column _pickPointSelectionTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: AppInifiniteScrollList(
            key: Key(Uuid().v4()),
            isLoading: false,
            hasMore: false,
            itemCount: _adressModelState.value.pickupPoints!.length,
            onLoadMore: () => Future.value(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var pickPoint = _adressModelState.value.pickupPoints![index];
              return ValueListenableBuilder(
                valueListenable: _adressModelState,
                builder: (context, value, child) {
                  return PickupPointWidget(
                    pickupPoint: pickPoint,
                    isSelected:
                        _adressModelState.value.pickupPointId == pickPoint.id,
                    onTap: () {
                      _adressModelState.value = _adressModelState.value
                          .copyWith(
                            shippingAddressId: null,
                            pickUpInStore: true,
                            pickupPointId: pickPoint.id,
                          );
                    },
                  ).paddingOnly(left: 16, right: 16, bottom: 8);
                },
              );
            },
          ),
        ),
        8.height,
        ValueListenableBuilder(
          valueListenable: _adressModelState,
          builder: (context, value, child) {
            return AppCommonButton(
              bgColor: value.pickupPointId != null ? colorPrimary : Colors.grey,
              text:
                  value.pickupPointId != null
                      ? 'Devam Et'
                      : 'Toplama noktası seçiniz!',
              onPressed:
                  value.pickupPointId != null
                      ? () async {
                        return ref
                            .read(
                              shippingStepAddressPickerControllerProvider(
                                widget.routeData,
                              ).notifier,
                            )
                            .selectPickPoint(
                              _adressModelState.value.pickupPointId!,
                            );
                      }
                      : null,
            ).paddingOnly(left: 16, right: 16, bottom: 16);
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return LoadComponentWhenVisible(
      onVisible: () async {
        ref.invalidate(
          shippingStepAddressPickerControllerProvider(widget.routeData),
        );
      },
      builder: (isVisible) {
        return ValueListenableBuilder(
          valueListenable: _adressModelState,
          builder: (context, state, child) {
            return Consumer(
              builder: (context, cnsRef, child) {
                return switch (cnsRef.watch(
                  shippingStepAddressPickerControllerProvider(widget.routeData),
                )) {
                  AsyncValue(:final isLoading, :final value) => AddressPicker(
                    selectedAddressId: state.shippingAddressId,
                    selectable: true,
                    onAddressSelected: (model) async {
                      _adressModelState.value = _adressModelState.value
                          .copyWith(
                            shippingAddressId: model.id,
                            pickUpInStore: true,
                            pickupPointId: null,
                          );
                    },
                    provider: shippingStepAddressPickerControllerProvider(
                      widget.routeData,
                    ),
                    controller: cnsRef.read(
                      shippingStepAddressPickerControllerProvider(
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
