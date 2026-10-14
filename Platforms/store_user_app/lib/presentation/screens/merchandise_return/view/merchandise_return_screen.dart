import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/presentation/form_builders/address_model_form_builder.dart';
import 'package:store_user_app/presentation/screens/merchandise_return/providers/merchandise_return_controller.dart';
import 'package:store_user_app/presentation/screens/merchandise_return/providers/merchandise_return_pickup_adress_controller.dart';
import 'package:store_user_app/presentation/screens/merchandise_return/widgets/select_return_item_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_picker.dart';

@RoutePage()
class MerchandiseReturnScreen extends StatefulHookConsumerWidget {
  final String orderId;

  const MerchandiseReturnScreen({
    super.key,
    @PathParam('orderId') required this.orderId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseReturnScreenState();
}

class _MerchandiseReturnScreenState
    extends ConsumerState<MerchandiseReturnScreen> {
  // Helper method to get step title by index
  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return 'Ürün Seçimi';
      case 1:
        return 'Açıklama';
      case 2:
        return 'Alınacak Adres';
      case 3:
        return 'Alınacak Tarih';
      default:
        return 'Adım ${index + 1}';
    }
  }

  // Helper method to build step content
  Widget _buildStepContent(int currentStep, BoxConstraints boxCons) {
    switch (currentStep) {
      case 0:
        return SizedBox(
          width: boxCons.maxWidth,
          height: boxCons.maxHeight / 1.4,
          child: _returnItemsStep(),
        );
      case 1:
        return SizedBox(
          width: boxCons.maxWidth,
          height: boxCons.maxHeight / 1.4,
          child: AppCard(child: _returnRequestComments()),
        );
      case 2:
        return SizedBox(
          width: boxCons.maxWidth,
          height: boxCons.maxHeight / 1.4,
          child: AppCard(child: _pickUpAddressStep()),
        );
      case 3:
        return SizedBox(
          width: boxCons.maxWidth,
          height: boxCons.maxHeight / 1.4,
          child: AppCard(child: _pickUpAddressDate()),
        );
      default:
        return SizedBox.shrink();
    }
  }

  late final stepValidators = <int, bool Function()>{
    0:
        () =>
            ref
                .read(
                  merchandiseReturnControllerProvider(
                    widget.orderId,
                  ).select((s) => s.valueOrNull),
                )
                ?.returnItems
                .isNotEmpty ??
            false,
    1: () => true,
    2:
        () =>
            (ref
                    .read(
                      merchandiseReturnControllerProvider(
                        widget.orderId,
                      ).select((s) => s.valueOrNull),
                    )
                    ?.merchandiseReturnModel
                    .showPickupAddress ??
                false) &&
            ((ref
                        .read(
                          merchandiseReturnControllerProvider(
                            widget.orderId,
                          ).select((s) => s.valueOrNull),
                        )
                        ?.merchandiseReturnModel
                        .pickupAddressId !=
                    null) ||
                _validateNewAddress(
                  (ref
                          .read(
                            merchandiseReturnControllerProvider(
                              widget.orderId,
                            ).select((s) => s.valueOrNull),
                          )
                          ?.merchandiseReturnModel
                          .merchandiseReturnNewAddress ??
                      AddressModel()),
                )),
    3:
        () =>
            !(ref
                    .read(
                      merchandiseReturnControllerProvider(
                        widget.orderId,
                      ).select((s) => s.valueOrNull),
                    )
                    ?.merchandiseReturnModel
                    .showPickupDate ??
                false) ||
            (ref
                    .read(
                      merchandiseReturnControllerProvider(
                        widget.orderId,
                      ).select((s) => s.valueOrNull),
                    )
                    ?.merchandiseReturnModel
                    .pickupDate !=
                null),
  };

  final loadingNotifer = ValueNotifier<bool>(false);

  bool _validateNewAddress(AddressModel addressModel) {
    var appFormController = AppFormController<AddressModel>(
      AddressModelFormBuilder(addressModel).build(),
    );
    var isValid = appFormController.submit();
    appFormController.dispose();
    return isValid;
  }

