import 'package:flutter/material.dart';

class ProductsComparisonWidget extends StatelessWidget {
  final String productId;
  final bool compareProductsEnabled;
  final Function(String) onAddToCompare;

  const ProductsComparisonWidget({
    super.key,
    required this.productId,
    required this.compareProductsEnabled,
    required this.onAddToCompare,
  });

  @override
  Widget build(BuildContext context) {
    if (!compareProductsEnabled) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () => onAddToCompare(productId),
      icon: const Icon(Icons.compare_arrows),
      tooltip: 'Karışılaştırma Listesine Ekle',
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
      ),
    );
  }
}
