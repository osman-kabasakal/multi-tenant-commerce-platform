import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

class AppTextFormField extends HookConsumerWidget {
  final FocusNode? focusNode;
  final void Function(String)? fieldSubmitted;
  final void Function(String)? fieldChanged;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final double? lefContentPadding;

  final String? prefixIcon;
  final IconData? prefixIconData;
  final String? suffixIcon;
  final IconData? suffixIconData;

  final bool? obscureText;

  final int? lines;

  final bool? enabled;

  const AppTextFormField({
    super.key,
    this.focusNode,
    this.fieldSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.fieldChanged,
    this.controller,
    this.hintText,
    this.labelText,
    this.lefContentPadding,
    this.prefixIcon,
    this.prefixIconData,
    this.suffixIcon,
    this.suffixIconData,
    this.inputFormatters,
    this.lines,
    this.obscureText = false,
    this.enabled,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = getIt<ThemeController>().isDarkMode;
    return TextFormField(
      style: context.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color:
        !isDarkMode ? textColor : whiteColor, // Set your desired text color
      ),
      onTapOutside: (event) {
        if (focusNode != null) {
          focusNode?.unfocus();
        }
      },

      enabled: enabled,
      maxLines: lines ?? 1,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.none,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      onFieldSubmitted: (v) {
        focusNode?.unfocus();
        fieldSubmitted?.call(v);
      },
      validator: validator,
      onChanged: fieldChanged,
      controller: controller,
      obscureText: obscureText ?? false,
      autovalidateMode:
      focusNode?.hasFocus ?? false
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      decoration: inputDecoration(
        context,
        leftContentPadding: lefContentPadding,
        prefixIconColor: colorGrey500,
        // inputBorderColor: isDarkMode ? cardDark : colorGrey50,
        fillColor: isDarkMode ? cardDark : colorWhite1,
        hintColor:
        isDarkMode
            ? whiteColor.withValues(alpha: 0.60)
            : textColor.withValues(alpha: 0.60),
        borderRadius: textFieldRadius,
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconData: prefixIconData,
        suffixIcon: suffixIcon,
        suffixIconData: suffixIconData,
        labelText: labelText,
      ),
    );
  }
}
