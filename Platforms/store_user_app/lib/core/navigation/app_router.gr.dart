// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i45;
import 'package:flutter/material.dart' as _i46;
import 'package:store_user_app/domain/entities/models/customer/customer_info_model/customer_info_model.dart'
    as _i47;
import 'package:store_user_app/presentation/screens/account_activation/view/account_activation_screen.dart'
    as _i1;
import 'package:store_user_app/presentation/screens/brand/view/brand_screen.dart'
    as _i3;
import 'package:store_user_app/presentation/screens/cart/view/cart_screen.dart'
    as _i4;
import 'package:store_user_app/presentation/screens/category/view/category_screen.dart'
    as _i5;
import 'package:store_user_app/presentation/screens/checkout/view/checkout_screen.dart'
    as _i6;
import 'package:store_user_app/presentation/screens/collection/view/collection_screen.dart'
    as _i7;
import 'package:store_user_app/presentation/screens/error/not_found_screen.dart'
    as _i24;
import 'package:store_user_app/presentation/screens/home/view/home_index_screen.dart'
    as _i20;
import 'package:store_user_app/presentation/screens/home/view/home_screen.dart'
    as _i21;
import 'package:store_user_app/presentation/screens/merchandise_return/view/merchandise_return_details_screen.dart'
    as _i22;
import 'package:store_user_app/presentation/screens/merchandise_return/view/merchandise_return_screen.dart'
    as _i23;
import 'package:store_user_app/presentation/screens/notification/notification_detail_screen.dart'
    as _i25;
import 'package:store_user_app/presentation/screens/notification/notifications_screen.dart'
    as _i26;
import 'package:store_user_app/presentation/screens/onboarding/view/walk_through_screen.dart'
    as _i41;
import 'package:store_user_app/presentation/screens/onboarding/view/welcome_screen.dart'
    as _i42;
import 'package:store_user_app/presentation/screens/onboarding/view/welcome_sigin_screen.dart'
    as _i43;
import 'package:store_user_app/presentation/screens/orders/view/orders_detail_screen.dart'
    as _i27;
import 'package:store_user_app/presentation/screens/orders/view/orders_index_screen.dart'
    as _i28;
import 'package:store_user_app/presentation/screens/orders/view/orders_screen.dart'
    as _i29;
import 'package:store_user_app/presentation/screens/orders/view/shipment_details_screen.dart'
    as _i37;
import 'package:store_user_app/presentation/screens/pages/Views/page_screen.dart'
    as _i30;
import 'package:store_user_app/presentation/screens/product/view/product_screen.dart'
    as _i31;
import 'package:store_user_app/presentation/screens/profile/view/account_info_screen.dart'
    as _i2;
import 'package:store_user_app/presentation/screens/profile/view/customer_addresses_screen.dart'
    as _i8;
import 'package:store_user_app/presentation/screens/profile/view/customer_auctions_screen.dart'
    as _i9;
import 'package:store_user_app/presentation/screens/profile/view/customer_change_password_screen.dart'
    as _i10;
import 'package:store_user_app/presentation/screens/profile/view/customer_courses_screen.dart'
    as _i11;
import 'package:store_user_app/presentation/screens/profile/view/customer_documents_screen.dart'
    as _i12;
import 'package:store_user_app/presentation/screens/profile/view/customer_downloadable_products_screen.dart'
    as _i13;
import 'package:store_user_app/presentation/screens/profile/view/customer_loyalty_points_screen.dart'
    as _i14;
import 'package:store_user_app/presentation/screens/profile/view/customer_merchandise_return_screen.dart'
    as _i15;
import 'package:store_user_app/presentation/screens/profile/view/customer_notes_screen.dart'
    as _i16;
import 'package:store_user_app/presentation/screens/profile/view/customer_orders_screen.dart'
    as _i17;
import 'package:store_user_app/presentation/screens/profile/view/customer_out_of_stock_subscriptions_screen.dart'
    as _i18;
import 'package:store_user_app/presentation/screens/profile/view/customer_reviews_screen.dart'
    as _i19;
