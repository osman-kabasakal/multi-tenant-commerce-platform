import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

class AppCustomButtonWithIcon extends HookConsumerWidget {
  final String text;
  final String icon;
  final FutureOr<void> Function()? onPressed;
  final ThemeData theme;
  const AppCustomButtonWithIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.theme,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      :pending,
      :snapshot,
      hasError: _,
      loaderColor: _,
      loaderStrokeWidth: _,
    ) = useAsyncTask();
    var themeController = getIt<ThemeController>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // Adjust the border radius as needed
          side: BorderSide(
            color:
                getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
            width: 1,
          ),
        ),
        elevation: 0,
        padding: const EdgeInsets.all(20),
        backgroundColor:
            getIt<ThemeController>().isDarkMode ? cardDark : Colors.white,
      ),
      onPressed:
          onPressed == null
              ? null
              : snapshot.connectionState == ConnectionState.waiting
              ? null
              : () => pending.value = (() async => await onPressed!())(),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          Blur(
            blur: snapshot.connectionState == ConnectionState.waiting ? 50 : 0,
            elevation:
                snapshot.connectionState == ConnectionState.waiting ? 5 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon, width: 24, height: 24),
                10.width,
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (snapshot.connectionState == ConnectionState.waiting)
            Positioned.fill(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, boxCons) {
                    var squareSize =
                        boxCons.hasBoundedHeight
                            ? boxCons.maxHeight * 0.5
                            : boxCons.hasBoundedWidth
                            ? boxCons.maxWidth
                            : boxCons.smallest.aspectRatio;
                    return SizedBox(
                      width: squareSize,
                      height: squareSize,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          themeController.isDarkMode
                              ? colorWhite1
                              : colorPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
