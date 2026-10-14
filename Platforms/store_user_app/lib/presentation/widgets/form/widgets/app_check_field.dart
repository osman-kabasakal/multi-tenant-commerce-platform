import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_color_box.dart';

class AppCheckField extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final void Function(String fieldName, dynamic value) onChanged;

  final AppFormFieldState state;

  const AppCheckField(
      {super.key,
      required this.field,
      required this.state,
      required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = field.getOptions<dynamic>();

    var valueState = useState(state.value);

    if (options == null || options.isEmpty) {
      // Single checkbox implementation
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(textFieldRadius),
          border: Border.all(
            color:
                getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
          ),
          color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
        ),
        child: ListTile(
          onTap: field.readonly
              ? null
              : () {
                  final newValue = !(valueState.value ?? false);
                  onChanged(field.name, newValue);
                  valueState.value = newValue;
                },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            field.label,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontFamily: AppTheme.fontFamily,
              color:
                  getIt<ThemeController>().isDarkMode ? whiteColor : textColor,
            ),
          ),
          subtitle: field.configurations['description'] != null
              ? Text(
                  field.configurations['description'] as String,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colorGrey500,
                    fontFamily: AppTheme.fontFamily,
                  ),
                )
              : null,
          trailing: Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: valueState.value ?? false,
              onChanged: field.readonly
                  ? null
                  : (bool? value) {
                      onChanged(field.name, value);
                      valueState.value = value;
                    },
              activeColor: colorPrimary,
              checkColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(
                color: getIt<ThemeController>().isDarkMode
                    ? colorGrey500
                    : colorGrey400,
                width: 1.5,
              ),
            ),
          ),
        ),
      );
    } else {
      // Checkbox group implementation
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group label
          if (field.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                field.label + (field.isRequired ? ' *' : ''),
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                  color: getIt<ThemeController>().isDarkMode
                      ? whiteColor
                      : textColor,
                ),
              ),
            ),
          // Checkbox options
          ...options.map((option) => Container(
                margin: const EdgeInsets.only(bottom: 8),
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
                child: ListTile(
                  selected: (valueState.value as List<dynamic>?)
                          ?.contains(option.value) ??
                      false,
                  onTap: option.disabled
                      ? null
                      : () {
                          var checked = !((valueState.value as List<dynamic>?)
                                  ?.contains(option.value) ??
                              false);
                          final currentValues =
                              (valueState.value as List<dynamic>?) ?? [];
                          final newValues = List<dynamic>.from(currentValues);

                          if (checked) {
                            newValues.add(option.value);
                          } else {
                            newValues.remove(option.value);
                          }

                          onChanged(field.name, newValues);
                          valueState.value = newValues;
                        },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    option.label,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTheme.fontFamily,
                      color: option.disabled
                          ? colorGrey500
                          : (getIt<ThemeController>().isDarkMode
                              ? whiteColor
                              : textColor),
                    ),
                  ),
                  enabled: !option.disabled,
                  leading: field.type == FormFieldType.checkboxColor
                      ? SelectableColorBox(
                          valueState: valueState,
                          onChanged: (v) =>
                              _onChangeHandler(v, option.value, valueState),
                          colorSquaresRgb: option.label,
                          selectedDesicion: (v) =>
                              ((valueState.value as List<dynamic>?)
                                      ?.contains(option.value) ??
                                  false),
                        )
                      : null,
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: (valueState.value as List<dynamic>?)
                              ?.contains(option.value) ??
                          false,
                      onChanged: option.disabled
                          ? null
                          : (v) =>
                              _onChangeHandler(v, option.value, valueState),
                      activeColor: colorPrimary,
                      checkColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: getIt<ThemeController>().isDarkMode
                            ? colorGrey500
                            : colorGrey400,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              )),
          // Error message
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

  void _onChangeHandler(
      bool? checked, dynamic value, ValueNotifier<dynamic> valueState) {
    // return;
    final currentValues = (valueState.value as List<dynamic>?) ?? [];
    final newValues = List<dynamic>.from(currentValues);

    if (checked ?? false) {
      newValues.add(value);
    } else {
      newValues.remove(value);
    }

    onChanged(field.name, newValues);
    valueState.value = newValues;
  }
}
