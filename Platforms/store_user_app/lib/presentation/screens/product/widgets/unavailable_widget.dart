import 'package:flutter/material.dart';

class UnavailableWidget extends StatelessWidget {
  final bool displayDiscontinuedMessage;

  const UnavailableWidget({
    super.key,
    required this.displayDiscontinuedMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!displayDiscontinuedMessage) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Satışta Değil',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
