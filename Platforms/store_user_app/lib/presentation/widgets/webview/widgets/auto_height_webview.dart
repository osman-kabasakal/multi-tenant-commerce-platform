import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:store_user_app/presentation/widgets/webview/providers/auto_height_webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AutoHeightWebview extends HookConsumerWidget {
  final bool scrollable;
  final String htmlContent;
  final EdgeInsets padding;
  const AutoHeightWebview(
      {super.key,
      required this.htmlContent,
      this.padding = EdgeInsets.zero,
      this.scrollable = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(autoHeightWebviewControllerProvider(htmlContent));
    var controller =
        ref.watch(autoHeightWebviewControllerProvider(htmlContent).notifier);

    return SizedBox(
      height: state.height < 100 ? 100 : state.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Padding(
              padding: padding,
              child: WebViewWidget(
                key: UniqueKey(),
                controller: controller.controller,
                gestureRecognizers: scrollable ? {} : state.gestureRecognizers,
              ),
            ),
          ),
          Visibility(
              visible: state.isLoading,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                ),
                child: Container(
                  color: Colors.white,
                  child: SizedBox.expand(
                    child: Skeletonizer(
                      enabled: state.isLoading,
                      justifyMultiLineText: false,
                      textBoneBorderRadius:
                          TextBoneBorderRadius.fromHeightFactor(.5),
                      child: Skeleton.shade(
                        shade: state.isLoading,
                        child: Card(child: Bone.text()),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
