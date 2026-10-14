import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/navigator/signup_route_result.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/screens/signup/providers/signup_controller.dart';
import 'package:store_user_app/presentation/screens/signup/widgets/signup_form.dart';
import 'package:store_user_app/presentation/screens/signup/widgets/signup_result_dialog.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

@RoutePage()
class SignupScreen extends HookConsumerWidget {
  final String? returnUrl;
  SignupScreen({
    super.key,
    this.returnUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var controller = ref.watch(signupControllerProvider(returnUrl).notifier);
    var state = ref.watch(signupControllerProvider(returnUrl));
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: state.when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                data: (value) {
                  // Show dialog if registration result is available
                  if (value.showRegistrationResult && value.registrationResultMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) => SignupResultDialog(
                          message: value.registrationResultMessage!,
                          isError: value.registrationResultId == 4,
                          onContinue: () {
                            Navigator.of(dialogContext).pop();
                            controller.goToSignInScreen();
                          },
                        ),
                      );
                    });
                  }
                  
                  return SignupForm(
                    controller: controller,
                    state: value,
                    isDarkMode: themeController.isDarkMode,
                  );
                },
                error: (ex, st) => AppErrorWidget(
                      message: ex.toString(),
                      type: ErrorType.error,
                    ),
                loading: () => Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }

  final BoxDecoration iconBorderStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
          color: getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
          width: 1));
}
