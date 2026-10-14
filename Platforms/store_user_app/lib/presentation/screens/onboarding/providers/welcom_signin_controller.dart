import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/navigator/signup_route_result.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';

part 'welcom_signin_controller.g.dart';

@riverpod
class WelcomSigninController extends _$WelcomSigninController {
  late AppRouter _appRouter;
  late ThemeController themeController;
  late bool isDarkMode;
  late CacheManager _cache;

  @override
  void build() {
    _appRouter = getIt<AppRouter>();
    themeController = getIt<ThemeController>();
    _cache = getIt<CacheManager>();

    isDarkMode = themeController.isDarkMode;
    return;
  }

  Future<void> goToSignupScreen() async {
    var sigUpResult = await _appRouter.push<SignupRouteResult>(SignupRoute());
    if (sigUpResult == null) return;
    switch (sigUpResult) {
      case SignupRouteResult.success:
        await goToHome();
        break;
      case SignupRouteResult.failure:
        break;
      case SignupRouteResult.cancel:
        break;
      case SignupRouteResult.redirectToLogin:
        await goToSignInScreen();
        break;
    }
  }

  bool isNavigated = false;
  Future<void> goToSignInScreen() async {
    var signInResult = await _appRouter.push<SigninRouteResult>(SigninRoute());
    if (signInResult == null) return;
    switch (signInResult) {
      case SigninRouteResult.success:
        await goToHome();
        break;
      case SigninRouteResult.failure:
        break;
      case SigninRouteResult.cancel:
        break;
      case SigninRouteResult.redirectToSignup:
        await goToSignupScreen();
        break;
      case SigninRouteResult.continueAsGuest:
        await goToHome();
        break;
    }
  }

  Future<void> goToHome() async {
    if (isNavigated) return;
    isNavigated = true;
    await _cache.setAsyncWithTime<bool>(
      'skipBoarding',
      () async => true,
      Duration(days: 360 * 2),
    );
    _appRouter.popUntilRouteWithPath(AppPaths.welcome());
    await _appRouter.replacePath('/');
  }
}
