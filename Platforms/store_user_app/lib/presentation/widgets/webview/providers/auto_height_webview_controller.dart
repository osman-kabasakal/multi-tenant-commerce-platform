import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../view_models/auto_height_webview_model.dart';

part 'auto_height_webview_controller.g.dart';

@riverpod
class AutoHeightWebviewController extends _$AutoHeightWebviewController {
  late final WebViewController controller;
  @override
  AutoHeightWebviewModel build(String html) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {},
        onPageFinished: (_) {
          // _updateHeight();
        },
      ))
      ..addJavaScriptChannel(
        'store_text_height',
        onMessageReceived: (JavaScriptMessage message) {
          final double height = double.parse(message.message);
          state = state.copyWith(
            height: height,
          );
          Future.delayed(Duration(milliseconds: 100), () {
            state = state.copyWith(isLoading: false);
          });
        },
      );
    loadHtml(html);
    return AutoHeightWebviewModel(
      gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
    );
  }

  Future<void> loadHtml(String html) async {
    await controller.loadHtmlString(_wrapHtml(html));
    // await _updateHeight();
  }

  String _wrapHtml(String content) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              margin: 0;
              overflow: hidden;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
              font-size: 16px;
              line-height: 1.5;
              color: #333;
            }
            
            h1 { font-size: 24px; margin-bottom: 16px; }
            h2 { font-size: 20px; margin-bottom: 12px; }
            h3 { font-size: 18px; margin-bottom: 8px; }
            
            p { 
              font-size: 18px; 
              margin-bottom: 16px;
              line-height: 1.6;
              color: #333333;
            }
            
            li { font-size: 16px; margin-bottom: 8px; }
            
            a { color: #007AFF; }
          </style>
        </head>
        <body>
          $content

          <script>
          document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
              store_text_height.postMessage( document.documentElement.scrollHeight);
            }, 300);
          });
          </script>
        </body>
      </html>
    ''';
  }
}
