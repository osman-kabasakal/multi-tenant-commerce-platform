// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// // import 'package:http/http.dart';
// import 'package:signalr_netcore/errors.dart';
// import 'package:signalr_netcore/ihub_protocol.dart';
// import 'package:logging/logging.dart';
// import 'package:signalr_netcore/signalr_http_client.dart';
// import 'package:signalr_netcore/utils.dart';
// import 'package:store_user_app/core/di/injection_container.dart';
// import 'package:store_user_app/core/di/modules/dio_module.dart';

// // typedef OnHttpClientCreateCallback = void Function(Client httpClient);

// class AppSignalRHttpClient extends SignalRHttpClient {
//   // Properties

//   final Logger? _logger;
//   // final OnHttpClientCreateCallback? _httpClientCreateCallback;

//   // Methods

//   AppSignalRHttpClient(
//     Logger? logger,
//   ) : _logger = logger;

//   @override
//   Future<SignalRHttpResponse> send(SignalRHttpRequest request) {
//     // Check that abort was not signaled before calling send
//     if ((request.abortSignal != null) && request.abortSignal!.aborted!) {
//       return Future.error(AbortError());
//     }

//     if ((request.method == null) || (request.method!.isEmpty)) {
//       return Future.error(ArgumentError("No method defined."));
//     }

//     if ((request.url == null) || (request.url!.isEmpty)) {
//       return Future.error(ArgumentError("No url defined."));
//     }

//     return Future<SignalRHttpResponse>(() async {
//       final uri = Uri.parse(request.url!);

//       final abortFuture = Future<void>(() {
//         final completer = Completer<void>();
//         if (request.abortSignal != null) {
//           request.abortSignal!.onabort = () {
//             if (!completer.isCompleted) completer.completeError(AbortError());
//           };
//         }
//         return completer.future;
//       });

//       final isJson = request.content != null &&
//           request.content is String &&
//           (request.content as String).startsWith('{');

//       var headers = MessageHeaders();

//       headers.setHeaderValue('X-Requested-With', 'FlutterHttpClient');
//       headers.setHeaderValue(
//           'content-type',
//           isJson
//               ? 'application/json;charset=UTF-8'
//               : 'text/plain;charset=UTF-8');

//       headers.addMessageHeaders(request.headers);

//       _logger?.finest(
//           "HTTP send: url '${request.url}', method: '${request.method}' content: '${request.content}' content length = '${(request.content as String).length}' headers: '$headers'");

//       final httpRespFuture = await Future.any([
//         _sendHttpRequest((await getIt.getAsync<SignalRDioClient>()).client,
//             request, uri, headers),
//         abortFuture
//       ]);
//       final httpResp = httpRespFuture as Response<String>;

//       if (request.abortSignal != null) {
//         request.abortSignal!.onabort = null;
//       }

//       if (((httpResp.statusCode ?? 0) >= 200) &&
//           ((httpResp.statusCode ?? 0) < 300)) {
//         String content;
//         final contentTypeHeader = httpResp.headers.value('content-type');
//         final isJsonContent = contentTypeHeader == null ||
//             contentTypeHeader.startsWith('application/json');
//         if (isJsonContent) {
//           content = httpResp.data ?? '';
//         } else {
//           content = httpResp.data ?? '';
//           // When using SSE and the uri has an 'id' query parameter the response is not evaluated, otherwise it is an error.
//           if (isStringEmpty(uri.queryParameters['id'])) {
//             throw ArgumentError(
//                 "Response Content-Type not supported: $contentTypeHeader");
//           }
//         }

//         return SignalRHttpResponse(httpResp.statusCode!,
//             statusText: httpResp.statusMessage, content: content);
//       } else {
//         throw HttpError(httpResp.statusMessage, httpResp.statusCode ?? 0);
//       }
//     });
//   }

//   Future<Response<String>> _sendHttpRequest(
//     Dio httpClient,
//     SignalRHttpRequest request,
//     Uri uri,
//     MessageHeaders headers,
//   ) {
//     Future<Response<String>> httpResponse;

//     switch (request.method!.toLowerCase()) {
//       case 'post':
//         httpResponse = httpClient.postUri<String>(uri,
//             data: request.content, options: Options(headers: headers.asMap));
//         break;
//       case 'put':
//         httpResponse = httpClient.putUri<String>(uri,
//             data: request.content, options: Options(headers: headers.asMap));
//         break;
//       case 'delete':
//         httpResponse = httpClient.deleteUri<String>(uri,
//             data: request.content, options: Options(headers: headers.asMap));
//         break;
//       case 'get':
//       default:
//         httpResponse = httpClient.getUri<String>(uri,
//             options: Options(headers: headers.asMap));
//     }

//     final hasTimeout = (request.timeout != null) && (0 < request.timeout!);
//     if (hasTimeout) {
//       httpResponse =
//           httpResponse.timeout(Duration(milliseconds: request.timeout!));
//     }

//     return httpResponse;
//   }
// }
