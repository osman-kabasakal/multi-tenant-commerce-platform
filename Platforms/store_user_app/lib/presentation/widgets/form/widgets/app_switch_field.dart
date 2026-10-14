import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

class AppSwitchField extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final FocusNode? focusNode;
  final void Function(String fieldName, dynamic value) onChanged;
  final AppFormFieldState state;

  const AppSwitchField(
      {super.key,
      required this.field,
      required this.state,
      required this.onChanged,
      this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var valueState = useState<bool?>(state.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container for the entire switch row
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Label and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main label
                      Text(
                        field.label,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: '',
                          color: getIt<ThemeController>().isDarkMode
                              ? whiteColor
                              : textColor,
                        ),
                      ),
                      // Optional description from field configuration
                      if (field.configurations['description'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            field.configurations['description'] as String,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: colorGrey500,
                              fontFamily: '',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Right side - Custom Switch
                Transform.scale(
                  scale: 0.8, // Slightly smaller scale to match design
                  child: Switch(
                    focusNode: focusNode,
                    value: valueState.value ?? false,
                    onChanged: field.readonly
                        ? null
                        : (bool value) {
                            onChanged(field.name, value);
                            valueState.value = value;
                          },
                    activeColor: colorPrimary,
                    activeTrackColor: primaryColor200,
                    inactiveThumbColor: whiteColor,
                    inactiveTrackColor: getIt<ThemeController>().isDarkMode
                        ? colorGrey700
                        : colorGrey300,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Error message if any
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
