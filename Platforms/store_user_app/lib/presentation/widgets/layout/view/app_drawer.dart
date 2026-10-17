import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends HookConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    var getFooterModelFunc = useMemoized(() async {
      return await (await getIt.getAsync<ComponentRepository>()).getFooter();
    });
    var footerModelSnap = useFuture(getFooterModelFunc);
    return Drawer(
      backgroundColor: isDarkMode ? darkPrimary : whiteColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              decoration: BoxDecoration(
                color: isDarkMode ? cardDark : colorGrey50,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? borderDark : borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  OptimizedCacheImage(
                    imageUrl: AppConfig.instance.storeLogo,
                    errorWidget: Center(
                      child: Text(
                        AppConfig.instance.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    fit: BoxFit.fitHeight,
                    sizeConfig: const ImageSizeConfig(
                      width: double.infinity,
                      height: 60,
                    ),
                    placeholder: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorGrey100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: profileBottomIcon,
                    title: 'Hakkımızda',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      context.router.push(
                        PageScreenRoute(pageSystemName: 'AboutUs'),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: phoneIcon,
                    title: 'İletişim',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      context.router.push(
                        PageScreenRoute(pageSystemName: 'ContactUs'),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: lockCircleIcon,
                    title: 'Gizlilik Politikası',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      context.router.push(
                        PageScreenRoute(
                          pageSystemName: 'GizlilikBilgilendirmesi',
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: vehicleIcon,
                    title: 'Teslimat ve İade',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      context.router.push(
                        PageScreenRoute(pageSystemName: 'NewShippinginfo'),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? borderDark : borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (footerModelSnap.hasData) ...[
                        if (footerModelSnap.data!.facebookLink != null &&
                            footerModelSnap.data!.facebookLink!.isNotEmpty)
                          IconButton(
                            icon: SvgPicture.asset(
                              fbPrimaryIcon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? whiteColor : colorGrey600,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed:
                                () => _launchSocialMedia(
                                  footerModelSnap.data!.facebookLink!,
                                ),
                          ),
                        if (footerModelSnap.data!.instagramLink != null &&
                            footerModelSnap.data!.instagramLink!.isNotEmpty)
                          IconButton(
                            icon: SvgPicture.asset(
                              instagramIcon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? whiteColor : colorGrey600,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed:
                                () => _launchSocialMedia(
                                  footerModelSnap.data!.instagramLink!,
                                ),
                          ),
                        if (footerModelSnap.data!.twitterLink != null &&
                            footerModelSnap.data!.twitterLink!.isNotEmpty)
                          IconButton(
                            icon: SvgPicture.asset(
                              twitterIcon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? whiteColor : colorGrey600,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed:
                                () => _launchSocialMedia(
                                  footerModelSnap.data!.twitterLink!,
                                ),
                          ),
                      ],
                      if (!footerModelSnap.hasData) ...[Text("...")],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String icon,
    required String title,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isDarkMode ? whiteColor : textColor,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: context.theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDarkMode ? colorGrey600 : colorGrey500,
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchSocialMedia(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
