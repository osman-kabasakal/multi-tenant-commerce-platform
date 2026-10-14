import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/presentation/screens/home/view_models/special_offer_item_view_model.dart';
import 'package:store_user_app/presentation/screens/home/widgets/app_special_offer_item_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';
import 'package:store_user_app/presentation/widgets/slider/view/app_slider.dart';
import 'package:store_user_app/presentation/widgets/slider/view_models/slider_item.dart';

import '../providers/special_offer_controller.dart';

class AppSpecialOffer extends StatefulHookConsumerWidget {
  const AppSpecialOffer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSpecialOfferState();
}

class _AppSpecialOfferState extends ConsumerState<AppSpecialOffer> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(specialOfferControllerProvider)
        .when(
          data:
              (offers) =>
                  offers.publicInfoModel.slide!.isNotEmpty
                      ? AppSlider(
                        height: 181,
                        onItemTap: (slideItem) async {
                          if (slideItem.url != null &&
                              slideItem.url!.isNotEmpty) {
                            var deepLinkService =
                                await getIt.getAsync<DeeplinkService>();
                            var localPath = await deepLinkService
                                .handleIncomingLink(Uri.parse(slideItem.url!));
                            if (localPath != null && localPath.isNotEmpty) {
                              context.router.pushPath(localPath);
                            }
                          }
                        },
                        itemBuilder: (slideContext, slideItem) {
                          return AppSpecialOfferItemWidget(
                            offer: SpecialOfferItemViewModel(
                              title: slideItem.title ?? '',
                              description: slideItem.subtitle ?? '',
                              imageUrl: slideItem.imageUrl,
                            ),
                          );
                        },
                        items:
                            offers.publicInfoModel.slide!
                                .map(
                                  (slideItem) => SliderItem(
                                    imageUrl:
                                        slideItem.pictureUrl ??
                                        AppConfig.instance.storeLogo,
                                    url: slideItem.link,
                                    title: slideItem.name,
                                    subtitle: slideItem.description,
                                    actionUrl: slideItem.link,
                                    id: slideItem.pictureUrl,
                                    showDescription: false,
                                  ),
                                )
                                .toList(),
                      )
                      : offers.isLoading
                      ? _buildSpecialOfferSkeleton()
                      : SizedBox.shrink(),
          loading: () => _buildSpecialOfferSkeleton(),
          error: (error, stack) => const SizedBox.shrink(),
        );
  }

  Widget _buildSpecialOfferSkeleton() {
    return const Skeleton(
      isLoading: true,
      skeleton: AppCard(
        child: SizedBox(
          height: 181,
          width: double.infinity,
          child: SizedBox.expand(),
        ),
      ),
      child: AppCard(
        child: SizedBox(
          height: 181,
          width: double.infinity,
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}
