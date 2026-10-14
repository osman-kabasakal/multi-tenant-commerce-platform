import 'dart:async';

import 'package:dio/dio.dart';
import 'package:store_user_app/core/models/network/queued_request.dart';
import 'package:store_user_app/core/network/dio/dio_queue_manager/dio_queue_manager.dart';

class QueuedInterceptor extends Interceptor {
  final DioQueueManager _queueManager;

  QueuedInterceptor(this._queueManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final completer = Completer<Response>();
    var zone = Zone.current;
    _queueManager.enqueue(QueuedRequest(
      method: options.method,
      path: options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        headers: options.headers,
        contentType: options.contentType,
        responseType: options.responseType,
        extra: options.extra,
      ),
      cancelToken: options.cancelToken,
      completer: completer,
    ));
    completer.future.then(
      (response) => zone.run(() => handler.resolve(response, true)),
      onError: (error) =>
          zone.run(() => handler.reject(error as DioException, true)),
    );
  }
}
