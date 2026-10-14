import 'package:auto_route/auto_route.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/dialog/dialog_helper.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/core/utils/extensions/list_extensions.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/discount_coupon_model/discount_coupon_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/gift_voucher_coupon_model/gift_voucher_coupon_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/order_totals_model/order_totals_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/checkout_attribute_model/checkout_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/cart_state.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/form_builders/checkout_attribute_model_form_builder.dart';
import 'package:store_user_app/presentation/screens/cart/widgets/require_login_bottom_sheet.dart';
import 'package:store_user_app/presentation/screens/cart/widgets/shopping_cart_item_list_tile.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

import '../../../../domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/presentation/widgets/shopping_cart_info/widgets/shopping_cart_info_card.dart';

@RoutePage()
class CartScreen extends StatefulHookConsumerWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // late AppFormController<DiscountCouponModel> _couponController;
  //late AppFormController<GiftVoucherCouponModel> _giftVoucherController;

  final giftVoucherCouponFormBuilder = FormBuilder<GiftVoucherCouponModel>(
    GiftVoucherCouponModel(),
  )
    ..addField(
      'GiftVoucherCouponCode',
          (model) => model.giftVoucherCouponCode,
      label: 'Hediye kupon kodu',
      isRequired: true,
    ).setHintText('Kupon Kodunuzu giriniz');

  // final discountCouponCodeFormBuilder = FormBuilder<DiscountCouponModel>(
  //   DiscountCouponModel(),
  // )..addField(
  //   'DiscountCouponCode',
  //   (model) => model.discountCouponCode,
  //   label: 'İndirim kupon kodu',
  //   isRequired: true,
  // );

  final loadingValueNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // _couponController = AppFormController(
    //   discountCouponCodeFormBuilder.build(),
    //   onDispose: refreshController,
    // );
    // _giftVoucherController = AppFormController(
    //   giftVoucherCouponFormBuilder.build(),
    //   onDispose: refreshController,
    // );
  }

  void refreshController() {
    if (context.mounted) {
      // setState(() {
      //   _couponController = AppFormController(
      //       discountCouponCodeFormBuilder.build(),
      //       onDispose: refreshController);
      //   _giftVoucherController = AppFormController(
      //       giftVoucherCouponFormBuilder.build(),
      //       onDispose: refreshController);
      // });
    }
  }

  @override
  void dispose() {
    loadingValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final (:pending, snapshot: stateSnapShot, hasError: _) =
    //     useAsyncTask<bool>();
    ref.listen(shoppingCartUseCaseProvider, (oldState, state) {
      loadingValueNotifier.value = state.isLoading;
    });
    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Sepetim',
        actionWidget: LoadComponentWhenVisible(
          onVisible: () async {
            // pending.value = ref
            //     .read(shoppingCartUseCaseProvider.selectAsync((x) => x.isLoading))
            //     .synchronized<bool>(() {
            //   return ref.read(shoppingCartUseCaseProvider
            //       .select((s) => s.requireValue.isLoading));
            // });
          },
          builder: (isVisible) {
            return Consumer(
              builder: (
                  removeAllItemConsContext,
                  removeAllItemConsRef,
                  removeAllItemConsChild,
                  ) {
                return FutureBuilder(
                  future: removeAllItemConsRef.watch(
                    shoppingCartUseCaseProvider.selectAsync((x) => x.cart),
                  ),
                  builder: (ctx, snapShot) {
                    if (snapShot.hasData) {
                      return IconButton(
                        onPressed: () async {
                          final shouldClear = await DialogHelper.showAlertDialog(
                            title: 'Onaylıyor musunuz?',
                            message:
                            'Sepetinizdeki tüm ürünler silinecek. Onaylıyor musunuz?',
                            cancelText: 'Hayır',
                            confirmText: 'Evet',
                          );

                          if (shouldClear == true) {
                            await removeAllItemConsRef
                                .read(shoppingCartUseCaseProvider.notifier)
                                .clearCart();
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: appRedColor,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              },
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(shoppingCartUseCaseProvider.notifier).refreshCart();
        },
        color: context.colorScheme.primary,
        child: _buildContent(),
      ),
      bottomNavigationBar: Consumer(
        builder: (
            bottomNavigationBarConsContext,
            bottomNavigationBarConsRef,
            bottomNavigationBarConsChild,
            ) {
          return Container(
            color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                8.height,

                bottomNavigationBarConsRef
                    .watch(shoppingCartUseCaseProvider)
                    .when(
                  skipError: true,
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  data: (data) {
                    var text =
                    ((data.cart?.items?.isEmpty ?? true) ||
                        !(data
                            .shoppingCartInfo
                            ?.canCheckout ??
                            true))
                        ? 'Alışverişe Devam Et'
                        : 'Siparişi Tamamla ${!((data.orderTotal?.orderTotal ?? '').isEmptyOrNull) ? '(${data.orderTotal?.orderTotal})' : ''}';
                    var action =
                    ((data.cart?.items?.isEmpty ?? true) ||
                        !(data
                            .shoppingCartInfo
                            ?.canCheckout ??
                            true))
                        ? () async {
                      context.router.maybePop();
                    }
                        : () async => await _completeShop(
                      bottomNavigationBarConsContext,
                      bottomNavigationBarConsRef,
                      data,
                    );
                    return AppCommonButton(
                      text: text,
                      onPressed: action,
                      textStyle: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: '',
                        color: Colors.white,
                      ),
                    );
                  },
                  error: (err, stack) => SizedBox.shrink(),
                  loading: () => AppCommonButton(text: '...'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _completeShop(
      BuildContext context,
      WidgetRef bottomNavigationBarConsRef,
      CartState data,
      ) async {
    if ((data.cart?.checkoutAttributes?.isNotEmpty ?? false)) {
      // var attributeResponse = await showModalBottomSheet<bool>(
      //   isScrollControlled: true,
      //   showDragHandle: true,
      //   context: context,
      //   useSafeArea: true,
      //   useRootNavigator: true,
      //   builder: (dialogContext) {
      //     return bottomSheet;
      //   },
      // );

      var attributeResponse = await getIt<AppRouter>().pushWidget(
        Dialog.fullscreen(
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: fdCommonAppBarWidget(context),
                body: BaseBottomSheet(
                  width: MediaQuery.of(context).size.width,
                  maxHeightPercentage: 1,
                  title: 'Ödeme seçenekleri',
                  contentBuilder:
                      (builderCOntext) => Consumer(
                    builder: (context, attributeRef, child) {
                      return _buildCheckoutAttributes(
                        (attributeRef
                            .read(
                          shoppingCartUseCaseProvider.select(
                                (x) => x.valueOrNull,
                          ),
                        )
                            ?.cart!
                            .checkoutAttributes!) ??
                            [],
                      );
                    },
                  ),
                  footerBuilder:
                      (context) => AppBottomNavigation(
                    child: Row(
                      children: [
                        Expanded(
                          child: AppCommonButton(
                            bgColor:
                            getIt<ThemeController>().isDarkMode
                                ? app_colors.borderDark
                                : app_colors.primaryColor100,
                            textColor:
                            getIt<ThemeController>().isDarkMode
                                ? whiteColor
                                : app_colors.colorPrimary,
                            text: 'İptal',
                            onPressed: () {
                              context.router.maybePop(false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppCommonButton(
                            text: 'Tamamla',
                            onPressed: () {
                              context.router.maybePop(true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      if (attributeResponse != true) {
        return;
      }
    }
    await _goToCheckot(bottomNavigationBarConsRef, context, data);
  }

  Future<void> _goToCheckot(
      WidgetRef bottomNavigationBarConsRef,
      BuildContext context,
      CartState data,
      ) async {
    final response =
    await bottomNavigationBarConsRef
        .read(shoppingCartUseCaseProvider.notifier)
        .startCheckout();

    if ((response?.isRedirectResponse ?? false) &&
        response!.redirect!.redirectUri != null &&
        response.redirect!.redirectUri!.queryParameters['routeName'] != null &&
        response.redirect!.redirectUri!.queryParameters['routeName'] ==
            'Checkout') {
      context.router.push(
        CheckoutRoute(
          requireAuthorization: data.cart!.isGuest ?? true,
          checkoutAsGuest: data.cart!.showCheckoutAsGuestButton ?? false,
        ),
      );
    } else if ((response?.isRedirectResponse ?? false) &&
        response!.redirect!.redirectUri != null &&
        response.redirect!.redirectUri!.path.contains('login')) {
      var pageModel = await (await getIt.getAsync<ComponentRepository>())
          .postPageBlockComponent('CheckoutAsGuestOrRegister');
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (context) {
          return RequireLoginBottomSheet(
            pageModel: pageModel,
            showCheckoutAsGuest: data.cart!.showCheckoutAsGuestButton ?? false,
          );
        },
      );
      // context.router.pushWidget();
    }
  }

  Widget _buildCartItem(ShoppingCartItemModel item, CartState cartState) {
    return Consumer(
      builder: (cardItemsConsContext, cardItemsConsRef, cardItemsConsChild) {
        return ShoppingCartItemListTile(
          cartItem: item,
          onChanged: (value) async {
            await cardItemsConsRef
                .read(shoppingCartUseCaseProvider.notifier)
                .updateQuantity(item.id!, value);
          },
          onIncrease: () async {
            await cardItemsConsRef
                .read(shoppingCartUseCaseProvider.notifier)
                .updateQuantity(item.id!, item.quantity! + 1);
          },
          onDecrease: () async {
            if (item.quantity! > 1) {
              await cardItemsConsRef
                  .read(shoppingCartUseCaseProvider.notifier)
                  .updateQuantity(item.id!, item.quantity! - 1);
            } else {
              await cardItemsConsRef
                  .read(shoppingCartUseCaseProvider.notifier)
                  .removeItem(item.id!);
            }
          },
          onRemove: () async {
            await cardItemsConsRef
                .read(shoppingCartUseCaseProvider.notifier)
                .removeItem(item.id!);
          },
        );
      },
    );
  }

  Widget _buildDiscountSection(ShoppingCartModel cartState) {
    return _buildSection(
      title: 'İdirim Kuponu',
      child: ConsumerFuterBuilderWidget(
        futureBuilder:
            (discountCouponCodeConsumerRef) =>
            discountCouponCodeConsumerRef.watch(
              shoppingCartUseCaseProvider.selectAsync((sc) => sc.cart),
            ),
        builder: (
            discountCouponCodeConsumerContext,
            discountCouponCodeConsumerRef,
            discountCouponCodeConsumerSnapShot,
            ) {
          if (!discountCouponCodeConsumerSnapShot.hasData) {
            return const SizedBox.shrink();
          }

          if ((discountCouponCodeConsumerSnapShot.data!.discountBox?.display ??
              false) ==
              false) {
            return const SizedBox.shrink();
          }

          var cartStateData = discountCouponCodeConsumerSnapShot.data!;

          return HookBuilder(
            builder: (context) {
              final (
                  :pending,
                  :snapshot,
              hasError: _,
              loaderColor: _,
              loaderStrokeWidth: _,
              ) = useAsyncTask<void>();

              final formBuilder = useMemoized(
                    () =>
                FormBuilder<DiscountCouponModel>(DiscountCouponModel())
                  ..addField(
                    'DiscountCouponCode',
                        (model) => model.discountCouponCode,
                    label: 'İndirim kupon kodu',
                    isRequired: true,
                  ).setHintText("Kupon Kodunuzu giriniz"),
                [cartStateData],
              );

              final formController = useMemoized(
                    () => AppFormController(
                  formBuilder.build(),
                  onDispose: refreshController,
                ),
                [formBuilder],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GenericForm(
                          formBuilder: formBuilder,
                          formController: formController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppCommonButton.adaptive(
                        text: 'Uygula',
                        widthRate: 0.26,
                        onPressed: () async {
                          if (formController.isValid) {
                            await ref
                                .read(shoppingCartUseCaseProvider.notifier)
                                .applyDiscountCoupon(
                              DiscountCouponModel.fromJson(
                                formController.getValues(),
                              ).discountCouponCode!,
                            );
                            formController.reset();
                          }
                        },
                      ),
                    ],
                  ),
                  if (cartState.discountBox?.message?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        cartState.discountBox!.message!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.red),
                      ),
                    ),
                  if (cartState
                      .discountBox
                      ?.appliedDiscountsWithCodes
                      ?.isNotEmpty ??
                      false)
                    ...cartState.discountBox!.appliedDiscountsWithCodes!.map(
                          (discount) => ListTile(
                        title: Text(discount.couponCode ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed:
                              () => ref
                              .read(shoppingCartUseCaseProvider.notifier)
                              .removeDiscountCoupon(discount.id!),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGiftVoucherSection(ShoppingCartModel cartState) {

    return _buildSection(
      title: 'Hediye Çeki',
      child:ConsumerFuterBuilderWidget(
        futureBuilder:
            (discountCouponCodeConsumerRef) =>
            discountCouponCodeConsumerRef.watch(
              shoppingCartUseCaseProvider.selectAsync((sc) => sc.cart),
            ),
        builder: (
            discountCouponCodeConsumerContext,
            discountCouponCodeConsumerRef,
            discountCouponCodeConsumerSnapShot,
            ) {
          if (!discountCouponCodeConsumerSnapShot.hasData) {
            return const SizedBox.shrink();
          }

          if ((discountCouponCodeConsumerSnapShot.data!.giftVoucherBox?.display ??
              false) ==
              false) {
            return const SizedBox.shrink();
          }

          var cartStateData = discountCouponCodeConsumerSnapShot.data!;

          return HookBuilder(
            builder: (context) {

              final formBuilder = useMemoized(
                    () =>
                    FormBuilder<GiftVoucherCouponModel>(
                      GiftVoucherCouponModel(),
                    )
                      ..addField(
                        'GiftVoucherCouponCode',
                            (model) => model.giftVoucherCouponCode,
                        label: 'Hediye kupon kodu',
                        isRequired: true,
                      ).setHintText('Kupon Kodunuzu giriniz'),
                [cartStateData],
              );

              final formController = useMemoized(
                    () => AppFormController(
                  formBuilder.build(),
                  onDispose: refreshController,
                ),
                [formBuilder],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GenericForm(
                          formBuilder: formBuilder,
                          formController: formController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppCommonButton.adaptive(
                        text: 'Uygula',
                        widthRate: 0.26,
                        onPressed: () async {
                          if (formController.validate()) {
                            await ref
                                .read(shoppingCartUseCaseProvider.notifier)
                                .applyGiftVoucher(
                              GiftVoucherCouponModel.fromJson(
                                formController.getValues(),
                              ).giftVoucherCouponCode!,
                            );
                            formController.reset();
                          }
                        },
                      ),
                    ],
                  ),
                  if (cartState.giftVoucherBox?.message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        cartState.giftVoucherBox!.message!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.red),
                      ),
                    ),
                ],
              );
            },
          );
        },
      )



    );
  }

  Widget _buildCartTotals(OrderTotalsModel orderTotal) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orderTotal.subTotal != null)
            _buildSummaryRow('Ara Toplam', orderTotal.subTotal!, isPrice: true),
          if (orderTotal.subTotalDiscount != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'İndirim',
              orderTotal.subTotalDiscount!,
              isPrice: true,
            ),
          ],
          if (orderTotal.shipping != null &&
              orderTotal.requiresShipping == true) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Kargo',
              orderTotal.shipping!,
              isHighlight: true,
              isPrice: true,
            ),
            if (orderTotal.selectedShippingMethod != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  orderTotal.selectedShippingMethod!,
                  style: context.textTheme.bodyMedium,
                ),
              ),
          ],
          if (orderTotal.giftVouchers?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Text('Hediye Kartları', style: context.textTheme.titleMedium),
            ...orderTotal.giftVouchers!.map(
                  (voucher) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      voucher.couponCode ?? '',
                      style: context.textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        Text(
                          '${voucher.amount ?? ''}',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontFamily: '',
                          ),
                        ),
                        if (orderTotal.isEditable == true) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              if (voucher.id != null) {
                                ref
                                    .read(shoppingCartUseCaseProvider.notifier)
                                    .removeGiftVoucher(voucher.id!);
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (orderTotal.displayTax == true && orderTotal.tax != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow('KDV', orderTotal.tax!, isPrice: true),
            if (orderTotal.displayTaxRates == true)
              ...orderTotal.taxRates
                  ?.map(
                    (rate) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildSummaryRow(
                    '${rate.rate} KDV',
                    rate.value ?? '',
                    isSmall: true,
                    isPrice: true,
                  ),
                ),
              )
                  .toList() ??
                  [],
          ],
          if (orderTotal.redeemedLoyaltyPoints != null &&
              orderTotal.redeemedLoyaltyPointsAmount != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Kullanılan Puan (${orderTotal.redeemedLoyaltyPoints})',
              '${orderTotal.redeemedLoyaltyPointsAmount}',
              isPrice: true,
            ),
          ],
          if (!(orderTotal.orderTotalDiscount?.isEmptyOrNull ?? true)) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Toplam indirim',
              orderTotal.orderTotalDiscount!,
              isPrice: true,
              isHighlight: true,
            ),
          ],
          if (!(orderTotal.orderTotal.isEmptyOrNull)) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Genel Toplam',
                  style: context.textTheme.titleLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orderTotal.orderTotal ?? '',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontFamily: '',
                  ),
                ),
              ],
            ),
          ],
          if (orderTotal.willEarnLoyaltyPoints != null) ...[
            const SizedBox(height: 8),
            Text(
              'Bu siparişten ${orderTotal.willEarnLoyaltyPoints} puan kazanacaksınız',
              style: context.textTheme.bodySmall!.copyWith(color: colorPrimary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      String label,
      String amount, {
        bool isHighlight = false,
        bool isSmall = false,
        bool isPrice = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
          (isHighlight
              ? context.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
          )
              : isSmall
              ? context.textTheme.bodySmall
              : context.textTheme.labelSmall),
        ),
        Text(
          amount,
          style:
          (isHighlight
              ? context.textTheme.titleSmall!.copyWith(
            fontFamily: isPrice ? '' : null,
            fontWeight: FontWeight.bold,
            color: colorPrimary,
          )
              : isSmall
              ? context.textTheme.bodySmall!.copyWith(
            fontFamily: isPrice ? '' : null,
          )
              : context.textTheme.labelSmall!.copyWith(
            fontFamily: isPrice ? '' : null,
          )),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    Widget? titleAction,
    required Widget child,
  }) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (titleAction != null) titleAction,
            ],
          ),
          15.height,
          Divider(
            color:
            getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
            height: 1,
            thickness: 1,
          ),
          15.height,
          child,
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer(
      builder: (
          orderSummaryConsContext,
          orderSummaryConsRef,
          orderSummaryConsChild,
          ) {
        return orderSummaryConsRef
            .watch(shoppingCartUseCaseProvider)
            .when(
          skipError: true,
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (data) {
            return AppCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderSummary,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colorPrimary, width: 2),
                        ),
                        child: Text(
                          addItems,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Divider(
                    color:
                    getIt<ThemeController>().isDarkMode
                        ? borderDark
                        : borderColor,
                    height: 1,
                    thickness: 1,
                  ),
                  15.height,
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                    data.cart?.items
                        ?.map((item) => _buildCartItem(item, data))
                        .toList()
                        .joinBySperatedWidget(
                      Divider(
                        color:
                        getIt<ThemeController>().isDarkMode
                            ? borderDark
                            : borderColor,
                        height: 1,
                        thickness: 1,
                      ),
                    ) ??
                        [],
                  ),
                ],
              ),
            );
          },
          error: (err, stack) => AppErrorWidget(message: err.toString()),
          loading:
              () => Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }

  Widget _buildContent() {
    return Consumer(
      builder: (consContext, consRef, consChild) {
        return FutureBuilder(
          future: consRef.watch(
            shoppingCartUseCaseProvider.selectAsync((x) => x.cart),
          ),
          builder: (ftContext, snapshot) {
            if (snapshot.hasData) {
              var value = snapshot.data!;
              if (value.items?.isEmpty ?? true) {
                return const Center(
                  child: Text('Sepetinizde ürün bulunmamaktadır.'),
                );
              }

              return SingleChildScrollView(
                // padding: const EdgeInsets.all(16),
                child: SeparatedColumn(
                  separatorBuilder: () => const SizedBox(height: 16),
                  children: [
                    // Shopping Cart Info Card
                    const ShoppingCartInfoCard(),
                    
                    // Cart Items
                    _buildOrderSummary(),

                    // if (value.checkoutAttributes?.isNotEmpty ?? false)
                    //   (_checkoutAttributesWidget ??
                    //       (_checkoutAttributesWidget = _buildCheckoutAttributes(
                    //           value.checkoutAttributes!))),

                    // Discount Coupon Section
                    if (value.discountBox?.display ?? false)
                      _buildDiscountSection(value),

                    // Gift Voucher Section
                    if (value.giftVoucherBox?.display ?? false)
                      _buildGiftVoucherSection(value),

                    // Cart Totals
                    Consumer(
                      builder: (
                          totalConsumerCtx,
                          totalConsumerRef,
                          totalConsumerChild,
                          ) {
                        return FutureBuilder(
                          future: totalConsumerRef.watch(
                            shoppingCartUseCaseProvider.selectAsync(
                                  (s) => s.orderTotal,
                            ),
                          ),
                          builder: (orderTotalContext, snapshot) {
                            if (snapshot.hasData) {
                              return _buildCartTotals(snapshot.data!);
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildCheckoutAttributeField(CheckoutAttributeModel attributeModel) {
    final builder = CheckoutAttributeModelFormBuilder(attributeModel);
    late final AppFormController<CheckoutAttributeModel> controller;
    controller = AppFormController<CheckoutAttributeModel>(
      builder.build(),
      onFieldChange: (fieldName, value) {
        var textController = controller.getController(fieldName);
        if (textController != null && value is! DateTime) {
          return;
        }
        ref
            .read(shoppingCartUseCaseProvider.notifier)
            .setCheckoutAttribute(
          fieldName,
          value is List
              ? value.join(',')
              : value is DateTime
              ? value.toIso8601String()
              : value,
        );
      },
      onFieldFocusChange: (fieldName, hasFocus) {
        var textController = controller.getController(fieldName);
        if (textController == null) {
          return;
        }
        if (!hasFocus) {
          ref
              .read(shoppingCartUseCaseProvider.notifier)
              .setCheckoutAttribute(
            fieldName,
            controller.getValues()[fieldName],
          );
        }
      },
    );
    return ValueListenableBuilder(
      valueListenable: loadingValueNotifier,
      builder: (context, state, child) {
        return Stack(
          children: [
            child!,
            if (state)
              Positioned.fill(
                top: 0,
                left: 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
          ],
        );
      },
      child: GenericForm<CheckoutAttributeModel>(
        formBuilder: builder,
        formController: controller,
      ),
    );
  }

  Widget _buildCheckoutAttributes(
      List<CheckoutAttributeModel> checkoutAttributes,
      ) {
    {
      return Column(
        children: [
          for (var attribute in checkoutAttributes)
            _buildCheckoutAttributeField(attribute),
        ],
      );
      // return _buildSection(
      //   title: 'Ödeme seçenekleri',
      //   child: Column(
      //     children: [
      //       for (var attribute in checkoutAttributes)
      //         _buildCheckoutAttributeField(attribute)
      //     ],
      //   ),
      // );
    }
  }
}
