import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_async_waiter_button.dart';

class AppButtonWithIcon extends HookConsumerWidget {
  final String? text;
  final IconData icon;
  final FutureOr<void> Function()? onPressed;
  final ThemeData theme;
  final Color iconDarkColor;
  final Color iconLightColor;
  final Color borderDarkColor;
  final Color borderLightColor;
  final double iconSize;
  final double? width;
  final double? height;

  const AppButtonWithIcon({
    super.key,
    this.text,
    required this.icon,
    required this.onPressed,
    required this.theme,
    this.iconDarkColor = colorSecondary,
    this.iconLightColor = colorPrimary,
    this.borderDarkColor = borderDark,
    this.borderLightColor = borderColor,
    this.iconSize = 24,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:pending, :snapshot, hasError: _, :loaderColor, :loaderStrokeWidth) =
        useAsyncTask();
    var themeController = getIt<ThemeController>();
    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: width ?? double.infinity,
            height: height ?? 60.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(iconSize / 2),
                  // Adjust the border radius as needed
                  side: BorderSide(
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? borderDarkColor
                            : borderLightColor,
                    width: 1,
                  ),
                ),
                elevation: 0,
                padding: EdgeInsets.all(iconSize / 1.8),
                fixedSize: Size(double.infinity, iconSize + (iconSize / 1.8)),
                backgroundColor:
                    getIt<ThemeController>().isDarkMode
                        ? cardDark
                        : Colors.white,
              ),
              onPressed:
                  onPressed == null
                      ? null
                      : snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : () =>
                          pending.value = (() async => await onPressed!())(),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                direction: Axis.horizontal,
                spacing: 0,
                runSpacing: 0,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? iconDarkColor
                            : iconLightColor,
                  ),
                  if (text != null && text!.isNotEmpty) ...[
                    10.width,
                    Text(
                      text!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (snapshot.connectionState == ConnectionState.waiting)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, boxCons) {
                    final squareSize =
                        boxCons.hasBoundedHeight
                            ? boxCons.maxHeight * 0.5
                            : boxCons.hasBoundedWidth
                            ? boxCons.maxWidth * 0.3
                            : 24.0;

                    return SizedBox(
                      width: squareSize,
                      height: squareSize,
                      child: CircularProgressIndicator(
                        strokeWidth: loaderStrokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loaderColor ?? Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