import 'package:store_user_app/presentation/screens/profile/view/profile_index_screen.dart'
    as _i32;
import 'package:store_user_app/presentation/screens/profile/view/profile_screen.dart'
    as _i33;
import 'package:store_user_app/presentation/screens/search/view/search_result_screen.dart'
    as _i35;
import 'package:store_user_app/presentation/screens/search/view/search_screen.dart'
    as _i36;
import 'package:store_user_app/presentation/screens/signin/view/signin_screen.dart'
    as _i38;
import 'package:store_user_app/presentation/screens/signup/view/signup_screen.dart'
    as _i39;
import 'package:store_user_app/presentation/screens/vendor/view/vendor_screen.dart'
    as _i40;
import 'package:store_user_app/presentation/screens/wishlist/view/wishlist_screen.dart'
    as _i44;
import 'package:store_user_app/presentation/widgets/layout/view/scaffold_with_bottom_navbar.dart'
    as _i34;

/// generated route for
/// [_i1.AccountActivationScreen]
class AccountActivationRoute
    extends _i45.PageRouteInfo<AccountActivationRouteArgs> {
  AccountActivationRoute({
    _i46.Key? key,
    String? token,
    String? email,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         AccountActivationRoute.name,
         args: AccountActivationRouteArgs(key: key, token: token, email: email),
         rawQueryParams: {'token': token, 'email': email},
         initialChildren: children,
       );

  static const String name = 'AccountActivationRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<AccountActivationRouteArgs>(
        orElse:
            () => AccountActivationRouteArgs(
              token: queryParams.optString('token'),
              email: queryParams.optString('email'),
            ),
      );
      return _i1.AccountActivationScreen(
        key: args.key,
        token: args.token,
        email: args.email,
      );
    },
  );
}

class AccountActivationRouteArgs {
  const AccountActivationRouteArgs({this.key, this.token, this.email});

  final _i46.Key? key;

  final String? token;

  final String? email;

  @override
  String toString() {
    return 'AccountActivationRouteArgs{key: $key, token: $token, email: $email}';
  }
}

/// generated route for
/// [_i2.AccountInfoScreen]
class AccountInfoRoute extends _i45.PageRouteInfo<AccountInfoRouteArgs> {
  AccountInfoRoute({
    _i46.Key? key,
    required _i47.CustomerInfoModel customerInfoModel,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         AccountInfoRoute.name,
         args: AccountInfoRouteArgs(
           key: key,
           customerInfoModel: customerInfoModel,
         ),
         initialChildren: children,
       );

  static const String name = 'AccountInfoRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AccountInfoRouteArgs>();
      return _i2.AccountInfoScreen(
        key: args.key,
        customerInfoModel: args.customerInfoModel,
      );
    },
  );
}

class AccountInfoRouteArgs {
  const AccountInfoRouteArgs({this.key, required this.customerInfoModel});

  final _i46.Key? key;

  final _i47.CustomerInfoModel customerInfoModel;

  @override
  String toString() {
    return 'AccountInfoRouteArgs{key: $key, customerInfoModel: $customerInfoModel}';
  }
}

/// generated route for
/// [_i3.BrandScreen]
class BrandRoute extends _i45.PageRouteInfo<BrandRouteArgs> {
  BrandRoute({
    _i46.Key? key,
    required String brandId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         BrandRoute.name,
         args: BrandRouteArgs(key: key, brandId: brandId),
         rawPathParams: {'brandId': brandId},
         initialChildren: children,
       );

  static const String name = 'BrandRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BrandRouteArgs>(
        orElse: () => BrandRouteArgs(brandId: pathParams.getString('brandId')),
      );
      return _i3.BrandScreen(key: args.key, brandId: args.brandId);
    },
  );
}

class BrandRouteArgs {
  const BrandRouteArgs({this.key, required this.brandId});

  final _i46.Key? key;

  final String brandId;

  @override
  String toString() {
    return 'BrandRouteArgs{key: $key, brandId: $brandId}';
  }
}

