import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/list_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/delete_account_model/delete_account_model.dart';
import 'package:store_user_app/presentation/screens/profile/providers/profile_controller.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/custom_setting_item.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/delete_account_bottom_sheet.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/profile_app_bar.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/user_card.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';

import '../widgets/logout_bottomsheet.dart';

@RoutePage()
class ProfileIndexScreen extends ConsumerWidget {
  const ProfileIndexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var profileNavigationModel = ref.watch(profileControllerProvider);
    var themeController = getIt<ThemeController>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppBar(),
      ),
      body: profileNavigationModel.when(
        data: (data) {
          if (data.error != null) {
            return AppErrorWidget(message: data.error!, type: ErrorType.info);
          }
          return Column(
            // spacing: 20,
            // Changed from Wrap to Column
            children: [
              //user card
              UserCard(customer: data.customerInfo),
              Divider(
                color:
                themeController.isDarkMode
                    ? app_colors.borderDark
                    : app_colors.borderColor,
                height: 1,
                thickness: 1,
              ),
              10.height,
              Expanded(
                // Added Expanded to wrap the SingleChildScrollView
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Addresses
                      if (!(data.customerNavigation.hideAddresses ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-addresses',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Adreslerim',
                            leadingIcon: addressIcon,
                            themeController: themeController,
                          ),
                        ),

                      //Orders
                      if (!(data.customerNavigation.hideOrders ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-orders',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Geçmiş Siparişlerim',
                            leadingIcon: orderIcon,
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideCourses ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-courses',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Kurslarım',
                            leadingIcon: onlineCourses, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideAuctions ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-auctions',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Müzayedelerim',
                            leadingIcon: auctionIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),
                      if (!(data.customerNavigation.hideNotes ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed('/profile/customer-notes');
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Notlarım',
                            leadingIcon: notesIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),
                      if (!(data.customerNavigation.hideDocuments ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-documents',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Belgelerim',
                            leadingIcon: documentsIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideMerchandiseReturns ??
                          false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-merchandise-return',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'İade İşlemlerim',
                            leadingIcon: merchandiseReturnIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideDownloadableProducts ??
                          false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-downloadable-products',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'İndirilebilir Ürünlerim',
                            leadingIcon:
                            downloadablePrductsIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data
                          .customerNavigation
                          .hideOutOfStockSubscriptions ??
                          false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-out-of-stock-subscriptions',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Stok Aboneliklerim',
                            leadingIcon:
                            outOfStockSubscriptionIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideLoyaltyPoints ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-loyalty-points',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Puanlarım',
                            leadingIcon: loyalityPointsIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      if (!(data.customerNavigation.hideChangePassword ??
                          false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-change-password',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Şifremi Değiştir',
                            leadingIcon: changePasswordIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),
                      if (!(data.customerNavigation.hideDeleteAccount ?? false))
                        InkWell(
                          onTap: () async {
                            var modalResponse =
                            await showModalBottomSheet<DeleteAccountModel>(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteAccountBottomSheet();
                              },
                            );
                            if (modalResponse == null) {
                              return;
                            }
                            await ref
                                .read(profileControllerProvider.notifier)
                                .deleteAccount(modalResponse.password!);
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Hesabımı Sil',
                            leadingIcon: deleteAccountIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),
                      if (!(data.customerNavigation.hideReviews ?? false))
                        InkWell(
                          onTap: () {
                            context.router.pushNamed(
                              '/profile/customer-reviews',
                            );
                          },
                          child: CustomSettingItem(
                            theme: context.theme,
                            isIconShow: true,
                            text1: 'Yorumlarım',
                            leadingIcon: reviewsIcon, // Changed icon
                            themeController: themeController,
                          ),
                        ),

                      // if (!(data.customerNavigation.hideSubAccounts ?? false))
                      //   InkWell(
                      //     onTap: () {
                      //       context.router.push(CustomerOrdersRoute());
                      //     },
                      //     child: CustomSettingItem(
                      //       theme: context.theme,
                      //       isIconShow: true,
                      //       text1: 'Alt Hesaplarım',
                      //       leadingIcon: subAccountIcon, // Changed icon
                      //       themeController: themeController,
                      //     ),
                      //   ),
                    ].joinBySperatedWidget(10.height),
                  ),
                ),
              ),
              10.height,
              Divider(
                color:
                themeController.isDarkMode
                    ? app_colors.borderDark
                    : app_colors.borderColor,
                height: 1,
                thickness: 1,
              ),
              10.height,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutBottomSheet(theme: context.theme);
                    },
                  );
                },
                child: CustomSettingItem(
                  theme: context.theme,
                  isIconShow: true,
                  text1: logout,
                  textColor: app_colors.appRedColor,
                  leadingIcon: logoutIcon,
                  themeController: themeController,
                  iconColor: const ColorFilter.mode(
                    app_colors.appRedColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              10.height,
            ],
          );
        },
        loading: () {
          return Container();
        },
        error: (error, _) {
          return Container();
        },
      ),
    );
  }
}
