import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/form/field_option.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_color_box.dart';

class AppRadioListTile extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final void Function(String fieldName, dynamic value) onChanged;
  final AppFormFieldState state;

  const AppRadioListTile({
    super.key,
    required this.field,
    required this.state,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = field.getOptions<dynamic>();
    if (options == null || options.isEmpty) return const SizedBox();

    if (field.type == FormFieldType.radioColor) {
      return ColorSquaresRadioGroupWidget(
        field: field,
        options: options,
        state: state,
        onChanged: onChanged,
      );
    }

    return DefaultRadioGroupWidget(
      field: field,
      options: options,
      state: state,
      onChanged: onChanged,
    );
  }
}

class DefaultRadioGroupWidget extends HookConsumerWidget {
  const DefaultRadioGroupWidget({
    super.key,
    required this.field,
    required this.options,
    required this.state,
    required this.onChanged,
  });

  final IFormField field;
  final List<FieldOption> options;
  final AppFormFieldState state;
  final void Function(String fieldName, dynamic value) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueState = useState(state.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the radio group
        if (field.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              field.label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
                color:
                    getIt<ThemeController>().isDarkMode
                        ? whiteColor
                        : textColor,
              ),
            ),
          ),
        // Radio tiles
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(textFieldRadius),
                border: Border.all(
                  color:
                      getIt<ThemeController>().isDarkMode
                          ? borderDark
                          : borderColor,
                  width: 1,
                ),
                color:
                    getIt<ThemeController>().isDarkMode
                        ? cardDark
                        : colorGrey50,
              ),
              child: RadioListTile<dynamic>(
                value: option.value,
                groupValue: valueState.value,
                title: Text(
                  option.label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontFamily,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? whiteColor
                            : textColor,
                  ),
                ),
                activeColor: colorPrimary,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return colorGrey400;
                  }
                  return colorPrimary;
                }),
                selected: valueState.value == option.value,
                onChanged:
                    option.disabled
                        ? null
                        : (value) {
                          onChanged(field.name, value);
                          valueState.value = value;
                        },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(textFieldRadius),
                ),
              ),
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

class ColorSquaresRadioGroupWidget extends HookConsumerWidget {
  const ColorSquaresRadioGroupWidget({
    super.key,
    required this.field,
    required this.options,
    required this.state,
    required this.onChanged,
  });

  final IFormField field;
  final List<FieldOption> options;
  final AppFormFieldState state;
  final void Function(String fieldName, dynamic value) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueState = useState(state.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label for the radio group
        if (field.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              field.label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
                color:
                    getIt<ThemeController>().isDarkMode
                        ? whiteColor
                        : textColor,
              ),
            ),
          ),
        Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children:
              options
                  .map(
                    (option) => SelectableColorBox(
                      valueState: valueState,
                      onChanged: (selected) {
                        onChanged(field.name, option.value);
                        valueState.value = option.value;
                      },
                      selected: option.selected,
                      value: option.value,
                      colorSquaresRgb: option.label,
                      disabled: option.disabled,
                      selectedDesicion: (optionValue) {
                        return valueState.value == optionValue ||
                            (valueState.value == null && option.selected);
                      },
                    ),
                  )
                  .toList(),
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
