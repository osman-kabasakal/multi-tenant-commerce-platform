import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/document/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final Function(String) onDownload;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? cardDark : colorGrey50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? borderDark : borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            document.number ?? '',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : textColor,
                            ),
                          ),
                          if (document.status != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '(${document.status})',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDarkMode ? colorGrey300 : colorGrey700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                // Dates
                if (document.docDate != null || document.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (document.docDate != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isDarkMode ? colorGrey500 : colorGrey600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MM/dd/yyyy').format(document.docDate!),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDarkMode ? colorGrey400 : colorGrey700,
                            ),
                          ),
                        ],
                        if (document.docDate != null &&
                            document.dueDate != null)
                          const SizedBox(width: 16),
                        if (document.dueDate != null) ...[
                          Icon(
                            Icons.event_available,
                            size: 14,
                            color: isDarkMode ? colorGrey500 : colorGrey600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MM/dd/yyyy').format(document.dueDate!),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDarkMode ? colorGrey400 : colorGrey700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Description
          if (document.description != null && document.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                document.description!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),

          // Download button
          if (document.downloadId != null && document.downloadId!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? borderDark : borderColor,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Ek:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? colorGrey300 : colorGrey700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onDownload(document.id ?? ''),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          downloadIcon,
                          height: 16,
                          width: 16,
                          colorFilter: ColorFilter.mode(
                            colorPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'İndir',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: colorPrimary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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
