import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/tier_price_model/tier_price_model.dart';

class TierPricesWidget extends StatelessWidget {
  final List<TierPriceModel> tierPrices;

  const TierPricesWidget({super.key, required this.tierPrices});

  @override
  Widget build(BuildContext context) {
    if (tierPrices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Karlı Satın Al',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: Colors.grey[300]!),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  _buildTableHeader('Adet (En Düşük)'),
                  _buildTableHeader('Fiyat'),
                ],
              ),
              ...tierPrices.map(
                (price) => TableRow(
                  children: [
                    _buildTableCell('${price.quantity}+'),
                    _buildTableCell(price.price ?? '', isPrice: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTableCell(String text, {bool isPrice = false}) {
    var theme = getIt<AppRouter>().navigatorKey.currentContext?.theme;
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: theme?.textTheme.bodyMedium?.copyWith(
          fontFamily: isPrice ? '' : null,
        ),
      ),
    );
  }
}
