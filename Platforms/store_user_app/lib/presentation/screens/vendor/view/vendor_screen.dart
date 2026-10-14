import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/vendor_model/vendor_model.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/product_catalog_widget.dart';

@RoutePage()
class VendorScreen extends ConsumerStatefulWidget {
  final String vendorId;
  const VendorScreen({
    super.key,
    @PathParam('vendorId') required this.vendorId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VendorScreenState();
}

class _VendorScreenState extends ConsumerState<VendorScreen> {
  int totalProducts = 0;
  final ValueNotifier<VendorModel?> vendor = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ProductCatalogWidget(
        title: 'Vendor',
        priceFilterEnabled: false,
        collectionId: widget.vendorId,
        onStateUpdated: (state) {
          totalProducts = state.totalProducts;
          vendor.value =
              state.vendors.where((x) => x.id == widget.vendorId).firstOrNull;
        },
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
        valueListenable: vendor,
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
