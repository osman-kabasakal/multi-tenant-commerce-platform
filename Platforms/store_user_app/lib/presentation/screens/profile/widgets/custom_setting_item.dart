import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/constants/colors.dart' as appColors;

class CustomSettingItem extends StatelessWidget {
  final String text1;
  final String leadingIcon;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final bool? isSwitchShow;
  final bool? isIconShow;
  final ColorFilter? iconColor;
  final ThemeData theme;
  final ThemeController themeController;
  final Color? textColor;

  const CustomSettingItem(
      {super.key,
      required this.text1,
      this.value,
      this.onChanged,
      this.isSwitchShow,
      this.isIconShow,
      required this.leadingIcon,
      required this.theme,
      required this.themeController,
      this.iconColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    Color textColor1 =
        themeController.isDarkMode ? Colors.white : appColors.textColor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            leadingIcon,
            width: 24,
            height: 24,
            colorFilter: iconColor ??
                ColorFilter.mode(
                    themeController.isDarkMode
                        ? whiteColor
                        : appColors.colorPrimary,
                    BlendMode.srcIn),
          ),
          10.width,
          Expanded(
            child: Text(
              text1,
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor ??
                      textColor1), // Adjust the font size as needed
            ),
          ),
          if (isSwitchShow != null)
            Transform.scale(
              scale: 0.9,
              // Adjust the scale factor to change the size
              child: CupertinoSwitch(
                value: value!,
                onChanged: onChanged, // Adjust the font size as needed
                activeTrackColor: appColors.colorPrimary,
              ),
            ),
          if (isIconShow != null)
            SvgPicture.asset(
              arrowRightIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  themeController.isDarkMode ? whiteColor : appColors.textColor,
                  BlendMode.srcIn),
            )
        ],
      ),
    );
  }
}
