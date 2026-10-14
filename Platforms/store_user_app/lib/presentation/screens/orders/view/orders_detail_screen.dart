import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_item_model/order_item_model.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_note/order_note.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/shipment_brief_model/shipment_brief_model.dart';
import 'package:store_user_app/presentation/screens/orders/providers/order_detail_controller.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/order_card_skeleton.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

typedef OrderActionSectionMap =
    Map<String, Widget Function(BuildContext, OrderDetailsModel)>;

enum ActionButtonType { primary, secondary, warning }

@RoutePage()
class OrdersDetailScreen extends StatefulHookConsumerWidget {
  final String orderId;
  const OrdersDetailScreen({
    super.key,
    @PathParam('orderId') required this.orderId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrdersDetailScreenState();
}

class _OrdersDetailScreenState extends ConsumerState<OrdersDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Sipariş Detayı'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ref
              .watch(orderDetailControllerProvider(widget.orderId))
              .when(
                data: (order) {
                  return SeparatedColumn(
                    separatorBuilder: () => const Gap(8),
                    children: [
                      _buildOrderInfoSection(order.orderDetailsModel!),
                      _buildPaymentInfoSection(order.orderDetailsModel!),
                      _buildBillingInfoSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.isShippable ?? false)
                        _buildShippingInfoSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.items?.isNotEmpty ?? false)
                        _buildOrderItemsSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.items?.isNotEmpty ?? false)
                        _buildOrderTotalSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.orderNotes?.isNotEmpty ??
                          false)
                        _buildOrderNotesSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.shipments?.isNotEmpty ??
                          false)
                        _buildSipmentMovesSection(order.orderDetailsModel!),
                      if (order.orderDetailsModel?.userCanCancelUnpaidOrder ??
                          false)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20,
                          ),
                          child: _buildActionButton('İptal Et', () async {
                            await ref
                                .watch(
                                  orderDetailControllerProvider(
                                    widget.orderId,
                                  ).notifier,
                                )
                                .cancelOrder();
                          }, ActionButtonType.primary),
                        ),
                      if (order.orderDetailsModel?.isMerchandiseReturnAllowed ??
                          false)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20,
                          ),
                          child: _buildActionButton(
                            'İade isteği oluştur',
                            () async {
                              context.router.pushNamed(
                                '/orders/merchandise-return/${order.orderDetailsModel!.id!}',
                              );
                            },
                            ActionButtonType.warning,
                          ),
                        ),
                    ],
                  );
                },
                loading:
                    () => Column(
                      children: [
                        10.height,
                        const OrderCardSkeleton(),
                        // OrderCardSkeleton(),
                        // const SizedBox(height: 20),
                        // ...List.generate(3, (index) {
                        //   return OrderItemCardSkeleton();
                        // }),
                      ],
                    ),
                error:
                    (error, _) => AppErrorWidget(
                      message: error.toString(),
                      onRetry: () {
                        // ref
                        //     .read(orderDetailControllerProvider(widget.orderId).notifier)
                        //     .getOrderDetail(widget.orderId);
                      },
                    ),
              ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  SvgPicture.asset(
                    orderIcon,
                    height: context.textTheme.titleMedium?.fontSize ?? 12,
                    colorFilter: ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Sipariş Bilgileri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
              if (!(order.pdfInvoiceDisabled ?? true))
                _buildActionButton('Faturayı İndir', () async {
                  await ref
                      .watch(
                        orderDetailControllerProvider(widget.orderId).notifier,
                      )
                      .downloadOrderPdfInvoice();
                }, ActionButtonType.secondary),
              //_buildStatusChip(context, order.orderStatus ?? ''),
            ],
          ),
          Divider(),
          SeparatedColumn(
            children: [
              if (order.createdOn != null)
                _buildInfoRow(
                  context,
                  'Sipariş Tarihi',
                  order.createdOn!.formattedDateTime,
                ),
              if (order.orderCode != null && order.orderCode!.isNotEmpty)
                _buildInfoRow(context, 'Sipariş Kodu', order.orderCode!),
              if (order.orderStatus != null && order.orderStatus!.isNotEmpty)
                _buildInfoRow(
                  context,
                  'Sipariş Toplamı',
                  order.orderTotal!,
                  true,
                ),
            ],
            separatorBuilder: () => const Gap(8),
          ),
          const SizedBox(height: 8),
          Divider(
            color:
                getIt<ThemeController>().isDarkMode ? darkPrimary : borderColor,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          _buildActionRow(context, [
            if (order.showAddOrderNote ?? false)
              _buildActionButton('Not Ekle', () async {
                await ref
                    .read(
                      orderDetailControllerProvider(widget.orderId).notifier,
                    )
                    .addOrderNote(context);
              }, ActionButtonType.secondary),
            if (order.isReOrderAllowed ?? false)
              _buildActionButton('Siparişi Tekrarla', () async {
                await ref
                    .read(
                      orderDetailControllerProvider(widget.orderId).notifier,
                    )
                    .reOrder();
              }, ActionButtonType.primary),
          ]),
        ],
      ),
    );
  }

  Widget _buildBillingInfoSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  SvgPicture.asset(
                    addressIcon,
                    height: context.textTheme.titleMedium?.fontSize ?? 12,
                    colorFilter: ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Fatura Bilgileri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
              _buildStatusChip(context, order.paymentMethodStatus ?? ''),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            'Fatura Adı',
            '${order.billingAddress?.firstName ?? ''} ${order.billingAddress?.lastName ?? ''}',
          ),
          _buildInfoRow(context, 'Email', order.billingAddress?.email ?? ''),
          if (order.billingAddress?.phoneEnabled != null)
            _buildInfoRow(
              context,
              'Telefon',
              order.billingAddress?.phoneNumber ?? '',
            ),
          if (order.billingAddress?.faxEnabled != null)
            _buildInfoRow(
              context,
              'Fax',
              order.billingAddress?.faxNumber ?? '',
            ),
          if (order.billingAddress?.companyEnabled != null &&
              (order.billingAddress!.company?.isNotEmpty ?? false))
            _buildInfoRow(
              context,
              'Şirket',
              order.billingAddress?.company ?? '',
            ),
          if (order.billingAddress?.address1 != null &&
              order.billingAddress!.address1!.isNotEmpty)
            _buildInfoRow(context, 'Adres 1', order.billingAddress!.address1!),
          if (order.billingAddress?.address2 != null &&
              order.billingAddress!.address2!.isNotEmpty)
            _buildInfoRow(context, 'Adres 2', order.billingAddress!.address2!),
          if (order.billingAddress?.city != null &&
              order.billingAddress!.city!.isNotEmpty)
            _buildInfoRow(context, 'Şehir', order.billingAddress!.city!),
          if (order.billingAddress?.zipPostalCode != null &&
              order.billingAddress!.zipPostalCode!.isNotEmpty)
            _buildInfoRow(
              context,
              'Posta Kodu',
              order.billingAddress!.zipPostalCode!,
            ),
          if (order.billingAddress?.countryName != null &&
              order.billingAddress!.countryName!.isNotEmpty)
            _buildInfoRow(context, 'Ülke', order.billingAddress!.countryName!),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: context.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontFamily: AppTheme.fontFamily,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, [
    bool priceValue = false,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? colorGrey300
                      : colorGrey700,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: priceValue ? '' : AppTheme.fontFamily,
              color:
                  priceValue
                      ? (getIt<ThemeController>().isDarkMode
                          ? primaryColor100
                          : colorPrimary)
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, List<Widget> actions) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        //mainAxisSize: MainAxisSize.min,
        spacing: 8,
        runSpacing: 8,
        // mainAxisAlignment: MainAxisAlignment.end,
        alignment: WrapAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        runAlignment: WrapAlignment.spaceBetween,
        children: actions,
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    FutureOr<void> Function() onPressed, [
    ActionButtonType type = ActionButtonType.primary,
  ]) {
    {
      Color? fontColor, bgColor, borderColor;
      switch (type) {
        case ActionButtonType.primary:
          fontColor = Colors.white;
          bgColor = null;
          borderColor = null;
        case ActionButtonType.secondary:
          fontColor = colorPrimary;
          bgColor =
              getIt<ThemeController>().isDarkMode ? cardDark : Colors.white;
          borderColor = colorPrimary;
        case ActionButtonType.warning:
          fontColor = Colors.white;
          bgColor = appRedColor;
          borderColor = null;
      }

      return AppCommonButton(
        //width: MediaQuery.of(context).size.width * 0.3,
        text: text,
        onPressed: onPressed,
        height: MediaQuery.of(context).size.width * 0.12,
        textStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: fontColor,
          fontSize: MediaQuery.of(context).size.width * 0.035,
        ),
        textColor: fontColor,
        bgColor: bgColor,
        borderColor: borderColor,
      );
    }
  }

  Widget _buildPaymentInfoSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  SvgPicture.asset(
                    paymentCardIcon,
                    height: context.textTheme.titleMedium?.fontSize ?? 12,
                    colorFilter: ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Ödeme Bilgileri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
              _buildStatusChip(context, order.paymentMethodStatus ?? ''),
            ],
          ),
          SeparatedColumn(
            children: [
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                'Ödeme Yöntemi',
                order.paymentMethod ?? '',
              ),
              if (order.paymentMethodAdditionalFee != null)
                _buildInfoRow(
                  context,
                  'Ek Ücret',
                  order.paymentMethodAdditionalFee!.toString(),
                  true,
                ),
              if (order.canRePostProcessPayment ?? false)
                _buildActionRow(context, [
                  _buildActionButton('Ödemeyi Tamamla', () async {
                    await ref
                        .watch(
                          orderDetailControllerProvider(
                            widget.orderId,
                          ).notifier,
                        )
                        .rePostProcessPayment();
                  }, ActionButtonType.primary),
                ]),
            ],
            separatorBuilder: () => const Gap(8),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfoSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : colorPrimary,
                    blendMode: BlendMode.srcIn,
                  ),
                  // SvgPicture.asset(
                  //   ,
                  //   height: context.textTheme.titleMedium?.fontSize ?? 12,
                  //   colorFilter: ColorFilter.mode(
                  //       getIt<ThemeController>().isDarkMode
                  //           ? cardDark
                  //           : colorPrimary,
                  //       BlendMode.srcIn),
                  // ),
                  Text(
                    'Kargo Bilgileri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
              _buildStatusChip(context, order.shippingStatus ?? ''),
            ],
          ),
          const SizedBox(height: 8),
          if (order.shippingAddress != null) ...[
            _buildInfoRow(
              context,
              'Alıcı Adı',
              '${order.shippingAddress?.firstName ?? ''} ${order.shippingAddress?.lastName ?? ''}',
            ),
            _buildInfoRow(context, 'Email', order.shippingAddress?.email ?? ''),
            if (order.shippingAddress?.phoneEnabled != null)
              _buildInfoRow(
                context,
                'Telefon',
                order.shippingAddress?.phoneNumber ?? '',
              ),
            if (order.shippingAddress?.faxEnabled != null)
              _buildInfoRow(
                context,
                'Fax',
                order.shippingAddress?.faxNumber ?? '',
              ),
            if (order.shippingAddress?.companyEnabled != null &&
                (order.shippingAddress!.company?.isNotEmpty ?? false))
              _buildInfoRow(
                context,
                'Şirket',
                order.shippingAddress?.company ?? '',
              ),
            if (order.shippingAddress?.address1 != null &&
                order.shippingAddress!.address1!.isNotEmpty)
              _buildInfoRow(
                context,
                'Adres 1',
                order.shippingAddress!.address1!,
              ),
            if (order.shippingAddress?.address2 != null &&
                order.shippingAddress!.address2!.isNotEmpty)
              _buildInfoRow(
                context,
                'Adres 2',
                order.shippingAddress!.address2!,
              ),
            if (order.shippingAddress?.city != null &&
                order.shippingAddress!.city!.isNotEmpty)
              _buildInfoRow(context, 'Şehir', order.shippingAddress!.city!),
            if (order.shippingAddress?.zipPostalCode != null &&
                order.shippingAddress!.zipPostalCode!.isNotEmpty)
              _buildInfoRow(
                context,
                'Posta Kodu',
                order.shippingAddress!.zipPostalCode!,
              ),
            if (order.shippingAddress?.countryName != null &&
                order.shippingAddress!.countryName!.isNotEmpty)
              _buildInfoRow(
                context,
                'Ülke',
                order.shippingAddress!.countryName!,
              ),
          ],
          if (order.shippingMethod != null && order.shippingMethod!.isNotEmpty)
            _buildInfoRow(context, 'Kargo Yöntemi', order.shippingMethod!),
          if (order.shippingAdditionDescription != null &&
              order.shippingAdditionDescription!.isNotEmpty)
            _buildInfoRow(
              context,
              'Ek Açıklama',
              order.shippingAdditionDescription!,
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : colorPrimary,
                    blendMode: BlendMode.srcIn,
                  ),
                  // SvgPicture.asset(
                  //   ,
                  //   height: context.textTheme.titleMedium?.fontSize ?? 12,
                  //   colorFilter: ColorFilter.mode(
                  //       getIt<ThemeController>().isDarkMode
                  //           ? cardDark
                  //           : colorPrimary,
                  //       BlendMode.srcIn),
                  // ),
                  Text(
                    'Sipariş Ürünleri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...order.items!.map((item) => _buildOrderItemRow(context, item)),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(BuildContext context, OrderItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.productName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
            Text(
              '${item.quantity} x ${item.unitPrice}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: '',
              ),
            ),
          ],
        ),
        if (item.attributeInfo != null && item.attributeInfo!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Html(
              data: item.attributeInfo,
              style: {
                'body': Style(
                  color:
                      getIt<ThemeController>().isDarkMode
                          ? colorGrey300
                          : colorGrey700,
                  fontFamily: AppTheme.fontFamily,
                ),
              },
            ),
          ),
        const Divider(),
      ],
    );
  }

  Widget _buildOrderTotalSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  SvgPicture.asset(
                    orderIcon,
                    height: context.textTheme.titleMedium?.fontSize ?? 12,
                    colorFilter: ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Sipariş Toplamı',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Ara Toplam', order.orderSubtotal ?? '', true),
          if (order.orderSubTotalDiscount != null)
            _buildInfoRow(
              context,
              'Ara Toplam İndirimi',
              order.orderSubTotalDiscount!,
              true,
            ),
          _buildInfoRow(
            context,
            'Kargo Ücreti',
            order.orderShipping ?? '',
            true,
          ),
          if (order.paymentMethodAdditionalFee != null)
            _buildInfoRow(
              context,
              'Ek Ücret',
              order.paymentMethodAdditionalFee!,
              true,
            ),
          if (order.tax != null)
            _buildInfoRow(context, 'Vergi', order.tax!, true),
          if (order.taxRates != null && order.taxRates!.isNotEmpty)
            ...order.taxRates!.map(
              (taxRate) => _buildInfoRow(
                context,
                taxRate.rate ?? '',
                taxRate.value ?? '',
                true,
              ),
            ),
          if (order.orderTotalDiscount != null)
            _buildInfoRow(
              context,
              'Toplam İndirim',
              order.orderTotalDiscount!,
              true,
            ),
          if (order.redeemedLoyaltyPointsAmount != null)
            _buildInfoRow(
              context,
              'Kullanılan Puanlar',
              order.redeemedLoyaltyPointsAmount!,
              true,
            ),
          if (order.giftVouchers != null && order.giftVouchers!.isNotEmpty)
            ...order.giftVouchers!.map(
              (voucher) => _buildInfoRow(
                context,
                'Hediye Çeki (${voucher.couponCode})',
                voucher.amount ?? '',
                true,
              ),
            ),
          const Divider(),
          _buildInfoRow(context, 'Toplam', order.orderTotal ?? '', true),
        ],
      ),
    );
  }

  Widget _buildSipmentMovesSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              SeparatedRow(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : colorPrimary,
                    blendMode: BlendMode.srcIn,
                  ),
                  // SvgPicture.asset(
                  //   ,
                  //   height: context.textTheme.titleMedium?.fontSize ?? 12,
                  //   colorFilter: ColorFilter.mode(
                  //       getIt<ThemeController>().isDarkMode
                  //           ? cardDark
                  //           : colorPrimary,
                  //       BlendMode.srcIn),
                  // ),
                  Text(
                    'Kargo Hareketleri',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...order.shipments!.map(
            (shipment) => _buildShipmentRow(context, shipment),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentRow(BuildContext context, ShipmentBriefModel shipment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kargo No: ${shipment.shipmentNumber}',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            if (shipment.trackingNumber != null &&
                shipment.trackingNumber!.isNotEmpty)
              Text(
                'Takip No: ${shipment.trackingNumber}',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
          ],
        ),
        if (shipment.shippedDate != null)
          _buildInfoRow(
            context,
            'Kargoya Verilme Tarihi',
            shipment.shippedDate!.formattedDateTime,
          ),
        if (shipment.deliveryDate != null)
          _buildInfoRow(
            context,
            'Teslim Tarihi',
            shipment.deliveryDate!.formattedDateTime,
          ),
        _buildActionButton('Detay', () async {
          await ref
              .read(orderDetailControllerProvider(widget.orderId).notifier)
              .shipmentDetails(shipment.id!);
        }, ActionButtonType.secondary),
        const Divider(),
      ],
    );
  }

  Widget _buildOrderNotesSection(OrderDetailsModel order) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SeparatedRow(
                children: [
                  SvgPicture.asset(
                    notesIcon,
                    height: context.textTheme.titleMedium?.fontSize ?? 12,
                    colorFilter: ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Sipariş Notları',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
                separatorBuilder: () => const Gap(8),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...order.orderNotes!.map((note) => _buildOrderNoteRow(context, note)),
        ],
      ),
    );
  }

  Widget _buildOrderNoteRow(BuildContext context, OrderNote note) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              note.createdOn!.formattedDateTime,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            if (note.hasDownload ?? false)
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () {
                  // Handle download action
                },
              ),
          ],
        ),
        Text(
          note.note ?? '',
          style: context.textTheme.bodySmall?.copyWith(
            color:
                getIt<ThemeController>().isDarkMode
                    ? colorGrey300
                    : colorGrey700,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
