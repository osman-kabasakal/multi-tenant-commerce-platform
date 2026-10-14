import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

enum AppDialogType { alert, content, loading }

class DialogHelper {
  static final navigatorKey = getIt<AppRouter>().navigatorKey;

  static BuildContext get context => navigatorKey.currentContext!;
  static StackRouter get router => AutoRouter.of(context);

  // Dialog göstermek için temel metod
  static Future<T?> showCustomDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    bool useRootNavigator = false, // Nested dialog desteği için
  }) {
    return showDialog<T>(
      routeSettings: RouteSettings(name: Uuid().v4()),
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator:
          useRootNavigator, // Ana navigator yerine en yakın navigator'ı kullan
      builder:
          (context) => Dialog(
            key: GlobalKey(), // Her dialog için yeni bir key oluştur
            child: dialog,
          ),
    );
  }

  // Basit alert dialog göstermek için
  static Future<bool?> showAlertDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool useRootNavigator = false,
    AppDialogType type = AppDialogType.alert,
  }) {
    var themeController = getIt<ThemeController>();
    return showCustomDialog<bool>(
      useRootNavigator: useRootNavigator,
      dialog: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BaseBottomSheet(
          title: title,
          contentBuilder:
              (ctx) => AppCard(
                child:
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: ctx.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            type == AppDialogType.alert
                                ? app_colors.appRedColor
                                : type == AppDialogType.loading
                                ? app_colors.colorPrimary
                                : (getIt<ThemeController>().isDarkMode
                                    ? app_colors.colorWhite1
                                    : app_colors.textColor),
                      ),
                    ).center(),
              ),
          footerBuilder:
              (fCtx) => Row(
                children: [
                  if (cancelText != null)
                    Expanded(
                      child: AppCommonButton(
                        onPressed: () => router.maybePop(false),
                        text: cancelText,
                        height: 58,
                        bgColor:
                            themeController.isDarkMode
                                ? app_colors.borderDark
                                : app_colors.primaryColor100,
                        textColor:
                            themeController.isDarkMode
                                ? whiteColor
                                : app_colors.colorPrimary,
                      ),
                    ),
                  Expanded(
                    child: AppCommonButton(
                      onPressed: () => router.maybePop(true),
                      text: confirmText ?? 'Tamam',
                      height: 58,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  // Custom içerikli dialog göstermek için
  static Future<T?> showContentDialog<T>({
    required String title,
    required Widget Function(BuildContext) contentBuilder,
    double? width,
    double? height,
    double maxWidthPercentage = 0.8,
    double maxHeightPercentage = 0.7,
    bool useRootNavigator = false,
    Widget Function(BuildContext)? footerBuilder,
  }) {
    return showCustomDialog<T>(
      useRootNavigator: useRootNavigator,
      dialog: BaseBottomSheet(
        width: width,
        height: height,
        maxHeightPercentage: maxHeightPercentage,
        maxWidthPercentage: maxWidthPercentage,
        title: title,
        contentBuilder: contentBuilder,
        footerBuilder: footerBuilder,
      ),
    );
  }

  // Loading dialog göstermek için
  static Future<void> showLoadingDialog({String? message}) {
    return showCustomDialog(
      barrierDismissible: false,
      dialog: PopScope(
        onPopInvokedWithResult: (didPop, result) => false,
        child: AppAnimatedLoadingWidget(),

        // Padding(
        //   padding: const EdgeInsets.all(20),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const CircularProgressIndicator(),
        //       if (message != null) ...[
        //         const SizedBox(height: 16),
        //         Text(message),
        //       ],
        //     ],
        //   ),
        // ),
      ),
    );
  }

  // Dialog kapatmak için
  static void dismissDialog<T>([T? result]) {
    if (router.current.router.canPop()) {
      router.current.router.maybePop(result);
    }
  }
}
