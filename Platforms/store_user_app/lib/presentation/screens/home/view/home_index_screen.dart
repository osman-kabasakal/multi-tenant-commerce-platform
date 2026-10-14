import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';
import 'package:store_user_app/presentation/screens/home/providers/home_controller.dart';
import 'package:store_user_app/presentation/screens/home/view_models/home_view_model.dart';
import 'package:store_user_app/presentation/screens/home/widgets/app_special_offer.dart';
import 'package:store_user_app/presentation/screens/home/widgets/category_featured_products_widget.dart';
import 'package:store_user_app/presentation/screens/home/widgets/discounted_list_widget.dart';
import 'package:store_user_app/presentation/screens/home/widgets/home_page_categories_list_widget.dart';
import 'package:store_user_app/presentation/screens/home/widgets/home_page_new_products.dart';
import 'package:store_user_app/presentation/screens/home/widgets/home_page_products.dart';
import 'package:store_user_app/presentation/screens/home/widgets/home_search_bar.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/components/widgets/customer_recomended_products.dart';
import 'package:store_user_app/presentation/widgets/components/widgets/suggested_products_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_drawer.dart';

import '../widgets/home_app_bar.dart';
import 'package:store_user_app/presentation/widgets/shopping_cart_info/widgets/shopping_cart_info_widget.dart';

@RoutePage()
class HomeIndexScreen extends ConsumerStatefulWidget {
  const HomeIndexScreen({super.key});

  @override
  ConsumerState<HomeIndexScreen> createState() => _HomeIndexScreenState();
}

class _HomeIndexScreenState extends ConsumerState<HomeIndexScreen> {
  @override
  void initState() {
    super.initState();
    // Bildirim kontrol servisini başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationCheckerService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var controller = ref.watch(homeControllerProvider.notifier);
    // var state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: HomeAppBar(),
      drawer: AppDrawer(),
      body: ref
          .watch(homeControllerProvider)
          .when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data:
                (value) => _buildHomeContent(
                  context,
                  value,
                  ref.read(homeControllerProvider.notifier),
                ),
            error: (error, stack) => AppErrorWidget(message: error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    HomeViewModel state,
    HomeController controller,
  ) {
    return Column(
      children: [
        const ShoppingCartInfoWidget(
          variant: ShoppingCartInfoVariant.fixed,
          dismissible: true,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              // spacing: 20,
              // runSpacing: 10,
              children: [
                HomeSearchBar(),
                AppSpecialOffer(),
                HomePageCategoriesListWidget(),
                DiscountedListWidget(),
                CustomerRecomendedProducts(),
                SuggestedProductsWidget(),
                HomePageProducts(),
                HomePageNewProducts(),
                CategoryFeaturedProductsWidget(),
                // RecommendedListWidget(
                //   categories: state.recommendedList,
                //   selectedIndex: state.selectedCategoryIndex,
                //   onSelected: controller.toggleCategorySelection,
                // ),
                // RestaurantListWidget(restaurants: state.restaurantList),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