/// generated route for
/// [_i4.CartScreen]
class CartRoute extends _i45.PageRouteInfo<void> {
  const CartRoute({List<_i45.PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i4.CartScreen();
    },
  );
}

/// generated route for
/// [_i5.CategoryScreen]
class CategoryRoute extends _i45.PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    _i46.Key? key,
    required String categoryId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         CategoryRoute.name,
         args: CategoryRouteArgs(key: key, categoryId: categoryId),
         rawPathParams: {'categoryId': categoryId},
         initialChildren: children,
       );

  static const String name = 'CategoryRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CategoryRouteArgs>(
        orElse:
            () => CategoryRouteArgs(
              categoryId: pathParams.getString('categoryId'),
            ),
      );
      return _i5.CategoryScreen(key: args.key, categoryId: args.categoryId);
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({this.key, required this.categoryId});

  final _i46.Key? key;

  final String categoryId;

  @override
  String toString() {
    return 'CategoryRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [_i6.CheckoutScreen]
class CheckoutRoute extends _i45.PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({
    _i46.Key? key,
    bool requireAuthorization = true,
    bool checkoutAsGuest = false,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         CheckoutRoute.name,
         args: CheckoutRouteArgs(
           key: key,
           requireAuthorization: requireAuthorization,
           checkoutAsGuest: checkoutAsGuest,
         ),
         initialChildren: children,
       );

  static const String name = 'CheckoutRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>(
        orElse: () => const CheckoutRouteArgs(),
      );
      return _i6.CheckoutScreen(
        key: args.key,
        requireAuthorization: args.requireAuthorization,
        checkoutAsGuest: args.checkoutAsGuest,
      );
    },
  );
}

class CheckoutRouteArgs {
  const CheckoutRouteArgs({
    this.key,
    this.requireAuthorization = true,
    this.checkoutAsGuest = false,
  });

  final _i46.Key? key;

  final bool requireAuthorization;

  final bool checkoutAsGuest;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key, requireAuthorization: $requireAuthorization, checkoutAsGuest: $checkoutAsGuest}';
  }
}

/// generated route for
/// [_i7.CollectionScreen]
class CollectionRoute extends _i45.PageRouteInfo<CollectionRouteArgs> {
  CollectionRoute({
    _i46.Key? key,
    required String collectionId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         CollectionRoute.name,
         args: CollectionRouteArgs(key: key, collectionId: collectionId),
         rawPathParams: {'collectionId': collectionId},
         initialChildren: children,
       );

  static const String name = 'CollectionRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CollectionRouteArgs>(
        orElse:
            () => CollectionRouteArgs(
              collectionId: pathParams.getString('collectionId'),
            ),
      );
      return _i7.CollectionScreen(
        key: args.key,
        collectionId: args.collectionId,
      );
    },
  );
}

class CollectionRouteArgs {
  const CollectionRouteArgs({this.key, required this.collectionId});

  final _i46.Key? key;

  final String collectionId;

  @override
  String toString() {
    return 'CollectionRouteArgs{key: $key, collectionId: $collectionId}';
  }
}

/// generated route for
/// [_i8.CustomerAddressesScreen]
class CustomerAddressesRoute extends _i45.PageRouteInfo<void> {
  const CustomerAddressesRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerAddressesRoute.name, initialChildren: children);

  static const String name = 'CustomerAddressesRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i8.CustomerAddressesScreen();
    },
  );
}

/// generated route for
/// [_i9.CustomerAuctionsScreen]
class CustomerAuctionsRoute extends _i45.PageRouteInfo<void> {
  const CustomerAuctionsRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerAuctionsRoute.name, initialChildren: children);

  static const String name = 'CustomerAuctionsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i9.CustomerAuctionsScreen();
    },
  );
}

/// generated route for
/// [_i10.CustomerChangePasswordScreen]
class CustomerChangePasswordRoute extends _i45.PageRouteInfo<void> {
  const CustomerChangePasswordRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerChangePasswordRoute.name, initialChildren: children);

  static const String name = 'CustomerChangePasswordRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i10.CustomerChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i11.CustomerCoursesScreen]
