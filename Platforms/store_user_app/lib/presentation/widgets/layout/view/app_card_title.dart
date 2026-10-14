import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';

class AppCardTitle extends HookConsumerWidget {
  final String? svgIcon;
  final IconData? iconData;
  final Color? iconColor;
  final Color? darkIconColor;
  final String title;
  final Color titleColor;
  final Color darkTitleColor;
  final bool hasDivider;
  final Color dividerColor;
  final Color dividerDarkColor;

  final double dividerHeight;

  const AppCardTitle({
    super.key,
    required this.title,
    required this.titleColor,
    required this.darkTitleColor,
    required this.hasDivider,
    required this.dividerColor,
    required this.dividerDarkColor,
    required this.dividerHeight,
    this.iconData,
    this.svgIcon,
    this.iconColor,
    this.darkIconColor,
  });

  factory AppCardTitle.warning({
    Key? key,
    required String title,
    required bool hasDivider,
    IconData? iconData,
    String? svgIcon,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: colorSecondary,
      hasDivider: hasDivider,
      dividerColor: colorSecondary,
      dividerHeight: 1,
      iconData: iconData,
      svgIcon: svgIcon,
      iconColor: colorSecondary,
      darkIconColor: colorSecondary,
      darkTitleColor: colorSecondary,
      dividerDarkColor: colorSecondary,
    );
  }

  factory AppCardTitle.error({
    Key? key,
    required String title,
    required bool hasDivider,
    IconData? iconData,
    String? svgIcon,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: appRedColor,
      hasDivider: hasDivider,
      dividerColor: appRedColor,
      dividerHeight: 1,
      iconData: iconData,
      svgIcon: svgIcon,
      iconColor: appRedColor,
      darkIconColor: appRedColor,
      darkTitleColor: appRedColor,
      dividerDarkColor: appRedColor,
    );
  }

  factory AppCardTitle.active({
    Key? key,
    required String title,
    required bool hasDivider,
    IconData? iconData,
    String? svgIcon,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: colorPrimary,
      hasDivider: hasDivider,
      dividerColor: colorPrimary,
      dividerHeight: 1,
      iconData: iconData,
      svgIcon: svgIcon,
      iconColor: colorPrimary,
      darkIconColor: colorPrimary,
      darkTitleColor: colorPrimary,
      dividerDarkColor: colorPrimary,
    );
  }

  factory AppCardTitle.primary({
    Key? key,
    required String title,
    required bool hasDivider,
    IconData? iconData,
    String? svgIcon,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: AppTheme.foodLightTheme.textTheme.titleSmall!.color!,
      darkTitleColor: AppTheme.foodDarkTheme.textTheme.titleSmall!.color!,
      hasDivider: hasDivider,
      dividerColor: AppTheme.foodLightTheme.dividerColor,
      dividerDarkColor: AppTheme.foodDarkTheme.dividerColor,
      dividerHeight: 1,
      iconData: iconData,
      svgIcon: svgIcon,
      iconColor: AppTheme.foodLightTheme.iconTheme.color,
    );
  }

  factory AppCardTitle.withSvgIcon({
    Key? key,
    required String title,
    required Color titleColor,
    required Color darkTitleColor,
    required bool hasDivider,
    required Color dividerColor,
    required Color dividerDarkColor,
    required double dividerHeight,
    required String svgIcon,
    required Color iconColor,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: titleColor,
      darkTitleColor: darkTitleColor,
      hasDivider: hasDivider,
      dividerColor: dividerColor,
      dividerDarkColor: dividerDarkColor,
      dividerHeight: dividerHeight,
      svgIcon: svgIcon,
      iconColor: iconColor,
    );
  }

  factory AppCardTitle.withIcon({
    Key? key,
    required String title,
    required Color titleColor,
    required Color darkTitleColor,
    required bool hasDivider,
    required Color dividerColor,
    required Color dividerDarkColor,
    required double dividerHeight,
    required IconData iconData,
    required Color iconColor,
  }) {
    return AppCardTitle(
      title: title,
      titleColor: titleColor,
      darkTitleColor: darkTitleColor,
      hasDivider: hasDivider,
      dividerColor: dividerColor,
      dividerDarkColor: dividerDarkColor,
      dividerHeight: dividerHeight,
      iconData: iconData,
      iconColor: iconColor,
    );
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgIcon != null)
              _buildSvgIcon(context.textTheme.titleMedium!.fontSize!),
            if (iconData != null)
              Icon(
                iconData,
                color: getIt<ThemeController>().isDarkMode
                    ? darkIconColor ?? darkTitleColor
                    : iconColor ?? titleColor,
                size: context.textTheme.titleMedium!.fontSize,
              ),
            Flexible(
              flex: 1,
              child: Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  color: getIt<ThemeController>().isDarkMode
                      ? darkTitleColor
                      : titleColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.fontFamily,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ),
          ],
        ),
        if (hasDivider)
          Divider(
            height: dividerHeight,
            color: getIt<ThemeController>().isDarkMode
                ? dividerDarkColor
                : dividerColor,
          ),
      ],
    );
  }

  Widget _buildSvgIcon(double iconSize) {
    return SvgPicture.asset(
      svgIcon!,
      height: iconSize, //context.textTheme.titleMedium?.fontSize ?? 12,
      colorFilter: ColorFilter.mode(
          getIt<ThemeController>().isDarkMode
              ? darkIconColor ?? cardDark
              : iconColor!,
          BlendMode.srcIn),
    );
  }
}
