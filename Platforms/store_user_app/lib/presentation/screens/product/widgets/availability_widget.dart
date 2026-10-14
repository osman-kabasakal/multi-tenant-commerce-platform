import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/repositories/out_of_stock_subscription/out_of_stock_subscription_repository.dart';

class AvailabilityModel {
  final String stockAvailability;
  final bool displayOutOfStockSubscription;
  final bool isAvAilablePurchase;
  final String buttonTextOutOfStockSubscription;

  AvailabilityModel({
    required this.stockAvailability,
    required this.displayOutOfStockSubscription,
    required this.isAvAilablePurchase,
    required this.buttonTextOutOfStockSubscription,
  });
}

class AvailabilityWidget extends StatelessWidget {
  final AvailabilityModel model;
  final FutureOr<void> Function() onSubscribeToBackInStock;

  const AvailabilityWidget({
    super.key,
    required this.model,
    required this.onSubscribeToBackInStock,
  });

  @override
  Widget build(BuildContext context) {
    if (model.stockAvailability.isEmpty &&
        !model.displayOutOfStockSubscription) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.stockAvailability.isNotEmpty)
            Row(
              children: [
                Text(
                  'Stok Durumu:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 4),
                Text(
                  model.stockAvailability,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        model.isAvAilablePurchase ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          if (model.displayOutOfStockSubscription &&
              !model.buttonTextOutOfStockSubscription.isEmptyOrNull)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: onSubscribeToBackInStock,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.grey[300],
                ),
                child: Text(model.buttonTextOutOfStockSubscription,
                    style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
