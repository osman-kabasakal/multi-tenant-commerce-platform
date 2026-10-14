import 'package:flextras/flextras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

/// A button that shows a circular progress indicator when the [onPressed] callback
/// is pending.
class AppFilledButton extends HookWidget {
  const AppFilledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loaderColor,
  });

  final AsyncCallback? onPressed;
  final String label;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    // Choose contrasting loader color - white is usually best against colored buttons
    final defaultLoaderColor = Colors.white;

    final (
      :pending,
      :snapshot,
      hasError: _,
      :loaderStrokeWidth,
      loaderColor: _,
    ) = useAsyncTask(loaderColor: loaderColor ?? defaultLoaderColor);

    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    return FilledButton(
      onPressed:
          onPressed == null
              ? null
              : isLoading
              ? null
              : () => pending.value = onPressed!(),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: isLoading ? 0.7 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              label,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: themeController.isDarkMode ? Colors.white : colorGrey700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: LayoutBuilder(
                builder: (context, boxCons) {
                  final squareSize =
                      boxCons.hasBoundedHeight
                          ? boxCons.maxHeight * 0.5
                          : boxCons.hasBoundedWidth
                          ? boxCons.maxWidth * 0.3
                          : 20.0;

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
        ],
      ),
    );
  }
}
