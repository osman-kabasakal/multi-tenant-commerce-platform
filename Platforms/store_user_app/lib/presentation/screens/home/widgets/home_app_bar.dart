import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/screens/home/providers/home_controller.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class HomeAppBar extends StatefulHookConsumerWidget
    implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  var theme =
      getIt<ThemeController>().isDarkMode
          ? AppTheme.foodDarkTheme
          : AppTheme.foodLightTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white,
      child: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? cardDark
                            : colorGrey50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.menu,
                    size: 20,
                    color:
                        getIt<ThemeController>().isDarkMode
                            ? whiteColor
                            : textColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Handle profile tap
                  },
                  child: SizedBox(
                    height: 32,
                    child:
                        AppConfig.instance.storeLogo.isEmpty
                            ? const Center(
                              child: Text(
                                'Commerce Demo',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                            : OptimizedCacheImage(
                              imageUrl: AppConfig.instance.storeLogo,
                              errorWidget: Center(
                                child: Text(
                                  AppConfig.instance.appTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              fit: BoxFit.fitHeight,
                              sizeConfig: ImageSizeConfig(
                                height: 32,
                                width: 32,
                              ),
                              placeholder: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: colorGrey100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       deliverTo,
              //       style: theme.textTheme.bodyMedium?.copyWith(
              //         color: colorGrey600,
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //     Row(
              //       children: [
              //         Text(
              //           'Current Location',
              //           style: theme.textTheme.bodyLarge?.copyWith(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(width: 4),
              //         SvgPicture.asset(
              //           dropDownIcon,
              //           colorFilter: ColorFilter.mode(
              //             getIt<ThemeController>().isDarkMode
              //                 ? Colors.white
              //                 : colorGrey600,
              //             BlendMode.srcIn,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  Consumer(
                    builder: (consumeContext, ref, child) {
                      return ref
                          .watch(homeControllerProvider)
                          .when(
                            data:
                                (data) => _buildIconButton(
                                  context,
                                  icon:
                                      getIt<ThemeController>().isDarkMode
                                          ? notificationDarkIcon
                                          : notificationLightIcon,
                                  onTap: () {
                                    context.router.push(
                                      const NotificationsRoute(),
                                    );
                                  },
                                  isActive: data.hasMessages,
                                ),
                            loading:
                                () => _buildIconButton(
                                  context,
                                  icon:
                                      getIt<ThemeController>().isDarkMode
                                          ? notificationDarkIcon
                                          : notificationLightIcon,
                                  onTap: () {
                                    context.router.push(
                                      const NotificationsRoute(),
                                    );
                                  },
                                ),
                            error:
                                (error, stack) => _buildIconButton(
                                  context,
                                  icon:
                                      getIt<ThemeController>().isDarkMode
                                          ? notificationDarkIcon
                                          : notificationLightIcon,
                                  onTap: () {
                                    context.router.push(
                                      const NotificationsRoute(),
                                    );
                                  },
                                ),
                          );

                      // return _buildIconButton(
                      //   context,
                      //   icon: getIt<ThemeController>().isDarkMode
                      //       ? notificationDarkIcon
                      //       : notificationLightIcon,
                      //   onTap: () {
                      //     context.router.push(const NotificationsRoute());
                      //   },
                      //   isActive: homeProvider.,
                      // );
                    },
                  ),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (consumeContext, ref, child) {
                      var cartState = ref.watch(shoppingCartUseCaseProvider);
                      return cartState.when(
                        data: (value) {
                          return _buildIconButton(
                            context,
                            icon:
                                getIt<ThemeController>().isDarkMode
                                    ? cartDarkIcon
                                    : cartLightIcon,
                            onTap: () {
                              context.router.push(CartRoute());
                            },
                            isActive: value.cart?.items?.isNotEmpty ?? false,
                          );
                        },
                        loading:
                            () => _buildIconButton(
                              context,
                              icon:
                                  getIt<ThemeController>().isDarkMode
                                      ? cartDarkIcon
                                      : cartLightIcon,
                              onTap: () {
                                context.router.push(CartRoute());
                              },
                            ),
                        error:
                            (error, stack) => _buildIconButton(
                              context,
                              icon:
                                  getIt<ThemeController>().isDarkMode
                                      ? cartDarkIcon
                                      : cartLightIcon,
                              onTap: () {
                                // Handle cart tap
                              },
                            ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required String icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            colorFilter:
                !isActive
                    ? ColorFilter.mode(
                      getIt<ThemeController>().isDarkMode
                          ? Colors.white
                          : colorGrey500,
                      BlendMode.srcIn,
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
