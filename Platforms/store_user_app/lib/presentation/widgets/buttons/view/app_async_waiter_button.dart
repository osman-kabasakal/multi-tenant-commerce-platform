import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

class AppAsyncWaiterButton extends HookConsumerWidget {
  final FutureOr<void> Function()? onPressed;
  final Widget child;
  final Color? loaderColor;

  const AppAsyncWaiterButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.loaderColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();

    // Use the provided loader color or default to white for dark mode, or a contrasting color for light mode
    final defaultLoaderColor =
        themeController.isDarkMode ? Colors.white : Colors.white;

    final (
      :pending,
      :snapshot,
      hasError: _,
      loaderColor: _,
      :loaderStrokeWidth,
    ) = useAsyncTask(loaderColor: loaderColor ?? defaultLoaderColor);

    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    return GestureDetector(
      onTap:
          () =>
              isLoading
                  ? null
                  : pending.value = (() async => await onPressed!())(),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: isLoading ? 0.7 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
          if (isLoading)
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
                            loaderColor ?? defaultLoaderColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
