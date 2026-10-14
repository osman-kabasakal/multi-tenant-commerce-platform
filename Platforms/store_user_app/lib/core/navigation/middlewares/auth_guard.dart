import 'package:auto_route/auto_route.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';

enum AccessPolicy { allowGuest, onlyRegisteredUser, onlyGuest }

class AuthGuard extends AutoRouteGuard {
  late final AuthService authRepository;
  final AccessPolicy policy;
  final String? returnUrl;

  AuthGuard({required this.policy, this.returnUrl}) {
    authRepository = getIt<AuthService>();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuthenticated = await authRepository.isAuthenticated();
    if (!isAuthenticated) {
      resolver.redirectUntil(SigninRoute(returnUrl: returnUrl));
      return;
    }
    var tokens = await authRepository.getAccessToken();
    if (tokens == null) {
      await Future.delayed(const Duration(seconds: 1));
      tokens = await authRepository.getAccessToken();
      if (tokens == null) {
        resolver.redirectUntil(SigninRoute(returnUrl: returnUrl));
        return;
      }
    }

    switch (policy) {
      case AccessPolicy.allowGuest:
        resolver.next(true);
        return;
      case AccessPolicy.onlyRegisteredUser:
        if (tokens.isGuest) {
          resolver.redirectUntil(SigninRoute(returnUrl: returnUrl));
          return;
        }
        break;
      case AccessPolicy.onlyGuest:
        if (!tokens.isGuest) {
          resolver.redirectUntil(const HomeRoute());
          return;
        }
        break;
    }
    resolver.next(true);
  }
}
