class AppPaths {
  // Root navigation
  static String welcome() => '/welcome';
  static String walkThrough() => '/walk-through';
  static String welcomeSignin() => '/welcome-signin';
  static String notFound({String? path, String? message}) => 
      '/not-found?path=$path&message=$message';

  // Home routes
  static String homeIndex() => '/home/index';
  static String searchResult({required String searchQuery}) =>
      '/home/search-result?searchQuery=$searchQuery';
  static String category({required String categoryId}) =>
      '/home/category/$categoryId';
  static String brand({required String brandId}) => '/home/brand/$brandId';
  static String collection({required String collectionId}) =>
      '/home/collection/$collectionId';

  static String vendor({required String vendorId}) => '/home/vendor/$vendorId';

  // Profile routes
  static String profileIndex() => '/profile/index';
  static String accountInfo() => '/profile/account-info';
  static String customerAddresses() => '/profile/customer-addresses';
  static String customerOrders() => '/profile/customer-orders';
  static String customerCourses() => '/profile/customer-courses';
  static String customerAuctions() => '/profile/customer-auctions';
  static String customerNotes() => '/profile/customer-notes';
  static String customerDocuments() => '/profile/customer-documents';
  static String customerMerchandiseReturn() =>
      '/profile/customer-merchandise-return';
  static String customerDownloadableProducts() =>
      '/profile/customer-downloadbale-products';
  static String customerOutOfStockSubscriptions() =>
      '/profile/customer-out-of-stock-subscriptions';
  static String customerLoyaltyPoints() => '/profile/customer-loyalty-points';
  static String customerChangePassword() => '/profile/customer-change-password';
  static String customerReviews() => '/profile/customer-reviews';

  // Order routes
  static String ordersIndex() => '/orders/index';
  static String orderDetails({required String orderId}) =>
      '/orders/orders-details/$orderId';
  static String shipmentDetails({required String shipmentId}) =>
      '/orders/orders-shipments-detail/$shipmentId';
  static String merchandiseReturn({required String orderId}) =>
      '/orders/merchandise-return/$orderId';
  static String merchandiseReturnDetails({
    required String merchandiseReturnId,
  }) => '/merchandise-return-details/$merchandiseReturnId';

  // Product routes
  static String product({required String productId}) => '/product/$productId';

  // Shopping
  static String cart() => '/shopping-cart';
  static String checkout() => '/checkout';
  static String search(String searchQuery) => '/search';
  static String wishlist() => '/wishlist';

  // Auth routes
  static String signin({String? returnUrl}) =>
      returnUrl != null ? '/signin?returnUrl=$returnUrl' : '/signin';
  static String signup({String? returnUrl}) =>
      returnUrl != null ? '/signup?returnUrl=$returnUrl' : '/signup';

  static Future<String?> registerResult(int? resultId) async {
    return "/resgisterResult/${resultId}";
  }

  // Account activation route
  static String accountActivation({required String token, required String email}) =>
      '/account/activation?token=$token&email=${Uri.encodeComponent(email)}';

      static String pageScreen({required String pageSystemName}) =>
      '/page/$pageSystemName';
}
