import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

class AppFileField extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final void Function(String fieldName, dynamic value) onChanged;
  final AppFormFieldState state;
  final Future<String> Function(String, File?)? onFileSelected;

  const AppFileField({
    super.key,
    required this.field,
    required this.state,
    required this.onChanged,
    this.onFileSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final selectedFilePath = useState<String?>(null);
    final downloadGuid = useState<String?>(null);

    Future<void> initializeExistingFile(
        String guid, Function(String) onFileLoaded) async {
      try {
        isLoading.value = true;
        final directory = await getApplicationCacheDirectory();
        final files = directory.listSync();

        String? filePath = files
            .where((f) =>
                path.withoutExtension(f.path).split(path.separator).last ==
                guid)
            .firstOrNull
            ?.absolute
            .path;

        if (filePath != null) {
          onFileLoaded(filePath);
        } else {
          var downloadRepo = await getIt.getAsync<DioFileService>();
          var remoteFileResponse = await downloadRepo
              .get('/Download/GetFileUpload?downloadId=$guid');
          final file = File(
              '${directory.path}/$guid${remoteFileResponse.fileExtension}');

          // Base64 decode and save
          final bytes = base64Decode(
              base64Encode(await remoteFileResponse.content.first));
          await file.writeAsBytes(bytes);
          onFileLoaded(
              '${directory.path}/$guid${remoteFileResponse.fileExtension}');
        }
      } catch (e) {
        _showError(context, 'Dosya yüklenirken bir hata oluştu: $e');
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      if (state.value != null) {
        initializeExistingFile(state.value, (filePath) {
          selectedFilePath.value = filePath;
          downloadGuid.value = state.value;
        });
      }
      return null;
    }, []);

    Future<void> pickFile() async {
      if (field.readonly) return;

      try {
        isLoading.value = true;
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          dialogTitle: field.label,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          final file = File(result.files.first.path!);
          if (onFileSelected != null) {
            try {
              final guid = await onFileSelected!(field.name, file);
              if (guid.isEmptyOrNull) return;
              downloadGuid.value = guid;
              selectedFilePath.value = file.path;
              onChanged(field.name, guid);
            } catch (e) {
              if (context.mounted) {
                _showError(context, 'Dosya yüklenirken bir hata oluştu: $e');
              }
            }
          } else {
            selectedFilePath.value = file.path;
            onChanged(field.name, file.path);
          }
        }
      } catch (e) {
        if (context.mounted) {
          _showError(context, 'Dosya seçilirken bir hata oluştu: $e');
        }
      } finally {
        isLoading.value = false;
      }
    }

    void clearFile() {
      if (field.readonly) return;

      isLoading.value = true;
      if (onFileSelected != null) {
        onFileSelected!(field.name, null).then((_) {
          selectedFilePath.value = null;
          downloadGuid.value = null;
          onChanged(field.name, null);
          isLoading.value = false;
        });
      } else {
        selectedFilePath.value = null;
        downloadGuid.value = null;
        onChanged(field.name, null);
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              field.label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
                color: getIt<ThemeController>().isDarkMode
                    ? whiteColor
                    : textColor,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(textFieldRadius),
            border: Border.all(
              color: getIt<ThemeController>().isDarkMode
                  ? borderDark
                  : borderColor,
            ),
            color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
          ),
          child: isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: selectedFilePath.value != null
                            ? InkWell(
                                onTap: field.readonly ? null : clearFile,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      documentsIcon,
                                      width: 24,
                                      height: 24,
                                      colorFilter: ColorFilter.mode(
                                        colorGrey500,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        path.basename(selectedFilePath.value!),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontFamily: AppTheme.fontFamily,
                                          color: getIt<ThemeController>()
                                                  .isDarkMode
                                              ? whiteColor
                                              : textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : OutlinedButton.icon(
                                onPressed: field.readonly ? null : pickFile,
                                icon: SvgPicture.asset(
                                  uploadIcon,
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    colorPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: Text(
                                  'Dosya Seç',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: colorPrimary,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: colorPrimary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                      ),
                      if (selectedFilePath.value != null &&
                          !field.readonly) ...[
                        const SizedBox(width: 12),
                        IconButton(
                          icon: SvgPicture.asset(
                            cancelIcon,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              appRedColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: clearFile,
                        ),
                      ],
                    ],
                  ),
                ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              state.error!,
              style: context.textTheme.bodySmall?.copyWith(
                color: appRedColor,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ),
      ],
    );
  }
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: whiteColor,
          fontFamily: AppTheme.fontFamily,
        ),
      ),
      backgroundColor: appRedColor,
    ),
  );
}
