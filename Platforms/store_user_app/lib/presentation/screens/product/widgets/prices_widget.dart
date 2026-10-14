import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_price_model/product_price_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';

class PricesWidget extends StatelessWidget {
  final ProductPriceModel model;
  final String productId;
  final VoidCallback onCallForPrice;

  const PricesWidget({
    super.key,
    required this.model,
    required this.productId,
    required this.onCallForPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (model.enteredPrice ?? false) {
      return const SizedBox.shrink();
    }

    if (model.callForPrice ?? false) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: ElevatedButton(
          onPressed: onCallForPrice,
          child: const Text('Fiyat için Arayınız'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((model.isReservation ?? false) &&
            (model.reservationPrice?.isNotEmpty ?? false))
          Row(
            children: [
              const Text(
                'Products.Price.ReservationPrice:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              Text(model.reservationPrice!),
            ],
          ),
        if ((model.isAuction ?? false))
          Row(
            children: [
              Text(
                (model.highestBidValue ?? 0) > 0
                    ? 'Products.Price.CurrentPrice:'
                    : 'Products.Price.StartPrice:',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              Text(
                (model.highestBidValue ?? 0) > 0
                    ? model.highestBid!
                    : model.startPrice!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        if (!((model.isAuction ?? false) && (model.disableBuyButton ?? false)))
          _buildPriceSection(context),
        if ((model.basePricePAngV?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              model.basePricePAngV!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    // Check if there's a discount
    final hasDiscount =
        (model.oldPrice?.isNotEmpty ?? false) ||
        ((model.priceWithDiscount?.isNotEmpty ?? false) &&
            (model.price?.isNotEmpty ?? false));
    final theme = Theme.of(context);

    // Parse price values for discount calculation
    double originalPrice = 0;
    double discountedPrice = 0;

    // Extract numeric values from price strings
    if (hasDiscount) {
      // Try to extract numeric values (removing currency symbols)
      final originalPriceStr = (model.oldPrice ?? model.price)!
          .replaceAll(RegExp(r'[^\d,.]'), '')
          .replaceAll(',', '.');
      final discountedPriceStr = (model.priceWithDiscount ?? model.price ?? '')
          .replaceAll(RegExp(r'[^\d,.]'), '')
          .replaceAll(',', '.');

      try {
        originalPrice = double.parse(originalPriceStr);
        discountedPrice = double.parse(discountedPriceStr);
      } catch (e) {
        // Parsing failed, use default values
      }
    }

    final hasActiveDiscount = model.priceWithDiscount?.isNotEmpty ?? false;
    if (hasActiveDiscount) {
      try {
        discountedPrice = double.parse(
          model.priceWithDiscount!
              .replaceAll(RegExp(r'[^\d,.]'), '')
              .replaceAll(',', '.'),
        );
      } catch (e) {
        // Handle parsing error
      }
    }

    // Calculate discount percentage and amount
    final discountAmount = originalPrice - discountedPrice;
    final discountPercentage =
        originalPrice > 0 ? (discountAmount / originalPrice * 100).round() : 0;
    final hasValidDiscount = discountAmount > 0 && discountPercentage > 0;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDiscount && hasValidDiscount)
            _buildDiscountBadge(context, discountPercentage),

          // Original price with strikethrough
          if (hasDiscount && (model.oldPrice?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                model.oldPrice!,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                  fontFamily: '',
                  fontSize: 14,
                ),
              ),
            ),

          const SizedBox(height: 4),

          // Current price (with or without discount)
          if (model.priceWithDiscount?.isEmpty ?? false)
            AppSummaryRowWidget(
              '',
              model.price!,
              isPrice: true,
              isSmall: false,
              isHighlight: true,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discounted price
                AppSummaryRowWidget(
                  '',
                  model.priceWithDiscount ?? model.price!,
                  isPrice: true,
                  isHighlight: true,
                ),

                // Show discount amount
                if (hasDiscount && hasValidDiscount)
                  _buildSavingsInfo(
                    context,
                    discountAmount,
                    model.currencyCode ?? '₺',
                  ),
              ],
            ),

          // Limited time offer badge
          // if (hasDiscount && hasValidDiscount) _buildLimitedTimeOffer(context),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context, int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '%$percentage İNDİRİM',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSavingsInfo(
    BuildContext context,
    double amount,
    String currency,
  ) {
    if (amount <= 0) return const SizedBox.shrink();

    final amountStr = amount.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: colorPrimary, size: 14),
          4.width,
          Text(
            "$amountStr $currency tasarruf edin!",
            style: const TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitedTimeOffer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colorPrimary),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: colorPrimary, size: 14),
          4.width,
          const Text(
            "Sınırlı Süre Teklifi",
            style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
