import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/cash_on_delivery/widget/cash_on_delivery_widget.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/widget/iyzipay.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';

class PaymentInfoStep extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final PaymentInfoStepModel paymentInfoStepModel;

  const PaymentInfoStep({
    super.key,
    required this.routeData,
    required this.paymentInfoStepModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentInfoStepState();
}

class _PaymentInfoStepState extends ConsumerState<PaymentInfoStep> {
  late final ValueNotifier<PaymentInfoStepModel> _paymentInfoModelState;
  late final Map<
    String,
    Widget Function(
      PaymentInfoStepModel paymentInfoModel,
      CheckOutRouteData routeData,
    )
  >
  paymentProviders;

  @override
  void initState() {
    super.initState();
    _paymentInfoModelState = ValueNotifier(widget.paymentInfoStepModel);
    paymentProviders = {
      'Payments.Iyzico':
          (paymentInfoModel, routeData) =>
              Iyzipay(paymentInfoModel: paymentInfoModel, routeData: routeData),
      'Payments.CashOnDelivery':
          (paymentInfoModel, routeData) => CashOnDeliveryWidget(
            paymentInfoModel: paymentInfoModel,
            routeData: routeData,
          ),
      'Payments.CashOnDelivery.CreditCard':
          (paymentInfoModel, routeData) => CashOnDeliveryWidget(
        paymentInfoModel: paymentInfoModel,
        routeData: routeData,
      ),
    };
  }

  @override
  void dispose() {
    _paymentInfoModelState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return paymentProviders[widget.paymentInfoStepModel.systemName!]!(
      widget.paymentInfoStepModel,
      widget.routeData,
    );
  }
}
