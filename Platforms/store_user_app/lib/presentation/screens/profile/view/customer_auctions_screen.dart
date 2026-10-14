import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

@RoutePage()
class CustomerAuctionsScreen extends HookConsumerWidget {
  const CustomerAuctionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Müzayede Katılımlarım'),
      body: Center(
        child: AppErrorWidget(
          message: 'Müzayedeler destklenmiyor',
          type: ErrorType.info,
          isDismissible: false,
        ),
      ),
    );
  }
}
