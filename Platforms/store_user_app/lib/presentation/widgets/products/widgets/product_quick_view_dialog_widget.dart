import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';

class ProductQuickViewDialogWidget extends StatefulHookConsumerWidget {
  final ProductDetailsModel productDetails;
  const ProductQuickViewDialogWidget({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductQuickViewDialogWidgetState();
}

class _ProductQuickViewDialogWidgetState
    extends ConsumerState<ProductQuickViewDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
