import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_method_model/checkout_shipping_method_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_method_model/shipping_method_model/shipping_method_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';
import 'package:uuid/uuid.dart';

class ShippingMethodStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final CheckoutShippingMethodModel shippingMethodModel;
  const ShippingMethodStep({
    super.key,
    required this.routeData,
    required this.shippingMethodModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShippingMethodStepState();
}

class _ShippingMethodStepState extends ConsumerState<ShippingMethodStep> {
  late final ValueNotifier<CheckoutShippingMethodModel>
  _shippingMethodModelState;

  @override
  void initState() {
    var defaultShippingMethod =
        widget.shippingMethodModel.shippingMethods
            ?.where((element) => element.selected ?? false)
            .firstOrNull;
    _shippingMethodModelState = ValueNotifier(
      widget.shippingMethodModel.copyWith(
        shippingOption:
            defaultShippingMethod != null
                ? '${defaultShippingMethod.name}:${defaultShippingMethod.shippingRateProviderSystemName}'
                : null,
        data: {},
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _shippingMethodModelState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText: 'Gönderi yöntemi seçimi',
      ),
      body: Column(
        children: [
          if(widget.shippingMethodModel.warnings!.isNotEmpty)...[
            ...widget.shippingMethodModel.warnings!.map((w)=>AppErrorWidget(message: w, type: ErrorType.warning,  isDismissible: false))
          ],
          Expanded(child: _buildContent()),
          8.height,
          ValueListenableBuilder(
            valueListenable: _shippingMethodModelState,
            builder: (context, value, child) {
              return AppCommonButton(
                bgColor:
                    value.shippingOption != null ? colorPrimary : Colors.grey,
                text:
                    value.shippingOption != null
                        ? 'İleri'
                        : 'Gönderi yöntemi seçiniz!',
                onPressed:
                    value.shippingOption != null
                        ? () async {
                          return ref
                              .watch(
                                checkoutControllerProvider(
                                  widget.routeData,
                                ).notifier,
                              )
                              .execute(
                                _shippingMethodModelState.value.toJson(),
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
    return AppInifiniteScrollList(
      key: ValueKey(Uuid().v4()),
      isLoading: false,
      hasMore: false,
      onLoadMore: () => Future.value(),
      itemCount: widget.shippingMethodModel.shippingMethods?.length ?? 0,
      itemBuilder: (context, index) {
        var shippingMethod = widget.shippingMethodModel.shippingMethods![index];
        return _buildShippingMethodItem(shippingMethod);
      },
    );
  }

  Widget _buildShippingMethodItem(ShippingMethodModel shippingMethod) {
    return ValueListenableBuilder(
      valueListenable: _shippingMethodModelState,
      builder: (context, state, child) {
        return SelectableCard(
          isSelected:
              '${shippingMethod.name}:${shippingMethod.shippingRateProviderSystemName}' ==
                  state.shippingOption ||
              ((shippingMethod.selected ?? false) &&
                  state.shippingOption.isEmptyOrNull),
          onTap: () async => await _selectShippingOption(shippingMethod),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping method adı
                Text(
                  shippingMethod.name ?? 'İsimsiz Kargo Yöntemi',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Açıklama varsa göster
                if (shippingMethod.description != null &&
                    shippingMethod.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      shippingMethod.description!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                // Ücret bilgisi
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Ücret: ${shippingMethod.fee ?? '0.00 TL'}',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: '',
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // UserFields varsa göster
                if (shippingMethod.userFields != null &&
                    shippingMethod.userFields!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          shippingMethod.userFields!.map((field) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${field.key}: ${field.value}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectShippingOption(ShippingMethodModel option) async {
    var shippingOptionName =
        '${option.name}:${option.shippingRateProviderSystemName}';

    var newState = _shippingMethodModelState.value.copyWith(
      data: null,
      shippingOption: shippingOptionName,
    );

    var checkoutRepository = await getIt.getAsync<CheckoutRepository>();

    var dio = await getIt.getAsync<Dio>();

    var shippingDataUrl = await checkoutRepository
        .getCheckoutGetShippingFormPartialView(shippingOptionName);
    if (shippingDataUrl != null &&
        shippingDataUrl.isRedirectResponse &&
        shippingDataUrl.redirect!.redirectUri != null) {
      var shippingOptionData = await dio.getUri(
        shippingDataUrl.redirect!.redirectUri!,
      );
      if (shippingOptionData.statusCode == 200 &&
          shippingOptionData.data != null &&
          shippingOptionData.data is Map<String, String>) {
        _shippingMethodModelState.value = newState.copyWith(
          data: (shippingOptionData.data as Map<String, String>),
        );
      } else {
        _shippingMethodModelState.value = newState.copyWith(data: {});
      }
    } else {
      _shippingMethodModelState.value = newState.copyWith(data: {});
    }
  }
}
