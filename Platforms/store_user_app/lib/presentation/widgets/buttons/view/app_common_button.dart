import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/app_constants.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

class AppCommonButton extends HookConsumerWidget {
  final FutureOr<void> Function()? onPressed;
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final BoxBorder? boxBorder;
  final TextStyle? textStyle;
  const AppCommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.boxBorder,
    this.textStyle,
  });

  factory AppCommonButton.adaptive({
    required String text,
    FutureOr<void> Function()? onPressed,
    double? widthRate,
    double? heightRate,
    double? fontSizeRate,
    Color? bgColor,
    Color? textColor,
    Color? borderColor,
    BoxBorder? boxBorder,
    TextStyle? textStyle,
  }) {
    return AppCommonButton(
      text: text,
      onPressed: onPressed,
      width:
          MediaQuery.of(myAppKey.currentState!.context).size.width *
          (widthRate ?? 0.25),
      height:
          (MediaQuery.of(myAppKey.currentState!.context).size.width *
              (widthRate ?? 0.25)) *
          (heightRate ?? 0.5),
      fontSize:
          ((MediaQuery.of(myAppKey.currentState!.context).size.width *
                  (widthRate ?? 0.25)) *
              (heightRate ?? 0.5)) *
          (fontSizeRate ?? 0.25),
      bgColor: bgColor,
      textColor: textColor,
      borderColor: borderColor,
      boxBorder: boxBorder,
      textStyle: textStyle,
    );
  }

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
    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: height != null ? 0 : 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(30.0),
              color: bgColor ?? colorPrimary,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  // side: BorderSide(color:borderColor ?? Colors.transparent,width: 1 )
                ),
                elevation: 4,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                // minimumSize: Size(width ?? 0, height ?? 0),
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed:
                  onPressed == null
                      ? null
                      : () =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? null
                              : pending.value =
                                  (() async => await onPressed!())(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style:
                        textStyle ??
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor ?? Colors.white,
                          fontFamily: AppTheme.fontFamily,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
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
