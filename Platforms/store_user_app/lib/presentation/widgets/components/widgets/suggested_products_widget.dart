import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/components/providers/component_providers.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_section_product_collection_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_collection_widget_sceleton.dart';

class SuggestedProductsWidget extends StatefulHookConsumerWidget {
  const SuggestedProductsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuggestedProductsWidgetState();
}

class _SuggestedProductsWidgetState
    extends ConsumerState<SuggestedProductsWidget> {
  bool isApper = false;
  final skeletonWidget = ProductCollectionWidgetSceleton();
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: ref.watch(suggestedProductsProvider).when(
            data: (data) => data.isEmpty
                ? SizedBox.shrink()
                : AppSectionProductCollectionWidget(
                    products: data,
                    title: 'Tavsiye Ediyoruz',
                  ),
            error: (err, stack) => AppErrorWidget(
              message:
                  'Ürünleriniz yüklenemedi lütfen daha sonra tekrar deneyiniz.',
            ),
            loading: () {
              return skeletonWidget;
            },
          ),
    );
  }
}
