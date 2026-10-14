import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_user_app/core/models/network/redirect_response.dart';

import 'package:store_user_app/core/models/network/api_response.dart';

class ChallengeRedirectInterceptor extends Interceptor {
  // final Ref ref;

  ChallengeRedirectInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options.copyWith(
      headers: options.headers..addAll({'cookie': options.headers['cookie']}),
    ));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Redirect kontrolü
    if (_isRedirectResponse(response.statusCode)) {
      final location = response.headers.value('location');
      if (location != null) {
        try {
          final redirectUri = Uri.parse(location);
          if (response.requestOptions.responseType == ResponseType.json) {
            if (response.requestOptions.extra.containsKey('responseType') &&
                response.requestOptions.extra['responseType'] != null) {
              switch (response.requestOptions.extra['responseType']) {
                case ApiResponse apiResponse:
                  response.data = jsonDecode(jsonEncode(apiResponse
                      .copyWith(
                        meta: response.extra,
                        redirect: RedirectResponse(
                          redirectUri: redirectUri,
                          responseStatus: response.statusCode,
                        ),
                      )
                      .toJson((i) => null)));
                  break;

                case RedirectResponse _:
                  response.data = jsonDecode(jsonEncode(
                    RedirectResponse(
                            redirectUri: redirectUri,
                            responseStatus: response.statusCode)
                        .toJson(),
                  ));
              }
            } else {
              response.data = {
                'redirectUri': redirectUri.toString(),
                'responseStatus': response.statusCode
              };
            }
          } else {
            throw DioException(
              requestOptions: response.requestOptions,
              error: 'Redirect response requires JSON response type',
            );
          }
        } catch (e) {
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: 'Invalid redirect URL: $location',
            ),
          );
          return;
        }
      }
    } else if (response.data != null &&
        response.requestOptions.extra.containsKey('responseType') &&
        response.requestOptions.extra['responseType'] is ApiResponse &&
        response.data != null) {
      switch (response.requestOptions.extra['responseType']) {
        case ApiResponse apiResponse:
          if (response.data is Map) {
            var dataJson = jsonEncode(response.data);
            response.data = jsonDecode(jsonEncode(apiResponse
                .copyWith(
                  meta: response.extra,
                )
                .toJson((i) => null)));

            response.data['data'] = jsonDecode(dataJson);
          }

          if (response.data is List) {
            var dataJson = jsonEncode(response.data);
            response.data = jsonDecode(jsonEncode(apiResponse
                .copyWith(
                  meta: response.extra,
                )
                .toJson((i) => null)));
            response.data['data'] = jsonDecode(dataJson);
          }

          if (response.data is String ||
              response.data is num ||
              response.data is bool ||
              response.data == null) {
            response.data = jsonDecode(jsonEncode(apiResponse
                .copyWith(
                  meta: response.extra,
                )
                .toJson((i) => null)));
            response.data['data'] = null;
          }
          break;
      }
    }
    handler.next(response);
  }

  // @override
  // Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
  //   if (_isChallenge(err.response?.statusCode)) {
  //     final requestStore = ref.read(challengeRequestStoreProvider);
  //     final challengeNotifier = ref.read(challengeStateProvider.notifier);
  //     final popupNotifier = ref.read(authPopupStateProvider.notifier);

  //     // Challenge durumunu kaydet
  //     final requestId = DateTime.now().millisecondsSinceEpoch.toString();
  //     requestStore.storeRequest(requestId, err.requestOptions);

  //     challengeNotifier.setChallengeRequest(err.requestOptions);

  //     // Popup gösterim kontrolü
  //     if (!popupNotifier.shouldShowPopup(requestId)) {
  //       // Önceki tercih varsa ona göre işlem yap
  //       final currentState = ref.read(authPopupStateProvider);
  //       if (currentState?.lastChoice == 'guest') {
  //         handler.next(err); // Misafir olarak devam et
  //         return;
  //       }
  //     }

  //     // Popup göster
  //     popupNotifier.showPopup(
  //       showGuestOption: _shouldShowGuestOption(err.requestOptions),
  //     );

  //     try {
  //       // Popup sonucunu bekle
  //       final response = await requestStore.awaitResponse(requestId);
  //       handler.resolve(response);
  //     } catch (error) {
  //       challengeNotifier.setError(error.toString());
  //       handler.next(err);
  //     } finally {
  //       challengeNotifier.clearChallenge();
  //       popupNotifier.clearPopup();
  //     }
  //   } else {
  //     handler.next(err);
  //   }
  // }

  bool _isRedirectResponse(int? statusCode) {
    return statusCode == 301 || statusCode == 302;
  }

  // bool _isChallenge(int? statusCode) {
  //   return statusCode == 401;
  // }

  // bool _shouldShowGuestOption(RequestOptions options) {
  //   // Belirli endpoint'ler için misafir seçeneğini gösterme
  //   final restrictedPaths = ['/checkout', '/profile'];
  //   return !restrictedPaths.any((path) => options.path.contains(path));
  // }
}
