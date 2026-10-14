import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/entities/models/pages/page_model/page_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/either_or.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;

class RequireLoginBottomSheet extends HookConsumerWidget {
  final bool showCheckoutAsGuest;
  final PageModel? pageModel;
  const RequireLoginBottomSheet({
    super.key,
    required this.showCheckoutAsGuest,
    required this.pageModel,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    final (
      :pending,
      :snapshot,
      hasError: _,
      loaderColor: _,
      loaderStrokeWidth: _,
    ) = useAsyncTask();
    return BaseBottomSheet(
      width: context.width(),
      title: pageModel?.title,
      maxHeightPercentage: 1,
      maxWidthPercentage: 1,
      contentBuilder: (context) {
        return AppCard(child: Html(data: pageModel?.body ?? ''));
      },
      footerBuilder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppCommonButton(
                    onPressed: () {
                      context.router.replace(
                        SignupRoute(returnUrl: '/shopping-cart'),
                      );
                    },
                    text: signup,
                    height: 58,
                    bgColor:
                        themeController.isDarkMode
                            ? app_colors.borderDark
                            : app_colors.primaryColor100,
                    textColor:
                        themeController.isDarkMode
                            ? whiteColor
                            : app_colors.colorPrimary,
                  ),
                ),
                15.width,
                Expanded(
                  child: AppCommonButton(
                    onPressed: () async {
                      context.router.replace(
                        SigninRoute(returnUrl: '/shopping-cart'),
                      );
                    },
                    text: signIn,
                    height: 58,
                  ),
                ),
              ],
            ),
            if (showCheckoutAsGuest) ...[
              30.height,
              EitherOr(
                orText: dontKnowWhatToDo,
                isDarkMode: themeController.isDarkMode,
              ),
              10.height,
              TextButton(
                onPressed:
                    snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : () {
                          pending.value =
                              (() async {
                                context.router.popAndPush(
                                  CheckoutRoute(
                                    requireAuthorization: false,
                                    checkoutAsGuest: true,
                                  ),
                                );
                              })();
                        },
                child: Text.rich(
                  TextSpan(
                    text: signUpWithSpace,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: app_colors.colorPrimary,
                    ),
                  ),
                ),
              ).center(),
            ],
            if (context.isIOS) 20.height,
          ],
        );
      },
    );
  }
}
