import 'dart:async';

import 'package:dio/dio.dart';

class QueuedRequest {
  final String method;
  final String path;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
  final Completer<Response> completer;

  QueuedRequest({
    required this.method,
    required this.path,
    this.data,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
    required this.completer,
  });
}