class CustomerCoursesRoute extends _i45.PageRouteInfo<void> {
  const CustomerCoursesRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerCoursesRoute.name, initialChildren: children);

  static const String name = 'CustomerCoursesRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i11.CustomerCoursesScreen();
    },
  );
}

/// generated route for
/// [_i12.CustomerDocumentsScreen]
class CustomerDocumentsRoute extends _i45.PageRouteInfo<void> {
  const CustomerDocumentsRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerDocumentsRoute.name, initialChildren: children);

  static const String name = 'CustomerDocumentsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i12.CustomerDocumentsScreen();
    },
  );
}

/// generated route for
/// [_i13.CustomerDownloadableProductsScreen]
class CustomerDownloadableProductsRoute extends _i45.PageRouteInfo<void> {
  const CustomerDownloadableProductsRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerDownloadableProductsRoute.name, initialChildren: children);

  static const String name = 'CustomerDownloadableProductsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i13.CustomerDownloadableProductsScreen();
    },
  );
}

/// generated route for
/// [_i14.CustomerLoyaltyPointsScreen]
class CustomerLoyaltyPointsRoute extends _i45.PageRouteInfo<void> {
  const CustomerLoyaltyPointsRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerLoyaltyPointsRoute.name, initialChildren: children);

  static const String name = 'CustomerLoyaltyPointsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i14.CustomerLoyaltyPointsScreen();
    },
  );
}

/// generated route for
/// [_i15.CustomerMerchandiseReturnScreen]
class CustomerMerchandiseReturnRoute extends _i45.PageRouteInfo<void> {
  const CustomerMerchandiseReturnRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerMerchandiseReturnRoute.name, initialChildren: children);

  static const String name = 'CustomerMerchandiseReturnRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i15.CustomerMerchandiseReturnScreen();
    },
  );
}

/// generated route for
/// [_i16.CustomerNotesScreen]
class CustomerNotesRoute extends _i45.PageRouteInfo<void> {
  const CustomerNotesRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerNotesRoute.name, initialChildren: children);

  static const String name = 'CustomerNotesRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i16.CustomerNotesScreen();
    },
  );
}

/// generated route for
/// [_i17.CustomerOrdersScreen]
class CustomerOrdersRoute extends _i45.PageRouteInfo<void> {
  const CustomerOrdersRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerOrdersRoute.name, initialChildren: children);

  static const String name = 'CustomerOrdersRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i17.CustomerOrdersScreen();
    },
  );
}

/// generated route for
/// [_i18.CustomerOutOfStockSubscriptionsScreen]
class CustomerOutOfStockSubscriptionsRoute extends _i45.PageRouteInfo<void> {
  const CustomerOutOfStockSubscriptionsRoute({
    List<_i45.PageRouteInfo>? children,
  }) : super(
         CustomerOutOfStockSubscriptionsRoute.name,
         initialChildren: children,
       );

  static const String name = 'CustomerOutOfStockSubscriptionsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i18.CustomerOutOfStockSubscriptionsScreen();
    },
  );
}

/// generated route for
/// [_i19.CustomerReviewsScreen]
class CustomerReviewsRoute extends _i45.PageRouteInfo<void> {
  const CustomerReviewsRoute({List<_i45.PageRouteInfo>? children})
    : super(CustomerReviewsRoute.name, initialChildren: children);

  static const String name = 'CustomerReviewsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i19.CustomerReviewsScreen();
    },
  );
}

/// generated route for
/// [_i20.HomeIndexScreen]
class HomeIndexRoute extends _i45.PageRouteInfo<void> {
  const HomeIndexRoute({List<_i45.PageRouteInfo>? children})
    : super(HomeIndexRoute.name, initialChildren: children);

  static const String name = 'HomeIndexRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i20.HomeIndexScreen();
    },
  );
}

/// generated route for
/// [_i21.HomeScreen]
class HomeRoute extends _i45.PageRouteInfo<void> {
  const HomeRoute({List<_i45.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i21.HomeScreen();
    },
  );
}

