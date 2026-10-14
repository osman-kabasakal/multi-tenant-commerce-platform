import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/location/providers/adress_picker_controller.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_picker.dart';

@RoutePage()
class CustomerAddressesScreen extends HookConsumerWidget {
  const CustomerAddressesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeController themeController = getIt<ThemeController>();
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Adreslerim',
        backgroundColor:
            themeController.isDarkMode ? darkPrimary : Colors.white,
      ),
      body: LoadComponentWhenVisible(onVisible: () async {
        ref.invalidate(adressPickerControllerProvider);
      }, builder: (isVisible) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddressPicker(
            provider: adressPickerControllerProvider,
            controller: ref.read(adressPickerControllerProvider.notifier),
            addressEditable: true,
            selectable: false,
          ),
        );
      }),
    );
  }
}
