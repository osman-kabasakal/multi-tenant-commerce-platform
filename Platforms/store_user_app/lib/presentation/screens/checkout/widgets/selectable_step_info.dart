import 'package:flutter/material.dart';

import '../view_models/selectable_shipping_info_view_model.dart';

class SelectableStepInfo extends StatelessWidget {
  final SelectableStepInfoViewModel viewModel;
  const SelectableStepInfo({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shipping method adı
        Text(
          viewModel.name ?? 'İsimsiz Yöntemi',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Açıklama varsa göster
        if (viewModel.description != null && viewModel.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              viewModel.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        // Ücret bilgisi
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Ücret: ${viewModel.fee ?? '0.00 TL'}',
            style: TextStyle(
              fontSize: 15,
              fontFamily: '',
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // UserFields varsa göster
        if (viewModel.userFields != null && viewModel.userFields!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: viewModel.userFields!.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${field.key}: ${field.value}',
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