/// generated route for
/// [_i22.MerchandiseReturnDetailsScreen]
class MerchandiseReturnDetailsRoute
    extends _i45.PageRouteInfo<MerchandiseReturnDetailsRouteArgs> {
  MerchandiseReturnDetailsRoute({
    _i46.Key? key,
    required String merchandiseReturnId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         MerchandiseReturnDetailsRoute.name,
         args: MerchandiseReturnDetailsRouteArgs(
           key: key,
           merchandiseReturnId: merchandiseReturnId,
         ),
         rawPathParams: {'merchandiseReturnId': merchandiseReturnId},
         initialChildren: children,
       );

  static const String name = 'MerchandiseReturnDetailsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MerchandiseReturnDetailsRouteArgs>(
        orElse:
            () => MerchandiseReturnDetailsRouteArgs(
              merchandiseReturnId: pathParams.getString('merchandiseReturnId'),
            ),
      );
      return _i22.MerchandiseReturnDetailsScreen(
        key: args.key,
        merchandiseReturnId: args.merchandiseReturnId,
      );
    },
  );
}

class MerchandiseReturnDetailsRouteArgs {
  const MerchandiseReturnDetailsRouteArgs({
    this.key,
    required this.merchandiseReturnId,
  });

  final _i46.Key? key;

  final String merchandiseReturnId;

  @override
  String toString() {
    return 'MerchandiseReturnDetailsRouteArgs{key: $key, merchandiseReturnId: $merchandiseReturnId}';
  }
}

/// generated route for
/// [_i23.MerchandiseReturnScreen]
class MerchandiseReturnRoute
    extends _i45.PageRouteInfo<MerchandiseReturnRouteArgs> {
  MerchandiseReturnRoute({
    _i46.Key? key,
    required String orderId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         MerchandiseReturnRoute.name,
         args: MerchandiseReturnRouteArgs(key: key, orderId: orderId),
         rawPathParams: {'orderId': orderId},
         initialChildren: children,
       );

  static const String name = 'MerchandiseReturnRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MerchandiseReturnRouteArgs>(
        orElse:
            () => MerchandiseReturnRouteArgs(
              orderId: pathParams.getString('orderId'),
            ),
      );
      return _i23.MerchandiseReturnScreen(key: args.key, orderId: args.orderId);
    },
  );
}

class MerchandiseReturnRouteArgs {
  const MerchandiseReturnRouteArgs({this.key, required this.orderId});

  final _i46.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'MerchandiseReturnRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i24.NotFoundScreen]
class NotFoundRoute extends _i45.PageRouteInfo<NotFoundRouteArgs> {
  NotFoundRoute({
    _i46.Key? key,
    String? message,
    String? path,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         NotFoundRoute.name,
         args: NotFoundRouteArgs(key: key, message: message, path: path),
         initialChildren: children,
       );

  static const String name = 'NotFoundRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotFoundRouteArgs>(
        orElse: () => const NotFoundRouteArgs(),
      );
      return _i24.NotFoundScreen(
        key: args.key,
        message: args.message,
        path: args.path,
      );
    },
  );
}

class NotFoundRouteArgs {
  const NotFoundRouteArgs({this.key, this.message, this.path});

  final _i46.Key? key;

  final String? message;

  final String? path;

  @override
  String toString() {
    return 'NotFoundRouteArgs{key: $key, message: $message, path: $path}';
  }
}

/// generated route for
/// [_i25.NotificationDetailScreen]
class NotificationDetailRoute
    extends _i45.PageRouteInfo<NotificationDetailRouteArgs> {
  NotificationDetailRoute({
    _i46.Key? key,
    required String notificationId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         NotificationDetailRoute.name,
         args: NotificationDetailRouteArgs(
           key: key,
           notificationId: notificationId,
         ),
         rawPathParams: {'notificationId': notificationId},
         initialChildren: children,
       );

  static const String name = 'NotificationDetailRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<NotificationDetailRouteArgs>(
        orElse:
            () => NotificationDetailRouteArgs(
              notificationId: pathParams.getString('notificationId'),
            ),
      );
      return _i25.NotificationDetailScreen(
        key: args.key,
        notificationId: args.notificationId,
      );
    },
  );
}

