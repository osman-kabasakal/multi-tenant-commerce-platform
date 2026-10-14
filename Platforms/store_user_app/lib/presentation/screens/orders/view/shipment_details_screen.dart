import 'package:auto_route/auto_route.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/orders/shipment_details_model/shipment_details_model.dart';
import 'package:store_user_app/presentation/screens/orders/providers/shipment_details_controller.dart';
import 'package:store_user_app/presentation/screens/orders/widgets/shipmen_products_table.dart';
import 'package:store_user_app/presentation/screens/orders/widgets/shipment_tracking_table.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

import '../widgets/shipment_notes_table.dart';

@RoutePage()
class ShipmentDetailsScreen extends StatefulHookConsumerWidget {
  final String shipmentId;
  const ShipmentDetailsScreen({
    super.key,
    @PathParam('shipmentId') required this.shipmentId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends ConsumerState<ShipmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Gönderi Detayı'),
      body: SafeArea(
        child: LoadComponentWhenVisible(
          onVisible: () async {
            await ref
                .read(
                  shipmentDetailsControllerProvider(widget.shipmentId).notifier,
                )
                .refresh();
          },
          builder:
              (isLoading) => RefreshIndicator(
                onRefresh:
                    () =>
                        ref
                            .read(
                              shipmentDetailsControllerProvider(
                                widget.shipmentId,
                              ).notifier,
                            )
                            .refresh(),
                child: ref
                    .watch(shipmentDetailsControllerProvider(widget.shipmentId))
                    .when(
                      data:
                          (shipmentDetails) =>
                              (shipmentDetails.id != null
                                  ? _buildShipmentDetailsContent(
                                    context,
                                    shipmentDetails,
                                  )
                                  : Center(
                                    child: Text('Gönderi Detayı Bulunamadı'),
                                  )),
                      error:
                          (err, stack) => SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              height: context.height() - 100,
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: AppErrorWidget(
                                  message: err.toString(),
                                  onRetry:
                                      () =>
                                          ref
                                              .read(
                                                shipmentDetailsControllerProvider(
                                                  widget.shipmentId,
                                                ).notifier,
                                              )
                                              .refresh(),
                                ),
                              ),
                            ),
                          ),
                      loading:
                          () => const Center(child: AppAnimatedLoadingWidget()),
                    ),
              ),
        ),
      ),
    );
  }

  Widget _buildShipmentDetailsContent(
    BuildContext context,
    ShipmentDetailsModel shipmentDetails,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: SeparatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separatorBuilder: () => const Gap(16),
        children: [
          // Title
          Center(
            child: Text(
              'Gönderi Bilgileri #${shipmentDetails.shipmentNumber}',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Shipment and Address Details
          _buildShipmentAndAddressDetails(context, shipmentDetails),

          // Products
          if (shipmentDetails.items != null &&
              shipmentDetails.items!.isNotEmpty)
            ShipmentProductsTable(
              shipmentItems: shipmentDetails.items!,
              showSku: shipmentDetails.showSku ?? false,
            ),

          // Shipment Status Events
          if (shipmentDetails.shipmentStatusEvents != null &&
              shipmentDetails.shipmentStatusEvents!.isNotEmpty)
            ShipmentTrackingTable(
              shipmentStatusEvents: shipmentDetails.shipmentStatusEvents!,
            ),

          // Shipment Notes
          if (shipmentDetails.shipmentNotes != null &&
              shipmentDetails.shipmentNotes!.isNotEmpty)
            ShipmentNotesTable(
              shipmentNotes: shipmentDetails.shipmentNotes!,
              onDownloadNote:
                  (noteId) => ref
                      .read(
                        shipmentDetailsControllerProvider(
                          widget.shipmentId,
                        ).notifier,
                      )
                      .shipmentNoteFileDownload(noteId),
            ),
        ],
      ),
    );
  }

  Widget _buildShipmentAndAddressDetails(
    BuildContext context,
    ShipmentDetailsModel shipmentDetails,
  ) {
    return AppCard(
      child: SeparatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separatorBuilder: () => const Gap(16),
        children: [
          // Row with two columns
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Desktop/tablet layout (two columns)
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildShipmentDetails(context, shipmentDetails),
                    ),
                    const Gap(16),
                    Expanded(
                      child: _buildAddressDetails(context, shipmentDetails),
                    ),
                  ],
                );
              } else {
                // Mobile layout (stacked)
                return SeparatedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  separatorBuilder: () => const Gap(16),
                  children: [
                    _buildShipmentDetails(context, shipmentDetails),
                    _buildAddressDetails(context, shipmentDetails),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentDetails(
    BuildContext context,
    ShipmentDetailsModel shipmentDetails,
  ) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () => const Gap(8),
      children: [
        // Title with link to order details
        GestureDetector(
          onTap: () {
            if (shipmentDetails.order?.id != null) {
              context.router.navigateNamed(
                '/orders/details/${shipmentDetails.order!.id}',
              );
            }
          },
          child: Text(
            'Sipariş #${shipmentDetails.order?.orderNumber}',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),

        // Shipping Method
        _buildInfoRow(
          context,
          'Kargo Yöntemi:',
          shipmentDetails.order?.shippingMethod ?? '',
        ),

        // Shipped Date
        _buildInfoRow(
          context,
          'Kargolanma Tarihi:',
          shipmentDetails.shippedDate != null
              ? shipmentDetails.shippedDate!.formattedDate
              : 'Henüz Kargolanmadı',
        ),

        // Delivery Date
        _buildInfoRow(
          context,
          'Teslim Tarihi:',
          shipmentDetails.deliveryDate != null
              ? shipmentDetails.deliveryDate!.formattedDate
              : 'Henüz Teslim Edilmedi',
        ),

        // Tracking Number
        if (shipmentDetails.trackingNumber != null &&
            shipmentDetails.trackingNumber!.isNotEmpty)
          _buildTrackingNumberRow(context, shipmentDetails),
      ],
    );
  }

  Widget _buildAddressDetails(
    BuildContext context,
    ShipmentDetailsModel shipmentDetails,
  ) {
    final isPickupInStore = shipmentDetails.order?.pickUpInStore ?? false;
    final address =
        isPickupInStore
            ? shipmentDetails.order?.pickupAddress
            : shipmentDetails.order?.shippingAddress;

    if (address == null) return const SizedBox.shrink();

    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () => const Gap(8),
      children: [
        // Title
        Text(
          isPickupInStore ? 'Teslimat Noktası Adresi' : 'Kargo Adresi',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorPrimary,
            fontFamily: AppTheme.fontFamily,
          ),
        ),

        if (!isPickupInStore) ...[
          // Name
          Text(
            '${address.firstName ?? ''} ${address.lastName ?? ''}',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.fontFamily,
            ),
          ),

          // Email
          _buildInfoRow(context, 'E-posta:', address.email ?? ''),

          // Phone
          if (address.phoneEnabled == true)
            _buildInfoRow(context, 'Telefon:', address.phoneNumber ?? ''),

          // Fax
          if (address.faxEnabled == true)
            _buildInfoRow(context, 'Faks:', address.faxNumber ?? ''),

          // Company
          if (address.company != null && address.company!.isNotEmpty)
            Text(
              address.company!,
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: AppTheme.fontFamily,
              ),
            ),
        ],

        // Address Lines
        Text(
          address.address1 ?? '',
          style: context.textTheme.bodyMedium?.copyWith(
            fontFamily: AppTheme.fontFamily,
          ),
        ),

        if (address.address2 != null && address.address2!.isNotEmpty)
          Text(
            address.address2!,
            style: context.textTheme.bodyMedium?.copyWith(
              fontFamily: AppTheme.fontFamily,
            ),
          ),

        // City, State, Zip
        Text(
          '${address.city ?? ''}, ${address.stateProvinceName ?? ''} ${address.zipPostalCode ?? ''}',
          style: context.textTheme.bodyMedium?.copyWith(
            fontFamily: AppTheme.fontFamily,
          ),
        ),

        // Country
        if (address.countryName != null && address.countryName!.isNotEmpty)
          Text(
            address.countryName!,
            style: context.textTheme.bodyMedium?.copyWith(
              fontFamily: AppTheme.fontFamily,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color:
                getIt<ThemeController>().isDarkMode
                    ? colorGrey300
                    : colorGrey700,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const Gap(4),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingNumberRow(
    BuildContext context,
    ShipmentDetailsModel shipmentDetails,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Takip Numarası:',
          style: context.textTheme.bodyMedium?.copyWith(
            color:
                getIt<ThemeController>().isDarkMode
                    ? colorGrey300
                    : colorGrey700,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const Gap(4),
        Expanded(
          child:
              shipmentDetails.trackingNumberUrl != null &&
                      shipmentDetails.trackingNumberUrl!.isNotEmpty
                  ? GestureDetector(
                    onTap: () async {
                      // final url = Uri.parse(shipmentDetails.trackingNumberUrl!);
                      // if (await canLaunchUrl(url)) {
                      //   await launchUrl(url, mode: LaunchMode.externalApplication);
                      // }
                    },
                    child: Text(
                      shipmentDetails.trackingNumber!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorPrimary,
                        decoration: TextDecoration.underline,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  )
                  : Text(
                    shipmentDetails.trackingNumber!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
        ),
      ],
    );
  }
}
