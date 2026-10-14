import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/presentation/screens/home/providers/discounted_list_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_section_product_collection_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_collection_widget_sceleton.dart';

class DiscountedListWidget extends HookConsumerWidget {
  const DiscountedListWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: ref.watch(discountedListControllerProvider).when(
              data: (data) => data.isEmpty
                  ? Container(
                      height: 5,
                    )
                  : AppSectionProductCollectionWidget(
                      products: data,
                      title: 'Size özel',
                    ),
              error: (err, stack) => AppErrorWidget(
                message:
                    'Ürünleriniz yüklenemedi lütfen daha sonra tekrar deneyiniz.',
              ),
              loading: () {
                return ProductCollectionWidgetSceleton();
              },
            ));
  }
}