class NotificationDetailRouteArgs {
  const NotificationDetailRouteArgs({this.key, required this.notificationId});

  final _i46.Key? key;

  final String notificationId;

  @override
  String toString() {
    return 'NotificationDetailRouteArgs{key: $key, notificationId: $notificationId}';
  }
}

/// generated route for
/// [_i26.NotificationsScreen]
class NotificationsRoute extends _i45.PageRouteInfo<void> {
  const NotificationsRoute({List<_i45.PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i26.NotificationsScreen();
    },
  );
}

/// generated route for
/// [_i27.OrdersDetailScreen]
class OrdersDetailRoute extends _i45.PageRouteInfo<OrdersDetailRouteArgs> {
  OrdersDetailRoute({
    _i46.Key? key,
    required String orderId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         OrdersDetailRoute.name,
         args: OrdersDetailRouteArgs(key: key, orderId: orderId),
         rawPathParams: {'orderId': orderId},
         initialChildren: children,
       );

  static const String name = 'OrdersDetailRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<OrdersDetailRouteArgs>(
        orElse:
            () =>
                OrdersDetailRouteArgs(orderId: pathParams.getString('orderId')),
      );
      return _i27.OrdersDetailScreen(key: args.key, orderId: args.orderId);
    },
  );
}

class OrdersDetailRouteArgs {
  const OrdersDetailRouteArgs({this.key, required this.orderId});

  final _i46.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrdersDetailRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i28.OrdersIndexScreen]
class OrdersIndexRoute extends _i45.PageRouteInfo<void> {
  const OrdersIndexRoute({List<_i45.PageRouteInfo>? children})
    : super(OrdersIndexRoute.name, initialChildren: children);

  static const String name = 'OrdersIndexRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i28.OrdersIndexScreen();
    },
  );
}

/// generated route for
/// [_i29.OrdersScreen]
class OrdersRoute extends _i45.PageRouteInfo<void> {
  const OrdersRoute({List<_i45.PageRouteInfo>? children})
    : super(OrdersRoute.name, initialChildren: children);

  static const String name = 'OrdersRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i29.OrdersScreen();
    },
  );
}

/// generated route for
/// [_i30.PageScreen]
class PageScreenRoute extends _i45.PageRouteInfo<PageScreenRouteArgs> {
  PageScreenRoute({
    _i46.Key? key,
    required String pageSystemName,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         PageScreenRoute.name,
         args: PageScreenRouteArgs(key: key, pageSystemName: pageSystemName),
         rawPathParams: {'pageSystemName': pageSystemName},
         initialChildren: children,
       );

  static const String name = 'PageScreenRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PageScreenRouteArgs>(
        orElse:
            () => PageScreenRouteArgs(
              pageSystemName: pathParams.getString('pageSystemName'),
            ),
      );
      return _i30.PageScreen(
        key: args.key,
        pageSystemName: args.pageSystemName,
      );
    },
  );
}

class PageScreenRouteArgs {
  const PageScreenRouteArgs({this.key, required this.pageSystemName});

  final _i46.Key? key;

  final String pageSystemName;

  @override
  String toString() {
    return 'PageScreenRouteArgs{key: $key, pageSystemName: $pageSystemName}';
  }
}

/// generated route for
/// [_i31.ProductScreen]
class ProductRoute extends _i45.PageRouteInfo<ProductRouteArgs> {
  ProductRoute({
    _i46.Key? key,
    required String productId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         ProductRoute.name,
         args: ProductRouteArgs(key: key, productId: productId),
         rawPathParams: {'productId': productId},
         initialChildren: children,
       );

  static const String name = 'ProductRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProductRouteArgs>(
        orElse:
            () =>
                ProductRouteArgs(productId: pathParams.getString('productId')),
      );
      return _i31.ProductScreen(key: args.key, productId: args.productId);
    },
  );
}

