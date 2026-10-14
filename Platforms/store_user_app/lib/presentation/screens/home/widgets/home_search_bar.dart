import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

class HomeSearchBar extends HookConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final focusNode = useFocusNode();

    final theme = getIt<ThemeController>().isDarkMode
        ? AppTheme.foodDarkTheme
        : AppTheme.foodLightTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          context.router.push(SearchRoute());
        },
        child: AbsorbPointer(
          child: TextFormField(
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:
                  getIt<ThemeController>().isDarkMode ? whiteColor : textColor,
            ),
            controller: searchController,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              hintText: whatAreYouCraving,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: getIt<ThemeController>().isDarkMode
                    ? whiteColor.withValues(alpha: 0.60)
                    : textColor.withValues(alpha: 0.60),
                fontWeight: FontWeight.w400,
                fontFamily: AppTheme.fontFamily,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: SvgPicture.asset(
                  searchIcon,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    colorGrey500,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              filled: true,
              fillColor:
                  getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(textFieldRadius),
                borderSide: BorderSide(
                  color: getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(textFieldRadius),
                borderSide: BorderSide(
                  color: getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : borderColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
