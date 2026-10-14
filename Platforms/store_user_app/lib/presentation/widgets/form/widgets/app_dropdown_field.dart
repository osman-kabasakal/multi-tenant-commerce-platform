import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_text_form_field.dart';

class AppDropdownField extends HookConsumerWidget {
  final IFormField<dynamic> field;
  final void Function(String fieldName, dynamic value) onChanged;
  final AppFormFieldState state;

  const AppDropdownField({
    super.key,
    required this.field,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = field.getOptions<dynamic>();
    if (options == null || options.isEmpty) return const SizedBox();

    // Determine if we should show search functionality based on configuration
    final bool isSearchable = field.configurations['searchable'] == true;
    final searchController = useTextEditingController();
    final isDropdownOpen = useState(false);
    final filteredOptions = useState(options);
    var defaultValue =
        options.any((o) => o.value == state.value)
            ? state.value
            : options.where((o) => o.selected).firstOrNull?.value;

    final valueState = useState(defaultValue);

    // Filter function for search
    void filterOptions(String query) {
      filteredOptions.value =
          options
              .where(
                (option) =>
                    option.label.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown label
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

        // Custom Dropdown Container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(textFieldRadius),
            border: Border.all(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
            ),
            color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
          ),
          child: Theme(
            // Override default dropdown styling
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<dynamic>(
                isExpanded: true,
                hint: Text(
                  field.configurations['hintText'] ?? field.label ?? '',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: colorGrey500,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                items:
                    filteredOptions.value
                        .map(
                          (option) => DropdownMenuItem<dynamic>(
                            value: option.value,
                            enabled: !option.disabled,
                            child: Text(
                              option.label,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color:
                                    option.disabled
                                        ? colorGrey500
                                        : (getIt<ThemeController>().isDarkMode
                                            ? whiteColor
                                            : textColor),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                value: valueState.value,
                onChanged:
                    field.readonly
                        ? null
                        : (value) {
                          onChanged(field.name, value);
                          if (isSearchable) {
                            searchController.clear();
                            filterOptions('');
                          }
                          valueState.value = value;
                        },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(textFieldRadius),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: SvgPicture.asset(
                    isDropdownOpen.value ? upIcon : downIcon,
                    colorFilter: ColorFilter.mode(
                      colorGrey500,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(textFieldRadius),
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : whiteColor,
                    border: Border.all(
                      color:
                          getIt<ThemeController>().isDarkMode
                              ? borderDark
                              : borderColor,
                    ),
                  ),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(8),
                    thickness: WidgetStateProperty.all(4),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                  offset: const Offset(0, -4),
                ),
                // Search functionality
                dropdownSearchData: DropdownSearchData(
                  searchController: isSearchable ? searchController : null,
                  searchInnerWidget:
                      isSearchable
                          ? Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: AppTextFormField(
                              controller: searchController,
                              hintText: search,
                              prefixIcon: searchIcon,
                              fieldChanged: filterOptions,
                            ),
                          )
                          : null,
                ),
                onMenuStateChange: (isOpen) {
                  isDropdownOpen.value = isOpen;
                  if (!isOpen && isSearchable) {
                    searchController.clear();
                    filterOptions('');
                  }
                },
              ),
            ),
          ),
        ),

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
