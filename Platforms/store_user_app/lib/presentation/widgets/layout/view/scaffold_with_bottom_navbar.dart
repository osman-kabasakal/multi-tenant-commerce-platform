import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/navigation/middlewares/auth_guard.dart';
import 'package:store_user_app/core/navigation/tabs_guards/auth_navigation_guard.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_back_button_handler.dart';

import '../../../../core/constants/colors.dart';


@RoutePage()
class ScaffoldWithBottomNavbar extends HookConsumerWidget {
  ScaffoldWithBottomNavbar({super.key});
  final routes = [HomeRoute(), OrdersRoute(), WishlistRoute(), ProfileRoute()];

  final guards = [
    AuthNavigationGuard(AccessPolicy.allowGuest, '/home'),
    AuthNavigationGuard(AccessPolicy.allowGuest, '/orders'),
    AuthNavigationGuard(AccessPolicy.allowGuest, '/wishlist'),
    AuthNavigationGuard(AccessPolicy.onlyRegisteredUser, '/profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackButtonHandler(
      child: AutoTabsScaffold(
        lazyLoad: true,
        routes: routes,
        bottomNavigationBuilder: (context, tabsRouter) {
          return _buildBottomNavigationBar(context, tabsRouter);
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context,
      TabsRouter navigationShell,
      ) {
    return BottomNavigationBar(
      selectedItemColor: colorPrimary,
      unselectedItemColor: colorGrey500,
      backgroundColor:
      getIt<ThemeController>().isDarkMode
          ? darkPrimary.withValues(alpha: 0.85)
          : Colors.white,
      type: BottomNavigationBarType.fixed,
      // selectedIconTheme: ,
      currentIndex: navigationShell.activeIndex,
      onTap: (index) => _handleTabChange(index, context),
      items: [
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(homeActiveIcon),
          icon: SvgPicture.asset(homeIcon),
          label: home,
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(orderActiveIcon),
          icon: SvgPicture.asset(orderIcon),
          label: orders,
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.favorite),
          icon: Icon(Icons.favorite_border),
          label: 'Favorilerim',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(profileActiveIcon),
          icon: SvgPicture.asset(profileBottomIcon),
          label: profile,
        ),
        // Add more items as needed
      ],
    );
  }

  void _handleTabChange(int index, BuildContext context) async {
    var connectivityMonitor = getIt.get<ConnectivityMonitor>();
    if (connectivityMonitor.connectionStatus.value.contains(
      ConnectivityResult.none,
    )) {
      toasty(context, 'İnternet bağlantınızı kontrol edin');
      return;
    }
    var tabsRouter = AutoTabsRouter.of(context);
    final guard = guards[index];
    final canNavigate = await guard.canNavigate(context);

    if (canNavigate) {
      tabsRouter.setActiveIndex(index);
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Android'de indirme dizini için izin gerekebilir (Android 10+ için storage izni gerekli değil)
      if (await _checkStoragePermission()) {
        return await getExternalStorageDirectory();
      } else {
        return null;
      }
    } else if (Platform.isIOS) {
      // iOS'ta Documents klasörü izin gerektirmez
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<bool> _checkStoragePermission() async {
    // Android 10 (API 29) ve üzeri için dosya sistemi izni gerekmez
    if (Platform.isAndroid) {
      var (release, sdk) = await _getAndroidVersion();
      if (release >= 10 || sdk >= 29) {
        return true;
      }
      if (await Permission.storage.status != PermissionStatus.granted) {
        // İzin yok, izin iste
        if (await Permission.storage.request() != PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<(int release, int sdk)> _getAndroidVersion() async {
    if (!Platform.isAndroid) return (0, 0);
    var deviceInfo = await DeviceInfoPlugin().androidInfo;
    var release = deviceInfo.version.release;
    var sdkInt = deviceInfo.version.sdkInt;
    return (int.parse(release), sdkInt);
  }
}
