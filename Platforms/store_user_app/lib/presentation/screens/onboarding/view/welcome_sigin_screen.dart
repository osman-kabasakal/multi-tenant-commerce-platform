import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/usecases/page_blocks/page_blocks_use_case.dart';
import 'package:store_user_app/presentation/screens/onboarding/providers/welcom_signin_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/either_or.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_button_with_icon.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

import '../../../widgets/app/widgets/app_widget.dart';
import '../../../widgets/buttons/view/app_common_button.dart';

@RoutePage()
class WelcomeSiginScreen extends HookConsumerWidget {
  const WelcomeSiginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(welcomSigninControllerProvider.notifier);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ref
                  .watch(getHomePageTextProvider)
                  .when(
                    data:
                        (data) => Text(
                          data?.title ?? '',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 32,
                              ),
                        ),
                    error: (er, stack) => SizedBox.shrink(),
                    loading:
                        () => Skeleton(
                          isLoading: true,
                          skeleton: SkeletonLine(),
                          child: Center(child: Text('...')),
                        ),
                  ),
              20.height,
              Image.asset(
                getIt<ThemeController>().isDarkMode
                    ? welcomeSignInDark
                    : welcomeSignIn,
                width: 237,
                height: 180,
              ),
              10.height,
              ref
                  .watch(getHomePageTextProvider)
                  .when(
                    data: (v) => Html(data: v?.body ?? ''),
                    error: (er, stack) => SizedBox.shrink(),
                    loading:
                        () => Skeleton(
                          isLoading: true,
                          skeleton: SkeletonLine(),
                          child: Center(child: Text('...')),
                        ),
                  ),
              20.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: AppCommonButton(
                  onPressed: () async {
                    await controller.goToSignInScreen();
                  },
                  text: signWithEmail,
                ),
              ),
              15.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AppButtonWithIcon(
                  icon: Icons.person_add_alt,
                  onPressed: () async {
                    await controller.goToSignupScreen();
                  },
                  text: signup,
                  theme: context.theme,
                ),
              ),
              15.height,
              EitherOr(
                orText: dontKnowWhatToDo,
                isDarkMode: controller.isDarkMode,
              ),
              TextButton(
                onPressed: () async {
                  await controller.goToHome();
                },
                child: Text(
                  signUpWithSpace,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorPrimary,
                  ),
                ),
              ).center(),
              12.height,
            ],
          ),
        ),
      ),
    );
  }
}
