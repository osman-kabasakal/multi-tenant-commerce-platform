import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/product_catalog_widget.dart';

import '../../../widgets/shopping_cart_info/widgets/shopping_cart_info_widget.dart';

@RoutePage()
class SearchResultScreen extends StatefulHookConsumerWidget {
  final String? searchQuery;
  const SearchResultScreen({
    super.key,
    @QueryParam('searchQuery') this.searchQuery,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  late final ValueNotifier<String> titleState;
  @override
  void initState() {
    titleState = ValueNotifier('');
    super.initState();
  }

  @override
  void dispose() {
    titleState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          const ShoppingCartInfoWidget(
            variant: ShoppingCartInfoVariant.fixed,
            dismissible: true,
          ),
          Expanded(
            child: ProductCatalogWidget(
              title: widget.searchQuery ?? 'Arama Sayfası',
              searchTerm: widget.searchQuery,
              onStateUpdated:
                  (state) => titleState.value = state.totalProducts.toString(),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
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
        valueListenable: titleState,
        builder: (context, state, child) {
          return Text(
            '${widget.searchQuery} | $state ürün',
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
