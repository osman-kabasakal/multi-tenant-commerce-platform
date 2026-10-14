import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/dialog/dialog_helper.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_action_model/merchandise_return_action_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_reason_model/merchandise_return_reason_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/order_item_model/order_item_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';

class SelectReturnItemWidget extends StatefulHookConsumerWidget {
  final List<OrderItemModel> returnableItems;
  final List<MerchandiseReturnReasonModel> availableReturnReasons;
  final List<MerchandiseReturnActionModel> availableReturnActions;
  final FutureOr<void> Function(OrderItemModel model) onAddReturnItem;
  const SelectReturnItemWidget({
    super.key,
    required this.returnableItems,
    required this.availableReturnReasons,
    required this.availableReturnActions,
    required this.onAddReturnItem,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectReturnItemWidgetState();
}

class _SelectReturnItemWidgetState
    extends ConsumerState<SelectReturnItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Ürün Seçimi'),
      body: LayoutBuilder(builder: (context, boxConstraints) {
        return BaseBottomSheet(
          width: boxConstraints.maxWidth,
          height: boxConstraints.maxHeight,
          contentBuilder: (context) {
            return SizedBox(
              height: boxConstraints.maxHeight,
              width: boxConstraints.maxWidth,
              child: AppCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCardTitle.primary(
                        title: 'İade Edilebilir Ürünler', hasDivider: true),
                    8.height,
                    Expanded(
                      child: AppInifiniteScrollList(
                        key: const ValueKey('return_items'),
                        isLoading: false,
                        hasMore: false,
                        shrinkWrap: true,
                        onLoadMore: () => Future.value(),
                        itemCount: widget.returnableItems.length,
                        itemBuilder: (context, index) {
                          return SelectableCard(
                            onTap: null,
                            isSelected: false,
                            showSelectionCheckbox: false,
                            // margin: EdgeInsets.zero,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: AppCardTitle.warning(
                                            title: widget.returnableItems[index]
                                                    .productName ??
                                                '...',
                                            hasDivider: true),
                                      ),
                                      AppSummaryRowWidget(
                                          'Ürün Adedi',
                                          widget.returnableItems[index].quantity
                                                  ?.toString() ??
                                              '...'),
                                      AppSummaryRowWidget(
                                        'Ürün Fiyatı',
                                        '${widget.returnableItems[index].quantity?.toString() ?? ''} X ${widget.returnableItems[index].unitPrice?.toString() ?? '...'}',
                                        isPrice: true,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: Alignment.centerRight,
                                  icon: Icon(Icons.add_circle_outline,
                                      color: chocolate, size: 40),
                                  onPressed: () async {
                                    var returnItem =
                                        widget.returnableItems[index];
                                    var submitNotifier = ValueNotifier<
                                        Completer<
                                            ({
                                              bool isValid,
                                              OrderItemModel model
                                            })>?>(null);
                                    var returnReasons =
                                        await DialogHelper.showContentDialog(
                                            title: 'Ürüne Ait İade Bilgileri',
                                            contentBuilder:
                                                (returnInfoContext) {
                                              return HookConsumer(builder:
                                                  (returnInfoHookContext,
                                                      returnInfoHookRef, _) {
                                                var formModel = widget
                                                    .returnableItems[index];
                                                var returnInfoFormBuilder =
                                                    useMemoized(() {
                                                  var formBuilder = FormBuilder<
                                                          OrderItemModel>(
                                                      formModel);
                                                  formBuilder.addDropDownField(
                                                    'Quantity',
                                                    (model) => model.quantity,
                                                    (model) => List.generate(
                                                        returnItem.quantity ??
                                                            0,
                                                        (i) => i + 1),
                                                    (option) =>
                                                        option.toString(),
                                                    (option) => option,
                                                    label: 'Kusurlu Ürün Adedi',
                                                    isRequired: true,
                                                  );

                                                  formBuilder.addDropDownField(
                                                    'MerchandiseReturnReasonId',
                                                    (model) => returnItem
                                                        .merchandiseReturnReasonId,
                                                    (model) => widget
                                                        .availableReturnReasons,
                                                    (option) =>
                                                        option.name ?? '',
                                                    (option) => option.id!,
                                                    label: 'İade Nedeni',
                                                    isRequired: true,
                                                  );

                                                  formBuilder.addDropDownField(
                                                    'MerchandiseReturnActionId',
                                                    (model) => returnItem
                                                        .merchandiseReturnActionId,
                                                    (model) => widget
                                                        .availableReturnActions,
                                                    (option) =>
                                                        option.name ?? '',
                                                    (option) => option.id!,
                                                    label: 'İşlem Talebi',
                                                    isRequired: true,
                                                  );
                                                  return formBuilder;
                                                });

                                                var returnInfoFormController =
                                                    useMemoized(() {
                                                  return AppFormController<
                                                          MerchandiseReturnModel>(
                                                      returnInfoFormBuilder
                                                          .build());
                                                });

                                                useEffect(() {
                                                  submitNotifier
                                                      .addListener(() {
                                                    if (submitNotifier.value !=
                                                            null &&
                                                        !submitNotifier.value!
                                                            .isCompleted) {
                                                      var submitForm =
                                                          returnInfoFormController
                                                              .submit();
                                                      var currentFormModel =
                                                          returnInfoFormController
                                                              .getValues();
                                                      submitNotifier.value!
                                                          .complete((
                                                        isValid: submitForm,
                                                        model:
                                                            returnItem.copyWith(
                                                          quantity:
                                                              currentFormModel[
                                                                  'Quantity'],
                                                          merchandiseReturnReasonId:
                                                              currentFormModel[
                                                                  'MerchandiseReturnReasonId'],
                                                          merchandiseReturnActionId:
                                                              currentFormModel[
                                                                  'MerchandiseReturnActionId'],
                                                        ),
                                                      ));
                                                    }
                                                  });
                                                  return () {};
                                                });

                                                return RepaintBoundary(
                                                  child: GenericForm(
                                                    formBuilder:
                                                        returnInfoFormBuilder,
                                                    formController:
                                                        returnInfoFormController,
                                                  ),
                                                );
                                              });
                                            },
                                            footerBuilder:
                                                (returnInfoFormContext) {
                                              return AppBottomNavigation(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: AppCommonButton(
                                                        text: 'Vazgeç',
                                                        height: 48,
                                                        bgColor:
                                                            getIt<ThemeController>()
                                                                    .isDarkMode
                                                                ? borderDark
                                                                : primaryColor100,
                                                        textColor:
                                                            getIt<ThemeController>()
                                                                    .isDarkMode
                                                                ? whiteColor
                                                                : colorPrimary,
                                                        onPressed: () => context
                                                            .router
                                                            .maybePop(),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: AppCommonButton(
                                                          text: 'Ekle',
                                                          height: 48,
                                                          onPressed: () async {
                                                            submitNotifier
                                                                    .value =
                                                                Completer<
                                                                    ({
                                                                      bool isValid,
                                                                      OrderItemModel model
                                                                    })>();
                                                            var submitResponse =
                                                                await submitNotifier
                                                                    .value!
                                                                    .future;
                                                            if (submitResponse
                                                                .isValid) {
                                                              returnInfoFormContext
                                                                  .router
                                                                  .maybePop(
                                                                      submitResponse
                                                                          .model);
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });

                                    if (returnReasons != null &&
                                        returnReasons is OrderItemModel) {
                                      await widget
                                          .onAddReturnItem(returnReasons);
                                    }
                                  },
                                  splashRadius: 24,
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          footerBuilder: (context) {
            return AppBottomNavigation(
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
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