class ProductRouteArgs {
  const ProductRouteArgs({this.key, required this.productId});

  final _i46.Key? key;

  final String productId;

  @override
  String toString() {
    return 'ProductRouteArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i32.ProfileIndexScreen]
class ProfileIndexRoute extends _i45.PageRouteInfo<void> {
  const ProfileIndexRoute({List<_i45.PageRouteInfo>? children})
    : super(ProfileIndexRoute.name, initialChildren: children);

  static const String name = 'ProfileIndexRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i32.ProfileIndexScreen();
    },
  );
}

/// generated route for
/// [_i33.ProfileScreen]
class ProfileRoute extends _i45.PageRouteInfo<void> {
  const ProfileRoute({List<_i45.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i33.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i34.ScaffoldWithBottomNavbar]
class ScaffoldWithBottomNavbar
    extends _i45.PageRouteInfo<ScaffoldWithBottomNavbarArgs> {
  ScaffoldWithBottomNavbar({_i46.Key? key, List<_i45.PageRouteInfo>? children})
    : super(
        ScaffoldWithBottomNavbar.name,
        args: ScaffoldWithBottomNavbarArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ScaffoldWithBottomNavbar';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScaffoldWithBottomNavbarArgs>(
        orElse: () => const ScaffoldWithBottomNavbarArgs(),
      );
      return _i34.ScaffoldWithBottomNavbar(key: args.key);
    },
  );
}

class ScaffoldWithBottomNavbarArgs {
  const ScaffoldWithBottomNavbarArgs({this.key});

  final _i46.Key? key;

  @override
  String toString() {
    return 'ScaffoldWithBottomNavbarArgs{key: $key}';
  }
}

/// generated route for
/// [_i35.SearchResultScreen]
class SearchResultRoute extends _i45.PageRouteInfo<SearchResultRouteArgs> {
  SearchResultRoute({
    _i46.Key? key,
    String? searchQuery,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         SearchResultRoute.name,
         args: SearchResultRouteArgs(key: key, searchQuery: searchQuery),
         rawQueryParams: {'searchQuery': searchQuery},
         initialChildren: children,
       );

  static const String name = 'SearchResultRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SearchResultRouteArgs>(
        orElse:
            () => SearchResultRouteArgs(
              searchQuery: queryParams.optString('searchQuery'),
            ),
      );
      return _i35.SearchResultScreen(
        key: args.key,
        searchQuery: args.searchQuery,
      );
    },
  );
}

class SearchResultRouteArgs {
  const SearchResultRouteArgs({this.key, this.searchQuery});

  final _i46.Key? key;

  final String? searchQuery;

  @override
  String toString() {
    return 'SearchResultRouteArgs{key: $key, searchQuery: $searchQuery}';
  }
}

/// generated route for
/// [_i36.SearchScreen]
class SearchRoute extends _i45.PageRouteInfo<void> {
  const SearchRoute({List<_i45.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i36.SearchScreen();
    },
  );
}

/// generated route for
/// [_i37.ShipmentDetailsScreen]
class ShipmentDetailsRoute
    extends _i45.PageRouteInfo<ShipmentDetailsRouteArgs> {
  ShipmentDetailsRoute({
    _i46.Key? key,
    required String shipmentId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         ShipmentDetailsRoute.name,
         args: ShipmentDetailsRouteArgs(key: key, shipmentId: shipmentId),
         rawPathParams: {'shipmentId': shipmentId},
         initialChildren: children,
       );

  static const String name = 'ShipmentDetailsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShipmentDetailsRouteArgs>(
        orElse:
            () => ShipmentDetailsRouteArgs(
              shipmentId: pathParams.getString('shipmentId'),
            ),
      );
      return _i37.ShipmentDetailsScreen(
        key: args.key,
        shipmentId: args.shipmentId,
      );
    },
  );
}

class ShipmentDetailsRouteArgs {
  const ShipmentDetailsRouteArgs({this.key, required this.shipmentId});

  final _i46.Key? key;

