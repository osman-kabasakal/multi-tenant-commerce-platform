import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';

class _Auth extends Fake implements AuthService {
  @override
  Future<bool> isAuthenticated() async => false;
}

void main() {
  late DeeplinkService links;
  setUp(() {
    AppConfig.init(apiBaseUrl: 'https://shop.example.test', enableLogging: false,
      environment: 'test', cacheExpirationDuration: const Duration(minutes: 1),
      storeLogo: '', appTitle: 'Fixture', appPackageName: 'com.example.fixture');
    links = DeeplinkService(_Auth(), Dio());
  });
  test('controller links match independently of letter case without a slug lookup', () async {
    for (final path in ['/Account/Register', '/account/register', '/ACCOUNT/REGISTER']) {
      expect(await links.handleIncomingLink(Uri.parse('https://shop.example.test$path')), AppPaths.signup(returnUrl: AppPaths.homeIndex()));
    }
    expect(await links.handleIncomingLink(Uri.parse('https://shop.example.test/Account/Login')), AppPaths.signin(returnUrl: AppPaths.homeIndex()));
  });
  test('product, category, cart and order notifications resolve to actual app routes', () async {
    final cases = {
      '/Product/Detail?productId=abc123': AppPaths.product(productId: 'abc123'),
      '/Category/abc123': AppPaths.category(categoryId: 'abc123'),
      '/Cart': AppPaths.cart(),
      '/Order/Details?orderId=abc123': AppPaths.orderDetails(orderId: 'abc123'),
      '/': AppPaths.homeIndex(),
    };
    for (final entry in cases.entries) {
      expect(await links.handleIncomingLink(Uri.parse('https://shop.example.test'+entry.key)), entry.value, reason: entry.key);
    }
  });
  test('activation links work before login and preserve their opaque query values', () async {
    expect(await links.handleIncomingLink(Uri.parse('https://shop.example.test/Account/Activation?token=AbC%2B123&email=owner%40example.test')),
      AppPaths.accountActivation(token: 'AbC+123', email: 'owner@example.test'));
  });
  test('admin, credential-bearing, protocol-relative and unsupported scheme links are refused', () async {
    for (final value in ['https://shop.example.test/Admin', '/ADMIN/Product/List', 'https://user:password@shop.example.test/Cart', '//foreign.example/Cart', 'javascript:alert(1)', 'file:///Cart']) {
      expect(await links.handleIncomingLink(Uri.parse(value)), isNull, reason: value);
    }
  });
}
