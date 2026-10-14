import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';

/// A widget that handles the back button press to redirect to home/index
/// when the current route is not home/index and back button would normally
/// exit the app.
class AppBackButtonHandler extends StatefulWidget {
  final Widget child;

  const AppBackButtonHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<AppBackButtonHandler> createState() => _AppBackButtonHandlerState();
}

class _AppBackButtonHandlerState extends State<AppBackButtonHandler> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult:
          (isPop, result) => _handleBackButton(isPop, result, context),
      child: widget.child,
    );
  }

  late bool _canPop = false;

  Future<void> _handleBackButton(
    bool isPop,
    Object? result,
    BuildContext context,
  ) async {
    if (isPop) {
      return;
    }
    var approuter = getIt<AppRouter>();

    final StackRouter router = approuter.root;
    print("Back button pressed - current path: ${router.topPage?.name}");

    // Check if we're at the root route where back would normally exit the app
    final bool isRootRoute = router.canPop() == false;

    // Check if we're on the home/index page
    final bool isAtHomeIndex = router.topPage?.name == HomeIndexRoute.name;

    print("isRootRoute: $isRootRoute, isAtHomeIndex: $isAtHomeIndex");

    if (isRootRoute && !isAtHomeIndex) {
      // If we're at a root route but not at home/index, navigate to home/index
      print("Navigating to home/index");
      context.router.navigate(HomeRoute(children: [HomeIndexRoute()]));
      _canPop = true;
    } else if (isRootRoute && isAtHomeIndex) {
      // If we're at home/index, allow app exit (normal back button behavior)
      print("At home/index, allowing app exit");
      // We can't directly exit the app, so we'll use SystemNavigator
      SystemNavigator.pop();
      _canPop = true;
    } else {
      // If we're not at a root route, just let the default pop happen
      print("Not at root route, allowing normal back navigation");
      context.router.removeLast();
      _canPop = true;
    }
  }
}