  @override
  void dispose() {
    loadingNotifer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(merchandiseReturnControllerProvider(widget.orderId), (
      oldState,
      state,
    ) {
      loadingNotifer.value = state.isLoading;
    });
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'İade Talebi'),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildSteps(),
            ValueListenableBuilder(
              valueListenable: loadingNotifer,
              builder: (context, value, child) {
                return value ? AppAnimatedLoadingWidget() : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps() {
    return ConsumerFuterBuilderWidget(
      futureBuilder:
          (submitingRef) => submitingRef.watch(
            merchandiseReturnControllerProvider(
              widget.orderId,
            ).selectAsync((s) => s.isSubmitting),
          ),
      builder: (submitingContext, submitingRef, submitingSnapshot) {
        if (!submitingSnapshot.hasData) return SizedBox.shrink();

        if (submitingSnapshot.data!) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.width() * 0.8,
                      maxHeight: context.height() * 0.7,
                    ),
                    child: AppCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Başarılı işlem ikonu
                          SizedBox(
                            width: context.height() * 0.05,
                            height: context.height() * 0.020,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.loose,
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -context.height() * 0.07,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            context
                                                .theme
                                                .scaffoldBackgroundColor,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        size:
                                            (context.height() * 0.05) -
                                            16, // Ekran genişliğine göre ikon boyutu
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16.0),

                          Html(
                            data:
                                submitingRef
                                    .read(
                                      (merchandiseReturnControllerProvider(
                                        widget.orderId,
                                      ).select((s) => s.requireValue)),
                                    )
                                    .merchandiseReturnModel
                                    .result ??
                                '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AppBottomNavigation(
                child: AppCommonButton(
                  text: 'Çıkış',
                  height: 48,
                  bgColor:
                      getIt<ThemeController>().isDarkMode
                          ? borderDark
                          : primaryColor100,
                  textColor:
                      getIt<ThemeController>().isDarkMode
                          ? whiteColor
                          : colorPrimary,
                  onPressed: () => context.router.maybePop(),
                ),
              ),
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, boxCons) {
                  return ConsumerFuterBuilderWidget(
                    futureBuilder:
                        (stepConsRef) => stepConsRef.watch(
                          merchandiseReturnControllerProvider(
                            widget.orderId,
                          ).selectAsync((s) => s.currentStep),
                        ),
                    builder: (stepConsContext, stepConsRef, stepConsSnapshot) {
                      var totalStep =
                          stepConsRef.read(
                            merchandiseReturnControllerProvider(
                              widget.orderId,
                            ).select((s) => s.valueOrNull?.totalSteps),
                          ) ??
                          1;

                      var currentStep = stepConsSnapshot.data ?? 0;

                      return Column(
                        children: [
                          // Horizontally scrollable step headers
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                totalStep,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      var stepValids = List.generate(
                                        (stepConsSnapshot.data ?? 0) + 1,
                                        (i) => stepValidators[i]!(),
                                      );
                                      if (stepValids.any((v) => !v)) {
                                        return;
                                      }
                                      stepConsRef
                                          .read(
                                            merchandiseReturnControllerProvider(
                                              widget.orderId,
                                            ).notifier,
                                          )
                                          .goToStep(index);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color:
                                                currentStep == index
                                                    ? colorPrimary
                                                    : currentStep > index
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade200,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color:
                                                  currentStep == index
                                                      ? Colors.white
                                                      : Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        currentStep == index
                                            ? AppCardTitle.active(
                                              title: _getStepTitle(index),
                                              hasDivider: false,
                                            )
                                            : AppCardTitle.primary(
                                              title: _getStepTitle(index),
                                              hasDivider: false,
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Step content
                          Expanded(
                            child: _buildStepContent(currentStep, boxCons),
                          ),
                          // Bottom navigation
                          AppBottomNavigation(
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppCommonButton(
                                    text: 'Vazgeç',
                                    height: 48,
                                    bgColor:
                                        getIt<ThemeController>().isDarkMode
                                            ? borderDark
                                            : primaryColor100,
                                    textColor:
                                        getIt<ThemeController>().isDarkMode
                                            ? whiteColor
                                            : colorPrimary,
                                    onPressed: () => context.router.maybePop(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ConsumerFuterBuilderWidget(
                                  futureBuilder:
                                      (nextButtonRef) => nextButtonRef.watch(
                                        merchandiseReturnControllerProvider(
                                          widget.orderId,
                                        ).selectAsync((s) => s),
                                      ),
                                  builder: (
                                    nextButtonContext,
                                    nextButtonRef,
                                    nextButtonSnapshot,
                                  ) {
                                    return Expanded(
                                      child: AppCommonButton(
                                        text:
                                            currentStep == totalStep - 1
                                                ? 'Talep Oluştur'
                                                : 'İleri',
                                        height: 48,
                                        onPressed: () async {
                                          if (!stepValidators[stepConsSnapshot
                                                  .data ??
                                              0]!()) {
                                            toast(
                                              'Lütfen gerekli alanları doldurunuz',
                                            );
                                            return;
                                          }

                                          if (currentStep == totalStep - 1) {
                                            await stepConsRef
                                                .read(
                                                  merchandiseReturnControllerProvider(
                                                    widget.orderId,
                                                  ).notifier,
                                                )
                                                .createMerchandiseReturnRequest();
                                          } else {
                                            stepConsRef
                                                .read(
                                                  merchandiseReturnControllerProvider(
                                                    widget.orderId,
                                                  ).notifier,
                                                )
                                                .stepContinue();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loadingBuilder: (
                      pickUpConsContext,
                      pickUpConsRef,
                      pickUpConsSnapshot,
                    ) {
                      return AppAnimatedLoadingWidget();
                    },
                    errorBuilder: (context, snapShotRef, snapshot) {
                      return AppErrorWidget(message: snapshot.error.toString());
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _returnItemsStep() {
    return LayoutBuilder(
      builder: (context, boxCons) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              top: 0,
              left: 0,
              child: ConsumerFuterBuilderWidget(
                futureBuilder:
                    (orderInfoRef) => orderInfoRef.watch(
                      merchandiseReturnControllerProvider(
                        widget.orderId,
                      ).selectAsync((s) => s.returnItems),
                    ),
                builder: (orderInfoContext, orderInfoRef, orderInfoSnapshot) {
                  return AppCard(
                    child: Column(
                      children: [
                        AppCardTitle.error(
                          title: 'İade Edilecek Ürünler',
                          hasDivider: true,
                        ),
                        8.height,
                        Expanded(
                          child: AppInifiniteScrollList(
                            key: const ValueKey('return_items'),
                            shrinkWrap: true,
                            isLoading: false,
                            hasMore: false,
                            padding: EdgeInsets.all(0),
                            onLoadMore: () => Future.value(),
                            itemCount: orderInfoSnapshot.data?.length ?? 0,
                            emptyBuilder:
                                (context) => Center(
                                  child: AppErrorWidget(
                                    message:
                                        'Henüz iade edilecek ürün eklemediniz!',
                                    type: ErrorType.info,
                                    isDismissible: false,
                                  ),
                                ),
                            itemBuilder: (context, index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  SelectableCard(
                                    onTap: null,
                                    isSelected: false,
                                    showSelectionCheckbox: false,
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppCardTitle.primary(
                                          title:
                                              orderInfoSnapshot
                                                  .data?[index]
                                                  .productName ??
                                              '...',
                                          hasDivider: true,
                                        ),
                                        AppSummaryRowWidget(
                                          'Ürün Adedi',
                                          orderInfoSnapshot
                                                  .data?[index]
                                                  .quantity
                                                  ?.toString() ??
                                              '...',
                                        ),
                                        AppSummaryRowWidget(
                                          'Ürün Fiyatı',
                                          '${orderInfoSnapshot.data?[index].quantity?.toString() ?? ''} X ${orderInfoSnapshot.data?[index].unitPrice?.toString() ?? '...'}',
                                          isPrice: true,
                                        ),
                                        AppSummaryRowWidget(
                                          'İade Nedeni',
                                          orderInfoRef
                                                  .read(
                                                    merchandiseReturnControllerProvider(
                                                      widget.orderId,
                                                    ).select(
                                                      (s) => s.valueOrNull,
                                                    ),
                                                  )
                                                  ?.merchandiseReturnModel
                                                  .availableReturnReasons!
                                                  .where(
                                                    (element) =>
                                                        element.id ==
                                                        orderInfoSnapshot
                                                            .data?[index]
                                                            .merchandiseReturnReasonId,
                                                  )
                                                  .firstOrNull
                                                  ?.name ??
                                              '...',
                                          isHighlight: true,
                                        ),
                                        AppSummaryRowWidget(
                                          'Talep Edilen İşlem',
                                          orderInfoRef
                                                  .read(
                                                    merchandiseReturnControllerProvider(
                                                      widget.orderId,
                                                    ).select(
                                                      (s) => s.valueOrNull,
                                                    ),
                                                  )
                                                  ?.merchandiseReturnModel
                                                  .availableReturnActions!
                                                  .where(
                                                    (element) =>
                                                        element.id ==
                                                        orderInfoSnapshot
                                                            .data?[index]
                                                            .merchandiseReturnActionId,
                                                  )
                                                  .firstOrNull
                                                  ?.name ??
                                              '...',
                                          isHighlight: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: GestureDetector(
                                      onTap: () {
                                        orderInfoRef
                                            .read(
                                              merchandiseReturnControllerProvider(
                                                widget.orderId,
                                              ).notifier,
                                            )
                                            .removeReturnItem(
                                              orderInfoSnapshot.data![index],
                                            );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: appRedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (
                  pickUpConsContext,
                  pickUpConsRef,
                  pickUpConsSnapshot,
                ) {
                  return AppAnimatedLoadingWidget();
                },
                errorBuilder: (context, snapShotRef, snapshot) {
                  return AppErrorWidget(message: snapshot.error.toString());
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ConsumerFuterBuilderWidget(
                  futureBuilder:
                      (orderInfoRef) => orderInfoRef.watch(
                        merchandiseReturnControllerProvider(
                          widget.orderId,
                        ).selectAsync((s) => s.merchandiseReturnModel.items),
                      ),
                  builder: (orderInfoContext, orderInfoRef, orderInfoSnapshot) {
                    return AppIconButton(
                      icon: Icon(
                        Icons.add_box_rounded,
                        color: colorPrimary,
                        size: 40,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await orderInfoContext.router.pushWidget(
                          SelectReturnItemWidget(
                            returnableItems: orderInfoSnapshot.data!,
                            availableReturnReasons:
                                orderInfoRef
                                    .read(
                                      merchandiseReturnControllerProvider(
                                        widget.orderId,
                                      ).select((s) => s.valueOrNull),
                                    )
                                    ?.merchandiseReturnModel
                                    .availableReturnReasons ??
                                [],
                            availableReturnActions:
                                orderInfoRef
                                    .read(
                                      merchandiseReturnControllerProvider(
                                        widget.orderId,
                                      ).select((s) => s.valueOrNull),
                                    )
                                    ?.merchandiseReturnModel
                                    .availableReturnActions ??
                                [],
                            onAddReturnItem: (item) async {
                              orderInfoRef
                                  .read(
                                    merchandiseReturnControllerProvider(
                                      widget.orderId,
                                    ).notifier,
                                  )
                                  .addReturnItem(item);
                              await orderInfoContext.router.maybePop();
                            },
                          ),
                        );
                      },
                    );
                  },
                  loadingBuilder: (
                    pickUpConsContext,
                    pickUpConsRef,
                    pickUpConsSnapshot,
                  ) {
                    return SizedBox.shrink();
                  },
                  errorBuilder: (context, snapShotRef, snapshot) {
                    return AppErrorWidget(message: snapshot.error.toString());
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _pickUpAddressStep() {
    return ConsumerFuterBuilderWidget(
      futureBuilder:
          (pickUpConsRef) => pickUpConsRef.read(
            merchandiseReturnControllerProvider(
              widget.orderId,
            ).selectAsync((s) => s.merchandiseReturnModel),
          ),
      builder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        return HookBuilder(
          builder: (context) {
            var selectedAddressState = useState<String?>(
              pickUpConsSnapshot.data?.pickupAddressId,
            );
            pickUpConsRef
                .read(
                  merchandiseReturnPickupAdressControllerProvider(
                    pickUpConsSnapshot.data!,
                  ).notifier,
                )
                .newAddressNotifier
                .addListener(() {
                  if (pickUpConsRef
                          .read(
                            merchandiseReturnPickupAdressControllerProvider(
                              pickUpConsSnapshot.data!,
                            ).notifier,
                          )
                          .newAddressNotifier
                          .value !=
                      null) {
                    pickUpConsRef
                        .read(
                          merchandiseReturnControllerProvider(
                            widget.orderId,
                          ).notifier,
                        )
                        .setPickUpNewAddress(
                          pickUpConsRef
                              .read(
                                merchandiseReturnPickupAdressControllerProvider(
                                  pickUpConsSnapshot.data!,
                                ).notifier,
                              )
                              .newAddressNotifier
                              .value!,
                        );
                    selectedAddressState.value = null;
                  }
                });
            return AddressPicker(
              provider: merchandiseReturnPickupAdressControllerProvider(
                pickUpConsSnapshot.data!,
              ),
              controller: pickUpConsRef.read(
                merchandiseReturnPickupAdressControllerProvider(
                  pickUpConsSnapshot.data!,
                ).notifier,
              ),
              addressEditable: false,
              selectable: true,
              onAddressSelected: (p0) {
                if (p0.id == null) {
                  pickUpConsRef
                      .read(
                        merchandiseReturnControllerProvider(
                          widget.orderId,
                        ).notifier,
                      )
                      .setPickUpNewAddress(p0);
                  selectedAddressState.value = null;
                } else {
                  pickUpConsRef
                      .read(
                        merchandiseReturnControllerProvider(
                          widget.orderId,
                        ).notifier,
                      )
                      .setPickUpExistingAddress(p0.id!);
                  selectedAddressState.value = p0.id;
                }
              },
              selectedAddressId: selectedAddressState.value,
            );
          },
        );
      },
      loadingBuilder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        return AppAnimatedLoadingWidget();
      },
      errorBuilder: (context, snapShotRef, snapshot) {
        return AppErrorWidget(message: snapshot.error.toString());
      },
    );
  }

  Widget _pickUpAddressDate() {
    return ConsumerFuterBuilderWidget(
      futureBuilder:
          (pickUpConsRef) => pickUpConsRef.watch(
            merchandiseReturnControllerProvider(
              widget.orderId,
            ).selectAsync((s) => s.merchandiseReturnModel),
          ),
      builder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        var formBuilder = FormBuilder<MerchandiseReturnModel>(
          pickUpConsSnapshot.data!,
        );
        formBuilder.addField(
          '',
          (model) => model.pickupDate,
          label: 'Alınma Tarihi',
          type: FormFieldType.date,
          isRequired: pickUpConsSnapshot.data!.pickupDateRequired!,
        );
        return GenericForm(
          formBuilder: formBuilder,
          onFieldChange: (fieldName, v) {
            if (v != null && v is DateTime) {
              pickUpConsRef
                  .read(
                    merchandiseReturnControllerProvider(
                      widget.orderId,
                    ).notifier,
                  )
                  .setPickupDate(v);
            }
          },
        );
      },
      loadingBuilder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        return AppAnimatedLoadingWidget();
      },
      errorBuilder: (context, snapShotRef, snapshot) {
        return AppErrorWidget(message: snapshot.error.toString());
      },
    );
  }

  Widget _returnRequestComments() {
    return ConsumerFuterBuilderWidget(
      futureBuilder:
          (pickUpConsRef) => pickUpConsRef.read(
            merchandiseReturnControllerProvider(
              widget.orderId,
            ).selectAsync((s) => s.merchandiseReturnModel),
          ),
      builder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        return HookBuilder(
          builder: (context) {
            var formBuilder = useMemoized(() {
              var formBuilderMemo = FormBuilder<MerchandiseReturnModel>(
                pickUpConsSnapshot.data!,
              );
              formBuilderMemo.addMultilineTextField(
                '',
                (model) => model.comments,
                label: 'İade Sebebi Açıklaması',
                lines: 5,
                isRequired: false,
              );
              return formBuilderMemo;
            });

            var formController = useMemoized(() {
              var formControllerMemo =
                  AppFormController<MerchandiseReturnModel>(
                    formBuilder.build(),
                    onFieldChange: (fieldName, v) {
                      pickUpConsRef
                          .read(
                            merchandiseReturnControllerProvider(
                              widget.orderId,
                            ).notifier,
                          )
                          .setComment(v);
                    },
                  );
              return formControllerMemo;
            });
            return GenericForm(
              formBuilder: formBuilder,
              formController: formController,
            );
          },
        );
      },
      loadingBuilder: (pickUpConsContext, pickUpConsRef, pickUpConsSnapshot) {
        return AppAnimatedLoadingWidget();
      },
      errorBuilder: (context, snapShotRef, snapshot) {
        return AppErrorWidget(message: snapshot.error.toString());
      },
    );
  }
}
