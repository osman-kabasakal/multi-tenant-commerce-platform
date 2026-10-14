import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';

class CashOnDeliveryWidget extends StatefulHookConsumerWidget {
  final CheckOutRouteData routeData;
  final PaymentInfoStepModel paymentInfoModel;
  const CashOnDeliveryWidget({
    super.key,
    required this.paymentInfoModel,
    required this.routeData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CashOnDeliveryWidgetState();
}

class _CashOnDeliveryWidgetState extends ConsumerState<CashOnDeliveryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleText: 'Ödeme Bilgileri',
      ),
      body: FutureBuilder(
        future:
            (() async => (await getIt.getAsync<Dio>()).get(
              widget.paymentInfoModel.paymentUrl!,
            ))(),
        builder: (snapContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Hata oluştu'));
          }
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Html(data: snapshot.data?.data),
            );
          }
          return const Center(child: Text('Ödeme Bilgileri Yüklenemedi'));
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: AppCommonButton(
          text: 'Devam Et',
          bgColor: colorPrimary,
          onPressed: () async {
            await ref
                .read(checkoutControllerProvider(widget.routeData).notifier)
                .execute({});
          },
        ),
      ),
    );
  }
}
