import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_note/customer_note.dart';
import 'package:store_user_app/presentation/screens/profile/providers/customer_notes_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

import '../../../../../core/services/theme/theme_controller.dart';
import '../../../../../core/constants/colors.dart' as app_colors;

@RoutePage()
class CustomerNotesScreen extends HookConsumerWidget {
  const CustomerNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(customerNotesControllerProvider);
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Notlarım',
        isback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notlarım',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: notesAsyncValue.when(
                data: (data) {
                  if (data.customerNoteList == null ||
                      data.customerNoteList!.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Henüz hiç notunuz yok.',
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(customerNotesControllerProvider.notifier)
                        .refreshNotes(),
                    child: ListView.builder(
                      itemCount: data.customerNoteList!.length,
                      itemBuilder: (context, index) {
                        final note = data.customerNoteList![index];
                        return _buildNoteCard(
                            context, note, themeController, ref);
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: AppErrorWidget(
                    message:
                        'Notlarınız yüklenirken bir hata oluştu: ${error.toString()}',
                    type: ErrorType.error,
                    onRetry: () => ref.refresh(customerNotesControllerProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    CustomerNote note,
    ThemeController themeController,
    WidgetRef ref,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: themeController.isDarkMode
              ? app_colors.borderDark
              : app_colors.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with title
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? app_colors.cardDark
                  : app_colors.colorGrey50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(
                  color: themeController.isDarkMode
                      ? app_colors.borderDark
                      : app_colors.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title ?? '',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Oluşturulma Tarihi:',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: themeController.isDarkMode
                            ? app_colors.colorGrey300
                            : app_colors.colorGrey500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: app_colors.colorPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      note.createdOn != null
                          ? DateFormat('dd.MM.yyyy').format(note.createdOn!)
                          : '',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: themeController.isDarkMode
                            ? app_colors.colorGrey300
                            : app_colors.colorGrey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card body with note content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              note.note ?? '',
              style: context.textTheme.bodyMedium,
            ),
          ),

          // Card footer with attachment if available
          if (note.downloadId != null && note.downloadId!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: themeController.isDarkMode
                        ? app_colors.borderDark
                        : app_colors.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Ek:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(customerNotesControllerProvider.notifier)
                          .downloadAttachment(note.noteId ?? '');
                    },
                    child: Text(
                      'İndir',
                      style: TextStyle(
                        color: app_colors.colorPrimary,
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
