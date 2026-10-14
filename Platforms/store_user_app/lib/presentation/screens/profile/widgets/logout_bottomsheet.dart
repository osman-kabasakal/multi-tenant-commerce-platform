import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';

class LogoutBottomSheet extends StatelessWidget {
  final ThemeData theme;

  const LogoutBottomSheet({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    var themeController = getIt<ThemeController>();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            logout,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: app_colors.appRedColor,
            ),
          ),
          15.height,
          Divider(
            color:
                themeController.isDarkMode
                    ? app_colors.borderDark
                    : app_colors.borderColor,
            height: 1,
            thickness: 1,
          ),
          15.height,
          Text(
            'Çıkmak istediğinze emin misiniz?',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  themeController.isDarkMode
                      ? app_colors.colorGrey300
                      : app_colors.colorGrey800,
            ),
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppCommonButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: cancel,
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
              15.width,
              Expanded(
                child: AppCommonButton(
                  onPressed: () async {
                    var authService = getIt<AuthService>();

                    if (context.mounted) {
                      context.router.popUntil(
                        (route) => route.settings.name == HomeRoute.name,
                        scoped: false,
                      );
                      await authService.logout();
                      await authService.guestLogin();
                      getIt<AppRouter>().replacePath(AppPaths.homeIndex());
                    }
                  },
                  text: yesLogout,
                  height: 58,
                ),
              ),
            ],
          ),
          if (context.isIOS) 20.height,
        ],
      ),
    );
  }
}
