import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

class AppIconButton extends HookConsumerWidget {
  final Color iconDarkColor;
  final Color iconLightColor;
  final Widget icon;
  final FutureOr<void> Function()? onPressed;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconDarkColor = colorSecondary,
    this.iconLightColor = colorPrimary,
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
    final themeController = getIt<ThemeController>();
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        Blur(
          blur: snapshot.connectionState == ConnectionState.waiting ? 50 : 0,
          elevation:
              snapshot.connectionState == ConnectionState.waiting ? 5 : 0,
          child: IconButton(
            color: themeController.isDarkMode ? iconDarkColor : iconLightColor,
            icon: icon,
            onPressed:
                () =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : pending.value = (() async => await onPressed!())(),
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
                            ? getIndicatorColor(colorWhite1)
                            : getIndicatorColor(colorPrimary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Color getIndicatorColor(Color backgroundColor) {
    final Color contrastColor = Color.fromARGB(
      backgroundColor.alpha,
      255 - backgroundColor.red,
      255 - backgroundColor.green,
      255 - backgroundColor.blue,
    );

    final double backgroundLuminance = backgroundColor.computeLuminance();
    final Color indicatorColor =
        backgroundLuminance > 0.5
            ? contrastColor.withValues(
              alpha: 0.8,
            ) // Açık arkaplan için koyu renk
            : Colors.white.withValues(alpha: 0.8);
    return indicatorColor;
  }
}
