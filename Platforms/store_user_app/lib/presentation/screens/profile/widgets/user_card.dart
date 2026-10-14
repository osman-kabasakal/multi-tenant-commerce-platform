import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_info_model/customer_info_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';

class UserCard extends HookConsumerWidget {
  final CustomerInfoModel customer;
  const UserCard({super.key, required this.customer});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: SvgPicture.asset(
              customerPublicProfileIcon,
              height: 80,
              width: 80,
            ),
          ),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${customer.firstName} ${customer.lastName}',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeController.isDarkMode ? Colors.white : textColor,
                  ),
                ),
                8.height,
                Text(
                  '${customer.email}',
                  style: context.textTheme.bodyMedium?.copyWith(
                      color: themeController.isDarkMode
                          ? colorGrey300
                          : colorGrey800,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: SvgPicture.asset(
              edit1Icon,
              height: 18,
              width: 18,
            ),
            onPressed: () async {
              context.router
                  .push(AccountInfoRoute(customerInfoModel: customer));
            },
          ),
        ],
      ),
    );
  }
}
