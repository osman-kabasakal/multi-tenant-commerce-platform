import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';

class ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onCartTap;

  const ProductAppBar({
    super.key,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 10,
      shadowColor: theme.brightness == Brightness.dark
          ? Colors.grey
          : const Color(0xffE85C31).withValues(alpha: 0.10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      actions: [
        if (onCartTap != null)
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) => ref
                .watch(shoppingCartUseCaseProvider.selectAsync((s) => s.cart)),
            builder: (context, ref, snapshot) {
              var value = snapshot.data;
              return _buildIconButton(
                context,
                icon: getIt<ThemeController>().isDarkMode
                    ? cartDarkIcon
                    : cartLightIcon,
                onTap: () {
                  context.router.push(CartRoute());
                },
                isActive: value?.items?.isNotEmpty ?? false,
              );
            },
            loadingBuilder: (context, ref, snapshot) {
              return _buildIconButton(
                context,
                icon: getIt<ThemeController>().isDarkMode
                    ? cartDarkIcon
                    : cartLightIcon,
                onTap: () {
                  context.router.push(CartRoute());
                },
              );
            },
            errorBuilder: (context, ref, snapshot) {
              return _buildIconButton(
                context,
                icon: getIt<ThemeController>().isDarkMode
                    ? cartDarkIcon
                    : cartLightIcon,
                onTap: () {
                  // Handle cart tap
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required String icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: getIt<ThemeController>().isDarkMode ? cardDark : colorGrey50,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            colorFilter: !isActive
                ? ColorFilter.mode(
                    getIt<ThemeController>().isDarkMode
                        ? Colors.white
                        : colorGrey500,
                    BlendMode.srcIn,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
