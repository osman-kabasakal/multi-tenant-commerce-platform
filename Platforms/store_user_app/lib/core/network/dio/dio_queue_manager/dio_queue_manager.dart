import 'package:dio/dio.dart';

import '../../../models/network/queued_request.dart';

class DioQueueManager {
  final Dio _dio;
  final _requestQueue = <QueuedRequest>[];
  bool _isProcessing = false;

  DioQueueManager(this._dio);

  /// Add a request to the queue and return a Future that will complete
  /// when the request is processed
  Future<Response> enqueue(QueuedRequest request) {
    _requestQueue.add(request);
    _processQueue();
    return request.completer.future;
  }

  /// Process queued requests sequentially
  Future<void> _processQueue() async {
    if (_isProcessing || _requestQueue.isEmpty) return;

    _isProcessing = true;

    while (_requestQueue.isNotEmpty) {
      final request = _requestQueue[0];

      try {
        await _dio
            .request(
              request.path,
              data: request.data,
              queryParameters: request.queryParameters,
              options: request.options?.copyWith(method: request.method),
              cancelToken: request.cancelToken,
              onSendProgress: request.onSendProgress,
              onReceiveProgress: request.onReceiveProgress,
            )
            .then((response) => request.completer.complete(response))
            .catchError((error) => request.completer.completeError(error));
      } catch (error) {
        request.completer.completeError(error);
      }

      _requestQueue.removeAt(0);
    }

    _isProcessing = false;
  }

  /// Clear all pending requests in the queue
  void clear() {
    for (var request in _requestQueue) {
      request.completer.completeError(
        DioException(
          requestOptions: RequestOptions(path: request.path),
          error: 'Request cancelled - queue cleared',
        ),
      );
    }
    _requestQueue.clear();
  }
}
