import 'package:flutter/widgets.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/navigation/middlewares/auth_guard.dart';
import 'package:store_user_app/core/navigation/tabs_guards/navigation_gard.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';

class AuthNavigationGuard implements NavigationGuard {
  final AccessPolicy policy;
  final String? returnUrl;
  AuthNavigationGuard(this.policy, this.returnUrl);
  @override
  Future<bool> canNavigate(BuildContext context) async {
    var authService = getIt<AuthService>();
    final isAuthenticated = await authService.isAuthenticated();
    final isGuest = await authService.isGuest();

    switch (policy) {
      case AccessPolicy.allowGuest:
        return true;
      case AccessPolicy.onlyRegisteredUser:
        if (isAuthenticated && !isGuest) return true;

        if (isGuest) {
          getIt<AppRouter>().push(
            SigninRoute(returnUrl: returnUrl),
          );
          return false;
        }
        return false;
      default:
        return true;
    }
  }
}
