import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/orders/shipment_details_model/shipment_note/shipment_note.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';

class ShipmentNotesTable extends ConsumerWidget {
  final List<ShipmentNote> shipmentNotes;
  final Function(String noteId) onDownloadNote;

  const ShipmentNotesTable({
    super.key,
    required this.shipmentNotes,
    required this.onDownloadNote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Gönderi Notları',
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
                        child: _buildHeaderCell(context, 'Oluşturulma Tarihi'),
                      ),
                      Expanded(
                        flex: 7,
                        child: _buildHeaderCell(context, 'Not'),
                      ),
                    ],
                  ),
                ),

                // Table Body
                ...shipmentNotes.map((note) => _buildNoteRow(context, note)),
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

  Widget _buildNoteRow(BuildContext context, ShipmentNote note) {
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
          // Created Date
          Expanded(
            flex: 3,
            child: Text(
              note.createdOn != null ? note.createdOn!.formattedDateTime : '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Urbanist',
              ),
            ),
          ),

          // Note Content
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Note text
                Text(
                  note.note?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                      '', // Remove HTML tags
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Urbanist',
                  ),
                ),

                // Download button if available
                if (note.hasDownload == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (note.id != null) {
                          onDownloadNote(note.id!);
                        }
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Dosyayı İndir'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: colorPrimary,
                        backgroundColor: getIt<ThemeController>().isDarkMode
                            ? darkPrimary
                            : primaryColor100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        textStyle: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