  final String shipmentId;

  @override
  String toString() {
    return 'ShipmentDetailsRouteArgs{key: $key, shipmentId: $shipmentId}';
  }
}

/// generated route for
/// [_i38.SigninScreen]
class SigninRoute extends _i45.PageRouteInfo<SigninRouteArgs> {
  SigninRoute({
    _i46.Key? key,
    String? returnUrl,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         SigninRoute.name,
         args: SigninRouteArgs(key: key, returnUrl: returnUrl),
         initialChildren: children,
       );

  static const String name = 'SigninRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SigninRouteArgs>(
        orElse: () => const SigninRouteArgs(),
      );
      return _i38.SigninScreen(key: args.key, returnUrl: args.returnUrl);
    },
  );
}

class SigninRouteArgs {
  const SigninRouteArgs({this.key, this.returnUrl});

  final _i46.Key? key;

  final String? returnUrl;

  @override
  String toString() {
    return 'SigninRouteArgs{key: $key, returnUrl: $returnUrl}';
  }
}

/// generated route for
/// [_i39.SignupScreen]
class SignupRoute extends _i45.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    _i46.Key? key,
    String? returnUrl,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         SignupRoute.name,
         args: SignupRouteArgs(key: key, returnUrl: returnUrl),
         initialChildren: children,
       );

  static const String name = 'SignupRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignupRouteArgs>(
        orElse: () => const SignupRouteArgs(),
      );
      return _i39.SignupScreen(key: args.key, returnUrl: args.returnUrl);
    },
  );
}

class SignupRouteArgs {
  const SignupRouteArgs({this.key, this.returnUrl});

  final _i46.Key? key;

  final String? returnUrl;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, returnUrl: $returnUrl}';
  }
}

/// generated route for
/// [_i40.VendorScreen]
class VendorRoute extends _i45.PageRouteInfo<VendorRouteArgs> {
  VendorRoute({
    _i46.Key? key,
    required String vendorId,
    List<_i45.PageRouteInfo>? children,
  }) : super(
         VendorRoute.name,
         args: VendorRouteArgs(key: key, vendorId: vendorId),
         rawPathParams: {'vendorId': vendorId},
         initialChildren: children,
       );

  static const String name = 'VendorRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<VendorRouteArgs>(
        orElse:
            () => VendorRouteArgs(vendorId: pathParams.getString('vendorId')),
      );
      return _i40.VendorScreen(key: args.key, vendorId: args.vendorId);
    },
  );
}

class VendorRouteArgs {
  const VendorRouteArgs({this.key, required this.vendorId});

  final _i46.Key? key;

  final String vendorId;

  @override
  String toString() {
    return 'VendorRouteArgs{key: $key, vendorId: $vendorId}';
  }
}

/// generated route for
/// [_i41.WalkThroughScreen]
class WalkThroughRoute extends _i45.PageRouteInfo<void> {
  const WalkThroughRoute({List<_i45.PageRouteInfo>? children})
    : super(WalkThroughRoute.name, initialChildren: children);

  static const String name = 'WalkThroughRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i41.WalkThroughScreen();
    },
  );
}

/// generated route for
/// [_i42.WelcomeScreen]
class WelcomeRoute extends _i45.PageRouteInfo<void> {
  const WelcomeRoute({List<_i45.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i42.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i43.WelcomeSiginScreen]
class WelcomeSiginRoute extends _i45.PageRouteInfo<void> {
  const WelcomeSiginRoute({List<_i45.PageRouteInfo>? children})
    : super(WelcomeSiginRoute.name, initialChildren: children);

  static const String name = 'WelcomeSiginRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i43.WelcomeSiginScreen();
    },
  );
}

/// generated route for
/// [_i44.WishlistScreen]
class WishlistRoute extends _i45.PageRouteInfo<void> {
  const WishlistRoute({List<_i45.PageRouteInfo>? children})
    : super(WishlistRoute.name, initialChildren: children);

  static const String name = 'WishlistRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i44.WishlistScreen();
    },
  );
}
