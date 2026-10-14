import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';

import '../providers/checkout_state.dart';
import '../view_models/check_out_route_data.dart';
import '../view_models/checkout_step.dart';

@RoutePage()
class CheckoutScreen extends ConsumerStatefulWidget {
  final bool requireAuthorization;
  final bool checkoutAsGuest;

  const CheckoutScreen({
    super.key,
    this.requireAuthorization = true,
    this.checkoutAsGuest = false,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  CheckOutRouteData get routeData => CheckOutRouteData(
    requireAuthorization: widget.requireAuthorization,
    checkoutAsGuest: widget.checkoutAsGuest,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: ref.watch(checkoutControllerProvider(routeData)).when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) => data.currentStep == CheckoutStep.fail
                ? _buildErrorState(data)
                : _buildCheckoutContent(data),
            error: (error, stack) => _buildErrorState(error),
            loading: () => _buildLoadingState(),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutContent(CheckoutState data) {
    return ref
        .read(checkoutControllerProvider(routeData).notifier)
        .currentStepContent();
  }

  Widget _buildErrorState(Object error) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: AppErrorWidget(
            message:
            'Ödeme işlemi sırasında bir hata oluştu: ${error.toString()}',
            type: ErrorType.error,
            onRetry: () {
              ref.invalidate(checkoutControllerProvider(routeData));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
