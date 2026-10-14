import 'package:auto_route/auto_route.dart';
import 'package:store_user_app/core/cache/remote_cache.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';

class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var remoteCache = getIt<RemoteCache>();
    remoteCache.get<bool>('skipBoarding').then((value) {
      if (value == true) {
        router.push(HomeRoute());
      } else {
        resolver.next(true);
      }
    });
  }
}
