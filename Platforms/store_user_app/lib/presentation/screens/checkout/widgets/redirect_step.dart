import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/redirect/redirect_step_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RedirectStep extends StatefulHookConsumerWidget {
  final CheckoutStepResponse redirectedMessage;
  final CheckOutRouteData routeData;
  const RedirectStep({
    super.key,
    required this.redirectedMessage,
    required this.routeData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RedirectStepState();
}

class _RedirectStepState extends ConsumerState<RedirectStep> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ref.watch(redirectStepControllerProvider(widget.routeData)).when(
              data: (data) => LoadComponentWhenVisible(
                  onVisible: () async => await ref
                      .read(redirectStepControllerProvider(widget.routeData)
                          .notifier)
                      .loadWebView(
                        widget.redirectedMessage.redirect!,
                      ),
                  builder: (context) {
                    return WebViewWidget(controller: data.webviewController);
                  }),
              error: (error, stackTrace) => Center(
                child: AppErrorWidget(message: error.toString()),
              ),
              loading: () => SkeletonListView(
                itemCount: 7,
                itemBuilder: (p0, p1) {
                  return SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 3,
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
