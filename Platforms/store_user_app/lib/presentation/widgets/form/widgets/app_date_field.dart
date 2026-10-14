import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

class AppDateField extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final void Function(String fieldName, dynamic value) onChanged;
  final AppFormFieldState state;

  const AppDateField(
      {super.key,
      required this.field,
      required this.state,
      required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var valueState = useState(state.value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create a custom date field that matches the project's style
        InkWell(
          onTap: () async {
            // Don't show picker if field is readonly
            if (field.readonly) return;

            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: valueState.value ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              locale: const Locale('tr', 'TR'),
              builder: (BuildContext context, Widget? child) {
                // Customize the date picker to match project theme
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: colorPrimary,
                      onPrimary: getIt<ThemeController>().isDarkMode
                          ? whiteColor
                          : Colors.white,
                      surface: getIt<ThemeController>().isDarkMode
                          ? cardDark
                          : Colors.white,
                      onSurface: getIt<ThemeController>().isDarkMode
                          ? whiteColor
                          : textColor,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: colorPrimary,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    dialogTheme: DialogThemeData(
                        backgroundColor: getIt<ThemeController>().isDarkMode
                            ? darkPrimary
                            : Colors.white),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              onChanged(field.name, picked);
              valueState.value = picked;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //label
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
                  color: getIt<ThemeController>().isDarkMode
                      ? cardDark
                      : colorGrey50,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          // Calendar Icon
                          SvgPicture.asset(
                            calendarIcon,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              colorGrey500,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Date Display
                          Expanded(
                            child: Text(
                              valueState.value != null
                                  ? DateFormat('dd.MMM.yyyy', 'tr_TR')
                                      .format(valueState.value)
                                  : field.label,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: state.value != null
                                    ? (getIt<ThemeController>().isDarkMode
                                        ? whiteColor
                                        : textColor)
                                    : colorGrey500,
                                fontWeight: state.value != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ),
                          // Right arrow icon
                          if (!field.readonly)
                            SvgPicture.asset(
                              arrowRightIcon,
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                colorGrey500,
                                BlendMode.srcIn,
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
        ),
        // Error message display
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
