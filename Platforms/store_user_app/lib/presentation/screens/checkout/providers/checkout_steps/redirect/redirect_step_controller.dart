import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/reidrect_step_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'redirect_step_controller.g.dart';

@riverpod
class RedirectStepController extends _$RedirectStepController {
  late final Dio _dio;
  late final CookieManager _cookieManager;
  @override
  FutureOr<RedirectStepViewModel> build(CheckOutRouteData routeData) async {
    _dio = await getIt.getAsync<Dio>();
    _cookieManager = getIt.get<CookieManager>();

    var controller =
    WebViewController(
      onPermissionRequest: (request) async {
        LoggerService.info(
          'Permission Request: ${request.types.map((e) => e.name).join(',')}',
        );
        await request.deny();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (error) {
            ref.read(checkoutControllerProvider(routeData).notifier).execute({
              'error': true,
              'message':
              'Ödeme sayfası yüklenirken bir hata oluştu: ${error.response?.statusCode}',
            });
            LoggerService.error(
              error.toString(),
              error,
              StackTrace.current,
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            var navUri = Uri.tryParse(error.url??"");
            if(navUri == null){
              return;
            }
            if(navUri.path.startsWith('/checkout/completed')){
              return;
            }
            ref.read(checkoutControllerProvider(routeData).notifier).execute({
              'error': true,
              'message':
              'Ödeme işlemi sırasında bir hata oluştu: ${error.description}',
              'errorCode': error.errorCode.toString(),
            });
            LoggerService.error(
              error.toString(),
              error,
              StackTrace.current,
            );
          },
          onNavigationRequest: (request) async {
            if(request.url.contains("about:blank")){
              return NavigationDecision.navigate;
            }
            var navUri = Uri.tryParse(request.url);
            if(navUri == null){
              return NavigationDecision.prevent;
            }
            if (_checkIsInternalUri(navUri) &&
                navUri.path.startsWith('/checkout/completed')) {
              await ref
                  .read(checkoutControllerProvider(routeData).notifier)
                  .execute({
                'complete': true,
                'orderId': navUri.pathSegments.lastOrNull,
              });
              return NavigationDecision.prevent;
            }
            if(Uri.tryParse(request.url)!=null){
              return NavigationDecision.navigate;
            }else{
              return NavigationDecision.prevent;
            }
          },
          onUrlChange: (change) {
            LoggerService.info(change.url);
            if (change.url != null &&
                Uri.parse(
                  change.url!,
                ).path.startsWith('/checkout/completed')) {}
          },
        ),
      );

    return RedirectStepViewModel(webviewController: controller);
  }

  Future<void> loadWebView(String url) async {
    try {
      if (state.isLoading) return;
      var uri = Uri.tryParse(url);
      if(uri == null){
        return;
      }
      if (_checkIsInternalUri(uri)) {
        var localUri = Uri.parse('${AppConfig.instance.apiBaseUrl}${uri.path}');
        localUri = localUri.replace(queryParameters: {...uri.queryParameters});

        await (await getIt.getAsync<AuthService>()).refreshToken();

        var redirectUriResponse = await _dio.get(localUri.toString());

        if (redirectUriResponse.data != null &&
            redirectUriResponse.data is Map<String, dynamic> &&
            redirectUriResponse.data!['redirectUri'] != null) {
          var redirectUri = Uri.parse(redirectUriResponse.data!['redirectUri']);
          if (_checkIsInternalUri(redirectUri)) {
            if (redirectUri.path.startsWith('/checkout/completed')) {
              await ref
                  .read(checkoutControllerProvider(routeData).notifier)
                  .execute({
                'complete': true,
                'orderId': redirectUri.pathSegments.lastOrNull,
              });
              return;
            }
            var internalUri = Uri.parse(
              '${AppConfig.instance.apiBaseUrl}${redirectUri.path}',
            );
            internalUri = internalUri.replace(
              queryParameters: {...redirectUri.queryParameters},
            );
            var formResponse = await _dio.get(
              internalUri.toString(),
              options: Options(extra: {'csrf': true}),
            );
            if (formResponse.data! is! String) {
              throw Exception('Invalid response');
            }
            var cookiesForReq = await _cookieManager.cookieJar.loadForRequest(
              localUri,
            );
            final webViewCookieManager = WebViewCookieManager();

            for (var cookie in cookiesForReq) {
              await webViewCookieManager.setCookie(
                WebViewCookie(
                  name: cookie.name,
                  value: cookie.value,
                  domain: cookie.domain ?? localUri.host,
                  path: cookie.path ?? '/',
                ),
              );
            }

            await state.requireValue.webviewController.loadHtmlString(
              formResponse.data!,
            );
          } else {
            state.requireValue.webviewController.loadRequest(redirectUri);
          }
        }
      } else {
        state.requireValue.webviewController.loadRequest(uri);
      }
    } on DioException catch (e) {
      LoggerService.error(e);
      String errorMessage = 'Ödeme işlemi sırasında bir hata oluştu.';
      String errorCode = 'NETWORK_ERROR';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage =
        'Ödeme sayfası yüklenirken zaman aşımına uğradı. Lütfen internet bağlantınızı kontrol edip tekrar deneyiniz.';
        errorCode = 'TIMEOUT';
      } else if (e.response != null) {
        errorMessage =
        'Ödeme sayfasına bağlanırken bir hata oluştu: HTTP ${e.response?.statusCode}';
        errorCode = 'HTTP_${e.response?.statusCode}';
      }

      ref.read(checkoutControllerProvider(routeData).notifier).execute({
        'error': true,
        'message': errorMessage,
        'errorCode': errorCode,
      });
    } on TimeoutException catch (e) {
      LoggerService.error(e);
      ref.read(checkoutControllerProvider(routeData).notifier).execute({
        'error': true,
        'message': 'İşlem zaman aşımına uğradı: ${e.message}',
        'errorCode': 'TIMEOUT',
      });
    } catch (e) {
      LoggerService.error(e);
      String errorMessage = 'Ödeme işlemi sırasında bir hata oluştu.';

      if (e is Exception) {
        errorMessage =
        'Ödeme sayfası yüklenirken beklenmeyen bir hata oluştu: ${e.toString()}';
      }

      ref.read(checkoutControllerProvider(routeData).notifier).execute({
        'error': true,
        'message': errorMessage,
        'errorCode': 'UNKNOWN_ERROR',
      });
    }
  }

  bool _checkIsInternalUri(Uri uri) {
    var appconfigBaseUri = Uri.tryParse(AppConfig.instance.apiBaseUrl);
    if(appconfigBaseUri==null){
      return false;
    }
    var checkAppConfigOrigin =
        uri.isAbsolute && uri.origin == appconfigBaseUri.origin;
    var checkLocalhostOrigin =
        uri.isAbsolute &&
            (AppConfig.instance.apiBaseUrl.contains('10.0.2.2') &&
                uri.origin.contains('famizyo'));
    return !uri.isAbsolute || checkAppConfigOrigin || checkLocalhostOrigin;
  }
}
