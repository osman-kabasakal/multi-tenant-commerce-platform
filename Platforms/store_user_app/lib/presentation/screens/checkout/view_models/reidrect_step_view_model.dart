import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'reidrect_step_view_model.freezed.dart';

@freezed
class RedirectStepViewModel with _$RedirectStepViewModel {
  const factory RedirectStepViewModel({
    required WebViewController webviewController,
  }) = _RedirectStepViewModel;
}
