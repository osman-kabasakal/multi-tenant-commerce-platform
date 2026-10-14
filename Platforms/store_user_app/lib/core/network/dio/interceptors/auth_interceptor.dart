import 'package:dio/dio.dart';
import 'package:store_user_app/core/di/injection_container.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/logger/logger_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService authService;

  AuthInterceptor(this.authService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.extra.containsKey('noCredentials') ||
        !(options.extra['noCredentials'] as bool)) {
      final token = await authService.getAccessToken();
      if (token != null) {
        // CSRF token gerekiyorsa direkt olarak token nesnesinden al
        // Eğer token'da yoksa yeni bir token al
        if (options.extra.containsKey('csrf') &&
            (options.extra['csrf'] as bool)) {
          if (token.csrfToken != null && token.csrfToken!.isNotEmpty) {
            options.headers['X-CSRF-TOKEN'] = token.csrfToken;
          } else {
            options.headers['X-CSRF-TOKEN'] = await authService.getCsrfToken();
          }
          // CSRF isteklerinde credentials'ları ve çerezleri yolla
          options.extra['withCredentials'] = true;
        }

        if (options.method != 'get' && options.data != null) {
          options.headers['Content-Type'] = 'application/json';
        }

        if (token.bearerToken != null && token.bearerToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${token.bearerToken}';
        }
      }
    }

    if (options.method == "get") {
      options.headers["Accept"] = "*/*";
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        (!err.requestOptions.extra.containsKey('ignoreAuth') ||
            !(err.requestOptions.extra['ignoreAuth'] as bool))) {
      try {
        // Token yenileme
        // final isRefreshed = await authService.refreshToken();
        // if (isRefreshed) {
        //   // Yeni token ile isteği tekrarla
        //   final newToken = await authService.getAccessToken();
        //   err.requestOptions.headers['Authorization'] =
        //       'Bearer ${newToken?.bearerToken}';
        //   err.requestOptions.headers['X-CSRF-TOKEN'] = newToken?.csrfToken;
        //   err.requestOptions.headers['x-store-token'] = newToken?.accessToken;
        //   err.requestOptions.extra['ignoreAuth'] = true;
        //   final response = await getIt<Dio>().fetch(err.requestOptions);
        //   return handler.resolve(response);
        // }
      } catch (e) {
        LoggerService.error('Token refresh error', e);
      }
    }

    handler.next(err);
  }
}
