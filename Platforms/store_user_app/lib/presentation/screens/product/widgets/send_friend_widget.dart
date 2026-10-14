import 'package:flutter/material.dart';

class SendFriendWidget extends StatelessWidget {
  final String productId;
  final bool emailAFriendEnabled;
  final VoidCallback onSendToFriend;

  const SendFriendWidget({
    super.key,
    required this.productId,
    required this.emailAFriendEnabled,
    required this.onSendToFriend,
  });

  @override
  Widget build(BuildContext context) {
    if (!emailAFriendEnabled) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: onSendToFriend,
      icon: const Icon(Icons.email),
      tooltip: 'Mail ile Arkadaşına Gönder',
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
      ),
    );
  }
}
