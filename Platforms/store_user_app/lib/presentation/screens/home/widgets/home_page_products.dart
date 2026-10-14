import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/presentation/screens/home/providers/home_page_products_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_section_product_collection_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_collection_widget_sceleton.dart';

class HomePageProducts extends StatefulHookConsumerWidget {
  const HomePageProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomePageProductsState();
}

class _HomePageProductsState extends ConsumerState<HomePageProducts> {
  bool isApper = false;
  final skeletonWidget = const ProductCollectionWidgetSceleton();
  @override
  Widget build(BuildContext context) {
    return ref.watch(homePageProductsProvider).when(
          data: (data) => data.isEmpty
              ? SizedBox.shrink()
              : AppSectionProductCollectionWidget(
                  products: data,
                  title: 'Vitrinimize Özel',
                ),
          error: (err, stack) => AppErrorWidget(
            message:
                'Ürünleriniz yüklenemedi lütfen daha sonra tekrar deneyiniz.',
          ),
          loading: () {
            return skeletonWidget;
          },
        );
  }
}
