import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';

import '../../../domain/repositories/account/account_repository.dart';
import '../../di/injection_container.dart';
import '../../models/depplink/resolve_slug.dart';
import '../auth/auth_service.dart';
import '../logger/logger_service.dart';

@singleton
class DeeplinkService {
  // final AppRouter _router;
  final AuthService _authService;
  final Dio dio;

  // Stream subscription for link changes
  // StreamSubscription? _subscription;

  // Flag to prevent duplicate initializations
  bool _isInitialized = false;

  // Base URL for the web version of the store
  final String _baseUrl = AppConfig.instance.apiBaseUrl;

  // API endpoint to resolve SEO slugs
  final String _resolveSeoSlugEndpoint = '/resolveseoslug';

  DeeplinkService(this._authService, this.dio);

  @factoryMethod
  static Future<DeeplinkService> create(
      AuthService authService,
      Dio dio,
      ) async {
    return DeeplinkService(authService, dio);
  }

  /// Initialize the service and set up link listeners
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _isInitialized = true;
      LoggerService.info('Dynamic link service initialized');
    } on PlatformException catch (e) {
      LoggerService.error('Error initializing dynamic links', e);
    }
  }

  /// Parse the link and navigate accordingly
  Future<String?> handleIncomingLink(Uri uri) async {
    try {
      LoggerService.info('Handling incoming link: $uri');
      final path = uri.path;
      final queryParams = uri.queryParameters;

      // First, check if this is a slug-based URL (doesn't start with a known controller path)
      if (_isSlugUrl(path)) {
        return await _handleSlugUrl(path, queryParams);
      }

      // If not a slug URL, handle as standard controller/action URL
      return await _navigateToMappedRoute(path, queryParams);
    } catch (e, stackTrace) {
      LoggerService.error('Error handling dynamic link', e, stackTrace);
      return null;
    }
  }

  /// Check if the path appears to be a slug URL rather than a controller/action URL
  bool _isSlugUrl(String path) {
    // Paths that don't match known controller routes are likely slug URLs
    final knownPrefixes = [
      '/Account/',
      '/Vendor/',
      '/Cart/',
      '/Order/',
      '/Customer/',
      '/Product/',
      '/Category',
      '/Checkout/',
      '/Search/',
      '/Wishlist/',
      '/Blog/',
      '/News/',
      '/Knowledgebase/',
      '/ReturnRequest/',
      '/Page/',
    ];

    // Remove leading slash for comparison if present
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;

    // See if this looks like a standard controller/action pattern
    bool isStandardRoute = false;
    for (var prefix in knownPrefixes) {
      prefix = prefix.startsWith('/') ? prefix.substring(1) : prefix;
      if (normalizedPath.startsWith(prefix)) {
        isStandardRoute = true;
        break;
      }
    }

    // If it's not a standard route and isn't empty, it's probably a slug
    return !isStandardRoute && normalizedPath.isNotEmpty;
  }

  /// Handle a slug-based URL by resolving it to the correct route
  Future<String?> _handleSlugUrl(
      String path,
      Map<String, String> queryParams,
      ) async {
    // Extract slug from path
    final slug = path.startsWith('/') ? path.substring(1) : path;

    // Some slugs might include language prefix like 'en/my-product'
    String languageCode = '';
    String slugWithoutLang = slug;

    // Check for language prefix
    final parts = slug.split('/');
    if (parts.length > 1 && parts[0].length == 2) {
      // This might be a language code (like 'en', 'fr', etc.)
      languageCode = parts[0];
      slugWithoutLang = parts.sublist(1).join('/');
    }

    // Try to resolve the slug using the API
    try {
      var slugUri= Uri.tryParse(slug);
      slugUri=slugUri?.replace(queryParameters:queryParams );
      final resolved = await resolveSlugViaApi((slugUri??Uri.parse("/")).toString());
      if (resolved != null) {
        // First check based on entityType
        switch (resolved.entityType) {
          case 'Product':
            return AppPaths.product(productId: resolved.entityId);

          case 'Category':
            return AppPaths.category(categoryId: resolved.entityId);

          case 'Brand':
            return AppPaths.brand(brandId: resolved.entityId);

          case 'Collection':
            return AppPaths.collection(collectionId: resolved.entityId);

          case 'Vendor':
            return AppPaths.vendor(vendorId: resolved.entityId);

          case 'Course':
            return AppPaths.customerCourses();
        }

        // If not matched by entityType, check controller/action combinations
        switch (resolved.controller) {
          case 'Product':
            return AppPaths.product(productId: resolved.entityId);

          case 'Catalog':
            switch (resolved.action.toLowerCase()) {
              case 'category':
                return AppPaths.category(categoryId: resolved.entityId);
              case 'brand':
                return AppPaths.brand(brandId: resolved.entityId);
              case 'collection':
                return AppPaths.collection(collectionId: resolved.entityId);
              case 'vendor':
                return AppPaths.vendor(vendorId: resolved.entityId);
              case 'search':
                final searchQuery = resolved.params['q'] ?? '';
                return AppPaths.searchResult(searchQuery: searchQuery);
              default:
                return AppPaths.homeIndex();
            }

          case 'Order':
            switch (resolved.action.toLowerCase()) {
              case 'details':
                final orderId =
                resolved.entityId.isNotEmpty
                    ? resolved.entityId
                    : resolved.params['orderId'] ?? '';
                if (orderId.isNotEmpty) {
                  return AppPaths.orderDetails(orderId: orderId);
                }
                return AppPaths.ordersIndex();
              case 'shipmentdetails':
                final shipmentId = resolved.params['shipmentId'] ?? '';
                if (shipmentId.isNotEmpty) {
                  return AppPaths.shipmentDetails(shipmentId: shipmentId);
                }
                return AppPaths.ordersIndex();
              case 'customerorders':
                return AppPaths.customerOrders();
              default:
                return AppPaths.ordersIndex();
            }

          case 'Account':
            switch (resolved.action.toLowerCase()) {
              case 'login':
                var returnUrl =
                    resolved.params['returnUrl'] ?? AppPaths.homeIndex();
                return AppPaths.signin(returnUrl: returnUrl);
              case 'register':
                var returnUrl =
                    resolved.params['returnUrl'] ?? AppPaths.homeIndex();
                return AppPaths.signup(returnUrl: returnUrl);
              case 'info':
                return AppPaths.accountInfo();
              case 'addresses':
                return AppPaths.customerAddresses();
              case 'registerresult':
                if(resolved.params.containsKey("resultId")){
                  var resultId= int.tryParse(resolved.params["resultId"].toString());
                  return AppPaths.registerResult(resultId);
                }
                return AppPaths.homeIndex();
              case 'activation':
              case 'accountactivation':
                var token = resolved.params['token'] ?? '';
                var email = resolved.params['email'] ?? '';
                if (token.isNotEmpty && email.isNotEmpty) {
                  return AppPaths.accountActivation(token: token, email: email);
                }
                return AppPaths.homeIndex();
              default:
                return AppPaths.profileIndex();
            }

          case 'ShoppingCart':
            return AppPaths.cart();

          case 'Checkout':
            return AppPaths.checkout();

          case 'News':
          case 'Blog':
          case 'Page':
          case 'Knowledgebase':
          default:
          // Fallback to home if we can't resolve the route
            LoggerService.info(
              'Unhandled controller: ${resolved.controller}, action: ${resolved.action}',
            );
            return AppPaths.homeIndex();
        }
      } else {
        // If we can't resolve the slug, navigate to home
        LoggerService.info('Could not resolve slug: $slug');
        return AppPaths.homeIndex();
      }
    } catch (e) {
      LoggerService.error('Error resolving slug via API', e);
      // On error, navigate to home
      return AppPaths.homeIndex();
    }
  }

  /// Try to resolve the slug using a local database or cached mapping
  ResolvedSlug? _resolveSlugLocally(String slug) {
    // This is a simple example - in production, you might want to
    // maintain a database or cache of known slugs for better performance

    // Example pattern matching for common slugs
    if (slug.contains('product-')) {
      final productId = slug.split('-').last;
      if (productId.isNotEmpty) {
        return ResolvedSlug(
          controller: 'Product',
          action: 'ProductDetails',
          params: {'productId': productId},
          entityType: 'Product',
          entityId: productId,
        );
      }
    }

    if (slug.contains('category-')) {
      final categoryId = slug.split('-').last;
      if (categoryId.isNotEmpty) {
        return ResolvedSlug(
          controller: 'Catalog',
          action: 'Category',
          params: {'categoryId': categoryId},
          entityType: 'Category',
          entityId: categoryId,
        );
      }
    }

    // No local match found
    return null;
  }

  /// Resolve the slug by making an API call to the backend
  Future<ResolvedSlug?> resolveSlugViaApi(String slug) async {
    try {
      // Get access token
      final tokens = await _authService.getAccessToken();
      if (tokens == null) {
        LoggerService.error('Failed to get access token for slug resolution');
        return null;
      }

      // Make API call to resolve slug
      var uriSlug= Uri.parse('$_baseUrl$_resolveSeoSlugEndpoint');
      uriSlug=uriSlug.replace(queryParameters: {
        'slug':slug
      });
      final response = await dio.getUri<Map<String, dynamic>?>(
        uriSlug,
        // headers: {
        //   'Authorization': 'Bearer ${tokens.bearerToken}',
        //   'x-store-token': tokens.accessToken,
        // },
      );

      if (response.statusCode == 200 && response.data != null) {
        var data = response.data!;

        // Check if it's a redirect response
        if (data['redirect'] == true && data['slug'] != null) {
          // If it's a redirect, make a recursive call with the new slug
          return await resolveSlugViaApi(data['slug']);
        }

        // Based on SeoSlugUrlResolverController.cs, the API can return two types of responses:
        // 1. From entityUrl resolution: { entityId, entityType, controller, action, slug }
        // 2. From route resolution: { controller, action, routeParams, slug }

        String entityId = '';
        String entityType = '';
        String controller = '';
        String action = '';
        Map<String, String> params = {};

        // Extract entityId - could be directly in response or in routeParams
        if (data['entityId'] != null) {
          entityId = data['entityId'].toString();
        }

        // Extract entityType
        if (data['entityType'] != null) {
          entityType = data['entityType'].toString();
        }

        // Extract controller
        if (data['controller'] != null) {
          controller = data['controller'].toString();
        }

        // Extract action
        if (data['action'] != null) {
          action = data['action'].toString();
        }

        // Extract route parameters
        if (data['routeParams'] != null) {
          params = (data['routeParams'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
          );

          // If entityId wasn't in the top level, try to find it in routeParams
          if (entityId.isEmpty) {
            // Look for parameters that look like IDs
            entityId =
                params.entries
                    .where(
                      (entry) =>
                  entry.key.toLowerCase().contains('id') ||
                      entry.key.toLowerCase() == 'productid',
                )
                    .firstOrNull
                    ?.value ??
                    '';
          }
        }

        return ResolvedSlug(
          entityId: entityId,
          entityType: entityType,
          controller: controller,
          action: action,
          params: params,
        );
      } else {
        LoggerService.error('Failed to resolve slug: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LoggerService.error('Error resolving slug via API', e);
      return null;
    }
  }

  /// Map backend MVC routes to app routes and navigate
  Future<String?> _navigateToMappedRoute(
      String path,
      Map<String, String> queryParams,
      ) async {
    LoggerService.debug('Mapping route: $path with params: $queryParams');
    path = path.toLowerCase();
    // Home page
    if (path == '/' ||
        path.isEmpty ||
        path == '/home' ||
        path == '/home/index') {
      return AppPaths.homeIndex();
    }

    // Product pages
    if (_isProductRoute(path)) {
      return _handleProductRoutes(path, queryParams);
    }

    // Category pages
    if (_isCategoryRoute(path)) {
      return _handleCategoryRoutes(path, queryParams);
    }

    // Account pages
    if (_isAccountRoute(path)) {
      return _handleAccountRoutes(path, queryParams);
    }

    // Order and checkout pages
    if (_isOrderOrCheckoutRoute(path)) {
      return _handleOrderRoutes(path, queryParams);
    }

    // Cart
    if (_isCartRoute(path)) {
      return AppPaths.cart();
    }

    // Search
    if (_isSearchRoute(path)) {
      final query = queryParams['q'] ?? '';
      return AppPaths.searchResult(searchQuery: query);
    }

    // Wishlist
    if (_isWishlistRoute(path)) {
      return AppPaths.wishlist();
    }

    // If no match found, check if it might be a slug
    if (_isSlugUrl(path)) {
      return await _handleSlugUrl(path, queryParams);
    }

    // If all else fails, navigate to home
    LoggerService.info('No route match found, navigating to home');
    return AppPaths.homeIndex();
  }

  // Route type checkers
  bool _isProductRoute(String path) =>
      path.startsWith('/Product') || path.contains('/Product/');

  bool _isCategoryRoute(String path) =>
      path.startsWith('/Category') || path.contains('/Category/');

  bool _isAccountRoute(String path) =>
      path.startsWith('/Account') || path.contains('/Account/');

  bool _isOrderOrCheckoutRoute(String path) =>
      path.startsWith('/Order') ||
          path.contains('/Order/') ||
          path.startsWith('/Checkout') ||
          path.contains('/Checkout/');

  bool _isCartRoute(String path) =>
      path.startsWith('/Cart') ||
          path.contains('/Cart/') ||
          path.startsWith('/ShoppingCart') ||
          path.contains('/ShoppingCart/');

  bool _isSearchRoute(String path) =>
      path.startsWith('/Search') || path.contains('/Search/');

  bool _isWishlistRoute(String path) =>
      path.startsWith('/Wishlist') || path.contains('/Wishlist/');

  /// Product route handling (.NET Core MVC to Flutter)
  String? _handleProductRoutes(String path, Map<String, String> queryParams) {
    // Handle /Product/Detail?productId=X
    if (path.contains('/Product/Detail') ||
        path.contains('/Product/ProductDetails')) {
      String? productId = queryParams['productId'];

      // If productId is not in query params, try to extract from SEO friendly URL
      if (productId == null || productId.isEmpty) {
        final segments = path.split('/');
        if (segments.length > 2) {
          // Last segment might be the product ID or SEO name
          productId = segments.last;
        }
      }

      if (productId != null && productId.isNotEmpty) {
        LoggerService.info('Navigating to product: $productId');
        return AppPaths.product(productId: productId);
      }
    }
    return null;
  }

  /// Category route handling (.NET Core MVC to Flutter)
  String? _handleCategoryRoutes(String path, Map<String, String> queryParams) {
    // Handle /Category/{categoryId}
    String? categoryId = queryParams['categoryId'];

    // If categoryId is not in query params, try to extract from path
    if (categoryId == null || categoryId.isEmpty) {
      final segments = path.split('/');
      if (segments.length > 2) {
        // Last segment might be the category ID or SEO name
        categoryId = segments.last;
      }
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      LoggerService.info('Navigating to category: $categoryId');
      return AppPaths.category(categoryId: categoryId);
    }
    return null;
  }

  /// Account route handling (.NET Core MVC to Flutter)
  Future<String?> _handleAccountRoutes(
      String path,
      Map<String, String> queryParams,
      ) async {
    // Check if user is authenticated for protected routes
    var isAuthenticated = await _authService.isAuthenticated();
    if (path.contains('/Account/Login')) {
      return AppPaths.signin(returnUrl: AppPaths.homeIndex());
    } else if (path.contains('/Account/Register')) {
      return AppPaths.signup(returnUrl: AppPaths.homeIndex());
    } else if (!isAuthenticated) {
      // Redirect to login with returnUrl for protected routes
      return AppPaths.signin(returnUrl: AppPaths.homeIndex());
    }
    // Account info routes - only accessible if authenticated
    else if (path.contains('/Account/Info')) {
      var accountInfo =
      await (await getIt.getAsync<AccountRepository>()).getAccountInfo();
      if (accountInfo != null && accountInfo.data != null) {
        return AppPaths.profileIndex();
      }
    } else if (path.contains('/Account/Addresses')) {
      return AppPaths.customerAddresses();
    } else if (path.contains('/Account/Orders') ||
        path.contains('/Order/History')) {
      return AppPaths.customerOrders();
    } else if (path.contains('/Account/Courses')) {
      return AppPaths.customerCourses();
    } else if (path.contains('/Account/Auctions')) {
      return AppPaths.customerAuctions();
    } else if (path.contains('/Account/Notes')) {
      return AppPaths.customerNotes();
    } else if (path.contains('/Account/Documents')) {
      return AppPaths.customerDocuments();
    } else if (path.contains('/Account/ReturnRequests') ||
        path.contains('/MerchandiseReturn/History')) {
      return AppPaths.customerMerchandiseReturn();
    } else if (path.contains('/Account/DownloadableProducts')) {
      return AppPaths.customerDownloadableProducts();
    } else if (path.contains('/Account/BackInStockSubscriptions') ||
        path.contains('/OutOfStockSubscriptions/Manage')) {
      return AppPaths.customerOutOfStockSubscriptions();
    } else if (path.contains('/Account/RewardPoints') ||
        path.contains('/LoyaltyPoints/History')) {
      return AppPaths.customerLoyaltyPoints();
    } else if (path.contains('/Account/ChangePassword')) {
      return AppPaths.customerChangePassword();
    } else if (path.contains('/Account/Reviews') ||
        path.contains('/Account/ProductReviews')) {
      return AppPaths.customerReviews();
    } else if (path.contains('/Account/Activation') ||
        path.contains('/account/activation')) {
      // Handle account activation
      final token = queryParams['token'] ?? '';
      final email = queryParams['email'] ?? '';
      if (token.isNotEmpty && email.isNotEmpty) {
        return AppPaths.accountActivation(token: token, email: email);
      }
      return AppPaths.homeIndex();
    } else {
      return AppPaths.profileIndex();
    }

    return null;
  }

  /// Order and checkout routes (.NET Core MVC to Flutter)
  String? _handleOrderRoutes(String path, Map<String, String> queryParams) {
    if (path.contains('/Order/Details') || path.contains('/OrderDetails')) {
      final orderId = queryParams['orderId'] ?? queryParams['id'] ?? '';
      if (orderId.isNotEmpty) {
        return AppPaths.orderDetails(orderId: orderId);
      }
    } else if (path.contains('/Order/Shipment') ||
        path.contains('/OrderDetails/Shipment')) {
      final shipmentId = queryParams['shipmentId'] ?? queryParams['id'] ?? '';
      if (shipmentId.isNotEmpty) {
        return AppPaths.shipmentDetails(shipmentId: shipmentId);
      }
    } else if (path.contains('/ReturnRequest/Create') ||
        path.contains('/MerchandiseReturn')) {
      final orderId = queryParams['orderId'] ?? queryParams['id'] ?? '';
      if (orderId.isNotEmpty) {
        return AppPaths.merchandiseReturn(orderId: orderId);
      }
    } else if (path.contains('/ReturnRequest/Details') ||
        path.contains('/MerchandiseReturnDetails')) {
      final returnRequestId =
          queryParams['returnRequestId'] ??
              queryParams['merchandiseReturnId'] ??
              queryParams['id'] ??
              '';
      if (returnRequestId.isNotEmpty) {
        return AppPaths.merchandiseReturnDetails(
          merchandiseReturnId: returnRequestId,
        );
      }
    } else if (path.contains('/Checkout')) {
      return AppPaths.checkout();
    } else {
      // Default to orders index
      return AppPaths.ordersIndex();
    }
    return null;
  }

  /// Generate a deep link for sharing (Flutter to .NET Core MVC)
  // String generateDeepLink({
  //   required String routeName,
  //   Map<String, String> params = const {},
  // }) {
  //   // Map app routes to backend URLs
  //   switch (routeName) {
  //     case 'product':
  //       final productId = params['productId'] ?? '';
  //       return '$_baseUrl/Product/Detail?productId=$productId';
  //
  //     case 'category':
  //       final categoryId = params['categoryId'] ?? '';
  //       return '$_baseUrl/Category/$categoryId';
  //
  //     case 'search':
  //       final query = params['query'] ?? '';
  //       return '$_baseUrl/Search?q=${Uri.encodeComponent(query)}';
  //
  //     case 'cart':
  //       return '$_baseUrl/Cart';
  //
  //     case 'checkout':
  //       return '$_baseUrl/Checkout';
  //
  //     case 'account_info':
  //       return '$_baseUrl/Account/Info';
  //
  //     case 'customer_addresses':
  //       return '$_baseUrl/Account/Addresses';
  //
  //     case 'customer_orders':
  //       return '$_baseUrl/Order/History';
  //
  //     case 'customer_courses':
  //       return '$_baseUrl/Account/Courses';
  //
  //     case 'order_details':
  //       final orderId = params['orderId'] ?? '';
  //       return '$_baseUrl/OrderDetails/$orderId';
  //
  //     case 'shipment_details':
  //       final shipmentId = params['shipmentId'] ?? '';
  //       return '$_baseUrl/OrderDetails/Shipment/$shipmentId';
  //
  //     case 'merchandise_return':
  //       final orderId = params['orderId'] ?? '';
  //       return '$_baseUrl/MerchandiseReturn/$orderId';
  //
  //     case 'merchandise_return_details':
  //       final returnRequestId = params['merchandiseReturnId'] ?? '';
  //       return '$_baseUrl/MerchandiseReturnDetails/$returnRequestId';
  //
  //     case 'wishlist':
  //       return '$_baseUrl/Wishlist';
  //
  //     default:
  //       return _baseUrl;
  //   }
  // }

  // /// Share a deep link using the Share plugin
  // Future<void> shareDeepLink({
  //   required String routeName,
  //   Map<String, String> params = const {},
  //   String? subject,
  // }) async {
  //   final url = generateDeepLink(routeName: routeName, params: params);
  //   final shareSubject = subject ?? 'Check this out';
  //
  //   try {
  //     await Share.share(url, subject: shareSubject);
  //   } catch (e, stackTrace) {
  //     LoggerService.error('Error sharing deep link', e, stackTrace);
  //   }
  // }
  //
  // /// Open a deep link in an external browser
  // Future<void> openExternalLink(String url) async {
  //   try {
  //     final uri = Uri.parse(url);
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     } else {
  //       LoggerService.error('Could not launch URL: $url');
  //     }
  //   } catch (e, stackTrace) {
  //     LoggerService.error('Error launching URL', e, stackTrace);
  //   }
  // }

  @disposeMethod
  void dispose() {}
}
