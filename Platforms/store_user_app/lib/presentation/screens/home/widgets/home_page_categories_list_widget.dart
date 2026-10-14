import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/presentation/screens/home/providers/home_page_categories_controller.dart';
import 'package:store_user_app/presentation/screens/home/view_models/home_page_categories_view_model.dart';
import 'package:store_user_app/presentation/screens/home/view_models/home_page_category_item_view_model.dart';
import 'package:store_user_app/presentation/screens/home/widgets/home_page_category_item_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class HomePageCategoriesListWidget extends HookConsumerWidget {
  const HomePageCategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Consumer(builder: (consContext, consRef, consChild) {
        return consRef.watch(homePageCategoriesControllerProvider).when(
              data: (data) {
                return LoadComponentWhenVisible(
                  key: ValueKey(Uuid().v4()),
                  showLoadingIndicator: false,
                  visibilityFraction: 0,
                  onVisible: () async {
                    if (!data.isLoading) return;
                    getIt<BackgroundTaskQueue>().enqueueTask((ct) async {
                      await ref
                          .read(homePageCategoriesControllerProvider.notifier)
                          .loadState();
                    });
                  },
                  builder: (isVisible) {
                    return _buildContentWidget(data);
                  },
                );
              },
              error: (err, stack) => _buildErrorWidget(),
              loading: _buildLoadingWidget,
            );
      }),
    );
  }

  SingleChildRenderObjectWidget _buildContentWidget(
      HomePageCategoriesViewModel data) {
    if (data.categories!.isEmpty) {
      if (data.isLoading) {
        return _buildLoadingWidget();
      }
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.categories!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) {
          final category = data.categories![index];
          return HomePageCategoryItemWidget(
            category: HomePageCategoryItemViewModel(
                id: category.id ?? '',
                name: category.name ?? '',
                imageUrl: category.pictureModel!.imageUrl ?? ''),
            onTap: () {
              context.router.push(CategoryRoute(categoryId: category.id!));
            },
          );
        },
      ),
    );
  }

  AppErrorWidget _buildErrorWidget() {
    return AppErrorWidget(
        message:
            'Şu anda kategorileri görüntüleyemiyoruz! Lütfen tekrar deneyiniz.');
  }

  SizedBox _buildLoadingWidget() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            mainAxisExtent: 100,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: 64,
                      height: 64,
                    ),
                  ),
                ),
                8.height,
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
