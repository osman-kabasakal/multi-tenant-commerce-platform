import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/collection_model/collection_model.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/product_catalog_widget.dart';

import '../../../widgets/shopping_cart_info/widgets/shopping_cart_info_widget.dart';

@RoutePage()
class CollectionScreen extends ConsumerStatefulWidget {
  final String collectionId;
  const CollectionScreen({
    super.key,
    @PathParam('collectionId') required this.collectionId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  int totalProducts = 0;
  final ValueNotifier<CollectionModel?> collection = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          const ShoppingCartInfoWidget(
            variant: ShoppingCartInfoVariant.fixed,
            dismissible: true,
          ),
          Expanded(
            child: ProductCatalogWidget(
              title: 'Collection',
              priceFilterEnabled: false,
              collectionId: widget.collectionId,
              onStateUpdated: (state) {
                totalProducts = state.totalProducts;
                collection.value =
                    state.collections
                        .where((x) => x.id == widget.collectionId)
                        .firstOrNull;
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.router.maybePop(context);
        },
      ),
      backgroundColor:
          getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white,
      title: ValueListenableBuilder(
        valueListenable: collection,
        builder: (context, categoryState, child) {
          return Text(
            '${categoryState?.name ?? '...'} | $totalProducts Ürün',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
              fontSize: 20,
            ),
          );
        },
      ),
    );
  }
}
