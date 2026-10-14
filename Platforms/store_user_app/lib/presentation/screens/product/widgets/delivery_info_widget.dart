import 'package:flutter/material.dart';

class DeliveryInfoModel {
  final bool freeShippingNotificationEnabled;
  final bool isFreeShipping;
  final String deliveryDate;
  final String deliveryColorSquaresRgb;
  final bool notReturnable;
  final double additionalShippingCharge;
  final String additionalShippingChargeStr;

  DeliveryInfoModel({
    required this.freeShippingNotificationEnabled,
    required this.isFreeShipping,
    this.deliveryDate = '',
    this.deliveryColorSquaresRgb = '',
    required this.notReturnable,
    required this.additionalShippingCharge,
    required this.additionalShippingChargeStr,
  });
}

class DeliveryInfoWidget extends StatelessWidget {
  final DeliveryInfoModel model;

  const DeliveryInfoWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (!(model.freeShippingNotificationEnabled && model.isFreeShipping) &&
        model.deliveryDate.isEmpty &&
        !model.notReturnable &&
        model.additionalShippingCharge <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.freeShippingNotificationEnabled && model.isFreeShipping)
            Row(
              children: const [
                Icon(Icons.local_shipping, size: 18, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Ücretsiz Kargo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          if (model.deliveryDate.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Text('Gönderi zamanı:'),
                  const SizedBox(width: 4),
                  Text(
                    model.deliveryDate,
                    style: TextStyle(
                      color:
                          model.deliveryColorSquaresRgb.isNotEmpty
                              ? HexColor.fromHex(model.deliveryColorSquaresRgb)
                              : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          if (model.notReturnable)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 8),
                  Text('İade Edilemez'),
                ],
              ),
            ),
          if (model.additionalShippingCharge > 0 && !model.isFreeShipping)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_shipping, size: 18),
                    const SizedBox(width: 8),
                    const Text('Ekstra Kargo Ücreti:'),
                    const SizedBox(width: 4),
                    Text(model.additionalShippingChargeStr),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
