import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/screens/signin/providers/signin_screen_controller.dart';
import 'package:store_user_app/presentation/screens/signin/widgets/signin_form.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

@RoutePage()
class SigninScreen extends HookConsumerWidget {
  final String? returnUrl;
  const SigninScreen({super.key, this.returnUrl});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var controller = ref.watch(
      signinScreenControllerProvider(returnUrl).notifier,
    );
    var state = ref.watch(signinScreenControllerProvider(returnUrl));
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Handle pop
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: fdCommonAppBarWidget(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: state.when(
                data:
                    (value) => SigninForm(
                      controller: controller,
                      state: value,
                      isDarkMode: themeController.isDarkMode,
                    ),
                error:
                    (ex, st) => AppErrorWidget(
                      message: ex.toString(),
                      type: ErrorType.error,
                    ),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
