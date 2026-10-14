import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/utils/flutter_html/extensions/scrollable_table_html_extension.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_confirm_model/checkout_confirm_model.dart';
import 'package:store_user_app/domain/entities/models/legal_text_message_template_component_model/legal_text_categories/legal_text_categories.dart';
import 'package:store_user_app/domain/entities/models/legal_text_message_template_component_model/legal_text_message_template_component_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/order_product_list_item.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/order_totals_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_card_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';
import 'package:store_user_app/presentation/widgets/webview/widgets/auto_height_webview.dart';

class ConfirmStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final CheckoutConfirmModel confirmModel;
  const ConfirmStep({
    super.key,
    required this.routeData,
    required this.confirmModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmStepState();
}

class _ConfirmStepState extends ConsumerState<ConfirmStep> {
  late final ValueNotifier<Map<String, bool>> _legalTextsRequiredConfirms;
  late final ValueNotifier<bool> confirmTermsOfService;
  late final ValueNotifier<bool> _isLegalTextsLoading;
  late final ValueNotifier<bool> _confirmStepIsReady;

  @override
  void initState() {
    _legalTextsRequiredConfirms = ValueNotifier({});
    confirmTermsOfService = ValueNotifier(false);
    _isLegalTextsLoading = ValueNotifier(true);
    _confirmStepIsReady = ValueNotifier(false);

    Listenable.merge([
      _legalTextsRequiredConfirms,
      confirmTermsOfService,
      _isLegalTextsLoading,
    ]).addListener(() {
      var isReady =
          _legalTextsRequiredConfirms.value.values.every(
            (element) => element,
          ) &&
          confirmTermsOfService.value &&
          !_isLegalTextsLoading.value;
      _confirmStepIsReady.value = isReady;
    });
    super.initState();
  }

  @override
  void dispose() {
    _legalTextsRequiredConfirms.dispose();
    confirmTermsOfService.dispose();
    _isLegalTextsLoading.dispose();
    _confirmStepIsReady.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: fdCommonAppBarWidget(
          context,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          titleText: 'Sipariş Onayı',
        ),
        body: SingleChildScrollView(child: _buildOrderReview()),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
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
      child: ValueListenableBuilder(
        valueListenable: _confirmStepIsReady,
        builder: (context, value, child) {
          return AppCommonButton(
            text: 'Onayla',
            bgColor: value ? context.theme.primaryColor : Colors.grey,
            onPressed:
                value
                    ? () async {
                      await ref
                          .read(
                            checkoutControllerProvider(
                              widget.routeData,
                            ).notifier,
                          )
                          .execute(widget.confirmModel.toJson());
                    }
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildOrderReview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.confirmModel.warnings?.isNotEmpty ?? false)
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                AppCardTitle.error(
                  title: 'Sipariş hataları',
                  hasDivider: true,
                  iconData: Icons.error,
                ),
                if (widget.confirmModel.minOrderTotalWarning != null)
                  AppErrorWidget(
                    message: widget.confirmModel.minOrderTotalWarning!,
                    isDismissible: false,
                    onRetry: () {
                      context.router.popAndPush(CartRoute());
                    },
                  ),
                ...widget.confirmModel.warnings!.map(
                  (w) => AppErrorWidget(
                    message: w,
                    type: ErrorType.warning,
                    isDismissible: false,
                  ),
                ),
              ],
            ),
          ),
        AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCardTitle.active(
                title: 'Sipariş Ürünleri',
                hasDivider: true,
                iconData: Icons.shopping_bag,
              ),
              ...ref
                  .watch(
                    shoppingCartUseCaseProvider.select((x) => x.requireValue),
                  )
                  .cart!
                  .items!
                  .map(
                    (item) => OrderProductListItem(
                      item: item,
                      showQuantityControls: false,
                    ),
                  ),
            ],
          ),
        ),
        AppCard(
          child: Column(
            children: [
              AppCardTitle.active(
                title: 'Fatura Adresi',
                hasDivider: true,
                iconData: Icons.location_on,
              ),
              AddressCardWidget(
                address: widget.confirmModel.orderReviewData!.billingAddress!,
                isSelected: true,
                editable: false,
                selectable: false,
                onTap: () {},
              ),
            ],
          ),
        ),
        if (widget.confirmModel.orderReviewData!.isShippable!)
          AppCard(
            child: Column(
              children: [
                AppCardTitle.active(
                  title: 'Teslimat Adresi',
                  hasDivider: true,
                  iconData: Icons.home,
                ),
                AddressCardWidget(
                  address:
                      widget.confirmModel.orderReviewData!.shippingAddress!,
                  isSelected: true,
                  editable: false,
                  selectable: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        if (widget.confirmModel.orderReviewData!.selectedPickUpInStore!)
          AppCard(
            child: Column(
              children: [
                AppCardTitle.active(
                  title: 'Toplama adresi',
                  hasDivider: true,
                  iconData: Icons.store,
                ),
                AddressCardWidget(
                  address: widget.confirmModel.orderReviewData!.pickupAddress!,
                  isSelected: true,
                  editable: false,
                  selectable: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        if (widget.confirmModel.orderReviewData?.isShippable ?? false)
          AppCard(
            child: Column(
              children: [
                AppCardTitle.active(
                  title: 'Teslimat Yöntemi',
                  hasDivider: true,
                ),
                AppSummaryRowWidget(
                  widget.confirmModel.orderReviewData!.shippingMethod ??
                      'Teslimat Gerekmiyor',
                  '',
                  isHighlight: true,
                ),
              ],
            ),
          ),
        AppCard(
          child: Column(
            children: [
              AppCardTitle.active(title: 'Ödeme Yöntemi', hasDivider: true),
              AppSummaryRowWidget(
                widget.confirmModel.orderReviewData!.paymentMethod ??
                    'Ödeme Gerekmiyor',
                '',
                isHighlight: true,
              ),
            ],
          ),
        ),
        _buildLegalTextsSection(),
        AppCard(
          child: Column(
            children: [
              AppCardTitle.active(
                title: 'Hizmet Şartları Oanyı',
                hasDivider: true,
              ),
              ValueListenableBuilder(
                valueListenable: confirmTermsOfService,
                builder: (context, state, child) {
                  return CheckboxListTile(
                    dense: true,
                    tristate: true,
                    title: Text(
                      'Yaptığım alışveriş için sunulacak tüm hizmetleri onaylarım.',
                    ),
                    value: state,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (checked) {
                      confirmTermsOfService.value = checked ?? false;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(4), child: OrderTotalsWidget()),
      ],
    );
  }

  Future<List<LegalTextMessageTemplateComponentModel>> _getLegalTexts() async {
    _isLegalTextsLoading.value = true;
    var componentRepository = await getIt.getAsync<ComponentRepository>();
    var legalTexts = await componentRepository.getLegalTexts(
      LegalTextCategories.orderConfirmation.name,
    );
    return legalTexts ?? [];
  }

  Widget _buildLegalTextsSection() {
    return FutureBuilder(
      future: _getLegalTexts().whenComplete(
        () => _isLegalTextsLoading.value = false,
      ),
      builder: (ftContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children:
                (snapshot.data as List<LegalTextMessageTemplateComponentModel>)
                    .map((e) => _getLegalTextWebView(e))
                    .toList(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const SkeletonListView(itemCount: 2, scrollable: false);
        }

        if (snapshot.hasError) {
          return AppErrorWidget(
            message: snapshot.error.toString(),
            onRetry: () {
              _buildLegalTextsSection();
            },
          );
        }
        return SizedBox.shrink();
      },
    );
    // return HookBuilder(builder: (context) {
    //   var legalTextFuture =
    //       useAsyncTask<List<LegalTextMessageTemplateComponentModel>>();

    //   useEffect(() {
    //     legalTextFuture.pending.value = _getLegalTexts();
    //     return () {};
    //   }, [legalTextFuture]);

    //   if (legalTextFuture.snapshot.hasData) {
    //     _isLegalTextsLoading.value = false;
    //     return Column(
    //       children: legalTextFuture.snapshot.data!
    //           .map((e) => _getLegalTextWebView(e))
    //           .toList(),
    //     );
    //   }

    //   if (isSnapshotLoading(legalTextFuture.snapshot) ||
    //       legalTextFuture.snapshot.connectionState == ConnectionState.none) {
    //     _isLegalTextsLoading.value = true;
    //     return const SkeletonListView(
    //       itemCount: 2,
    //       scrollable: false,
    //     );
    //   }

    //   if (legalTextFuture.hasError) {
    //     _isLegalTextsLoading.value = false;
    //     return AppErrorWidget(
    //       message: legalTextFuture.snapshot.error.toString(),
    //       onRetry: () {
    //         legalTextFuture.pending.value = _getLegalTexts();
    //       },
    //     );
    //   }

    //   _isLegalTextsLoading.value = false;
    //   return SizedBox.shrink();
    // });
  }

  Widget _getLegalTextWebView(LegalTextMessageTemplateComponentModel e) {
    if (e.templateText == null) {
      return SizedBox.shrink();
    }
    if ((e.isRequired ?? false) &&
        !_legalTextsRequiredConfirms.value.containsKey(e.name!)) {
      _legalTextsRequiredConfirms.value[e.name!] = false;
    }

    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCardTitle.active(
            title: e.name ?? 'Hukuki Metin',
            hasDivider: true,
            iconData: Icons.gavel,
          ),
          const SizedBox.square(dimension: 16),
          ValueListenableBuilder(
            valueListenable: _legalTextsRequiredConfirms,
            builder: (context, state, child) {
              return CheckboxListTile(
                shape: RoundedRectangleBorder(side: BorderSide()),
                dense: true,
                tristate: true,
                title: Text('${e.name!} onaylıyorum.'),
                value: state[e.name!],
                activeColor: colorPrimary,
                onChanged: (checked) async {
                  if (checked ?? false) {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useSafeArea: true,
                      builder: (context) {
                        return BaseBottomSheet(
                          title: e.name!,
                          maxHeightPercentage: 1,
                          maxWidthPercentage: 1,
                          isHorizontalScrollable: true,
                          contentBuilder: (context) {
                            return Html(
                              shrinkWrap: true,
                              data: utf8.decode(base64.decode(e.templateText!)),
                              extensions: [ScrollableTableHtmlExtension()],
                            );
                          },
                          footerBuilder:
                              (context) => Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, -4),
                                    ),
                                  ],
                                ),
                                child: AppCommonButton(
                                  text: 'Kapat',
                                  onPressed: () {
                                    context.router.maybePop();
                                  },
                                ),
                              ),
                        );
                      },
                    );
                  }
                  _legalTextsRequiredConfirms.value = {
                    ..._legalTextsRequiredConfirms.value,
                    e.name!: checked ?? false,
                  };
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
