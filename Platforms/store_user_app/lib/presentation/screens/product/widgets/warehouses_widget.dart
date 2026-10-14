import 'package:flutter/material.dart';

class WarehouseModel {
  final String warehouseId;
  final String name;
  final bool selected;

  WarehouseModel({
    required this.warehouseId,
    required this.name,
    required this.selected,
  });
}

class WarehousesWidget extends StatefulWidget {
  final List<WarehouseModel> warehouses;
  final Function(String) onWarehouseChanged;

  const WarehousesWidget({
    super.key,
    required this.warehouses,
    required this.onWarehouseChanged,
  });

  @override
  State<WarehousesWidget> createState() => _WarehousesWidgetState();
}

class _WarehousesWidgetState extends State<WarehousesWidget> {
  late String selectedWarehouseId;

  @override
  void initState() {
    super.initState();
    // Eğer liste boşsa, hata vermemesi için kontrol eklendi
    if (widget.warehouses.isNotEmpty) {
      selectedWarehouseId =
          widget.warehouses
              .firstWhere(
                (w) => w.selected,
                orElse: () => widget.warehouses.first,
              )
              .warehouseId;
    } else {
      selectedWarehouseId = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Liste boşsa hiçbir şey gösterme
    if (widget.warehouses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gönderilebilir Depolar:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedWarehouseId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items:
                widget.warehouses
                    .map(
                      (warehouse) => DropdownMenuItem(
                        value: warehouse.warehouseId,
                        child: Text(warehouse.name),
                      ),
                    )
                    .toList(),
            onChanged: (warehouseId) {
              if (warehouseId != null) {
                setState(() {
                  selectedWarehouseId = warehouseId;
                });
                widget.onWarehouseChanged(warehouseId);
              }
            },
          ),
        ],
      ),
    );
  }
}
