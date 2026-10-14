import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_height_webview_model.freezed.dart';

@freezed
class AutoHeightWebviewModel with _$AutoHeightWebviewModel {
  const factory AutoHeightWebviewModel({
    @Default(1) double height,
    @Default(true) bool isLoading,
    required Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  }) = _AutoHeightWebviewModel;
}
