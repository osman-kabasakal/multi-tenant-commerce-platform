import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/orders/shipment_details_model/shipment_status_event_model/shipment_status_event_model.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';

class ShipmentTrackingTable extends ConsumerWidget {
  final List<ShipmentStatusEventModel> shipmentStatusEvents;

  const ShipmentTrackingTable({
    super.key,
    required this.shipmentStatusEvents,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Kargo Takip Durumu',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorPrimary,
              fontFamily: 'Urbanist',
            ),
          ),

          const Gap(16),

          // Table
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: getIt<ThemeController>().isDarkMode
                        ? darkPrimary
                        : colorGrey100,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildHeaderCell(context, 'Durum'),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildHeaderCell(context, 'Konum'),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildHeaderCell(context, 'Ülke'),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildHeaderCell(context, 'Tarih'),
                      ),
                    ],
                  ),
                ),

                // Table Body
                ...shipmentStatusEvents
                    .map((event) => _buildEventRow(context, event)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontFamily: 'Urbanist',
        color: getIt<ThemeController>().isDarkMode ? whiteColor : textColor,
      ),
    );
  }

  Widget _buildEventRow(BuildContext context, ShipmentStatusEventModel event) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: getIt<ThemeController>().isDarkMode ? cardDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color:
                getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              event.eventName ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              event.location ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.country ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.date != null ? event.date!.formattedDate : '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
