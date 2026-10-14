import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/remote_cache.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/middlewares/onboarding_guard.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/presentation/screens/pages/Views/page_screen.dart';

import 'app_router.gr.dart';
import 'middlewares/auth_guard.dart';
import 'middlewares/connectivity_guard.dart';

@Singleton(dependsOn: [RemoteCache])
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRouteGuard> get guards => [
    ConnectivityGuard(getIt<ConnectivityMonitor>()),
  ];

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/welcome',
      page: WelcomeRoute.page,
      initial: false,
      keepHistory: false,
    ),
    AutoRoute(
      path: '/not-found',
      page: NotFoundRoute.page,
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      page: WalkThroughRoute.page,
      path: '/walk-through',
      guards: [OnboardingGuard()],
    ),
    AutoRoute(
      page: WelcomeSiginRoute.page,
      path: '/welcome-signin',
      guards: [OnboardingGuard()],
    ),
    AutoRoute(
      path: '/',
      page: ScaffoldWithBottomNavbar.page,
      initial: true,
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
      children: [
        RedirectRoute(path: '', redirectTo: 'home'),
        AutoRoute(
          path: 'home',
          page: HomeRoute.page,
          guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
          children: [
            RedirectRoute(path: '', redirectTo: 'index'),
            AutoRoute(
              page: HomeIndexRoute.page,
              path: 'index',
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),
            AutoRoute(page: SearchResultRoute.page, path: 'search-result'),
            AutoRoute(
              path: 'category/:categoryId',
              page: CategoryRoute.page,
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),

            AutoRoute(
              path: 'brand/:brandId',
              page: BrandRoute.page,
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),

            AutoRoute(
              path: 'collection/:collectionId',
              page: CollectionRoute.page,
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),

            AutoRoute(
              path: 'vendor/:vendorId',
              page: VendorRoute.page,
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),
          ],
        ),
        AutoRoute(
          path: 'profile',
          page: ProfileRoute.page,
          guards: [
            AuthGuard(
              policy: AccessPolicy.onlyRegisteredUser,
              returnUrl: '/profile',
            ),
          ],
          children: [
            RedirectRoute(path: '', redirectTo: 'index'),
            AutoRoute(page: ProfileIndexRoute.page, path: 'index'),
            AutoRoute(
              page: AccountInfoRoute.page,
              path: 'account-info',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'account-info',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerAddressesRoute.page,
              path: 'customer-addresses',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-addresses',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerOrdersRoute.page,
              path: 'customer-orders',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-orders',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerCoursesRoute.page,
              path: 'customer-courses',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-courses',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerAuctionsRoute.page,
              path: 'customer-auctions',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-auctions',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerNotesRoute.page,
              path: 'customer-notes',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-notes',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerDocumentsRoute.page,
              path: 'customer-documents',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-documents',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerMerchandiseReturnRoute.page,
              path: 'customer-merchandise-return',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-merchandise-return',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerDownloadableProductsRoute.page,
              path: 'customer-downloadbale-products',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-downloadbale-products',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerOutOfStockSubscriptionsRoute.page,
              path: 'customer-out-of-stock-subscriptions',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-out-of-stock-subscriptions',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerLoyaltyPointsRoute.page,
              path: 'customer-loyalty-points',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-loyalty-points',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerChangePasswordRoute.page,
              path: 'customer-change-password',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-change-password',
                ),
              ],
            ),
            AutoRoute(
              page: CustomerReviewsRoute.page,
              path: 'customer-reviews',
              guards: [
                AuthGuard(
                  policy: AccessPolicy.onlyRegisteredUser,
                  returnUrl: 'customer-reviews',
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          path: 'orders',
          page: OrdersRoute.page,
          children: [
            RedirectRoute(path: '', redirectTo: 'index'),
            AutoRoute(
              page: OrdersIndexRoute.page,
              path: 'index',
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),
            AutoRoute(
              page: OrdersDetailRoute.page,
              path: 'orders-details/:orderId',
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),
            AutoRoute(
              page: ShipmentDetailsRoute.page,
              path: 'orders-shipments-detail/:shipmentId',
              guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
            ),
          ],
          guards: [
            AuthGuard(
              policy: AccessPolicy.onlyRegisteredUser,
              returnUrl: '/orders',
            ),
          ],
        ),
        AutoRoute(page: WishlistRoute.page, path: 'wishlist', type: RouteType.material()),
      ],
    ),
    AutoRoute(
      page: PageScreenRoute.page,
      path: '/page/:pageSystemName',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      page: MerchandiseReturnRoute.page,
      path: '/orders/merchandise-return/:orderId',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      path: '/merchandise-return-details/:merchandiseReturnId',
      page: MerchandiseReturnDetailsRoute.page,
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(page: CartRoute.page, path: '/shopping-cart'),
    AutoRoute(
      page: CheckoutRoute.page,
      path: '/checkout',
      guards: [
        AuthGuard(policy: AccessPolicy.allowGuest, returnUrl: '/checkout'),
      ],
    ),
    AutoRoute(
      page: ProductRoute.page,
      path: '/product/:productId',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      path: '/search',
      page: SearchRoute.page,
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      page: SigninRoute.page,
      path: '/signin',
      guards: [AuthGuard(policy: AccessPolicy.onlyGuest)],
    ),
    AutoRoute(
      page: SignupRoute.page,
      path: '/signup',
      guards: [AuthGuard(policy: AccessPolicy.onlyGuest)],
    ),
    AutoRoute(
      page: NotificationsRoute.page,
      path: '/notifications',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      page: NotificationDetailRoute.page,
      path: '/notification-detail/:notificationId',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
    AutoRoute(
      page: AccountActivationRoute.page,
      path: '/account/activation',
      guards: [AuthGuard(policy: AccessPolicy.allowGuest)],
    ),
  ];
}
