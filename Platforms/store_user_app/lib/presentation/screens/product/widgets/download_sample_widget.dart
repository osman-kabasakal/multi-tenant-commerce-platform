import 'package:flutter/material.dart';

class DownloadSampleWidget extends StatelessWidget {
  final bool hasSampleDownload;
  final String productId;
  final Function(String) onDownloadSample;

  const DownloadSampleWidget({
    super.key,
    required this.hasSampleDownload,
    required this.productId,
    required this.onDownloadSample,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasSampleDownload) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: () => onDownloadSample(productId),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text('Örnek İndir'),
      ),
    );
  }
}
