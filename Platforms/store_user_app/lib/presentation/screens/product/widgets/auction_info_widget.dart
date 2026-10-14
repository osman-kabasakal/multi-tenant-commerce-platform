import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionInfoModel {
  final String productId;
  final DateTime? endTime;
  final DateTime? endTimeLocalTime;
  final double highestBidValue;
  final double startPrice;

  AuctionInfoModel({
    required this.productId,
    this.endTime,
    this.endTimeLocalTime,
    required this.highestBidValue,
    required this.startPrice,
  });
}

class AuctionInfoWidget extends StatefulWidget {
  final AuctionInfoModel model;
  final Function(String, double) onPlaceBid;

  const AuctionInfoWidget({
    super.key,
    required this.model,
    required this.onPlaceBid,
  });

  @override
  State<AuctionInfoWidget> createState() => _AuctionInfoWidgetState();
}

class _AuctionInfoWidgetState extends State<AuctionInfoWidget> {
  late TextEditingController bidController;
  late Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    double initialBidValue = widget.model.highestBidValue > 0
        ? widget.model.highestBidValue + 1
        : widget.model.startPrice + 1;
    bidController = TextEditingController(text: initialBidValue.toString());

    if (widget.model.endTime != null) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    bidController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.model.endTime == null) return;

    _remainingSeconds =
        widget.model.endTime!.difference(DateTime.now()).inSeconds;
    if (_remainingSeconds <= 0) {
      _remainingSeconds = 0;
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String get _formattedTimeLeft {
    if (_remainingSeconds <= 0) return 'Auction ended';

    final Duration duration = Duration(seconds: _remainingSeconds);
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    return '$days days, $hours hours, $minutes minutes, $seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.endTime == null) {
      return const SizedBox.shrink();
    }

    bool isAuctionActive = widget.model.endTime!.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue[300]!),
            ),
            child: Column(
              children: [
                if (isAuctionActive)
                  Column(
                    children: [
                      const Text(
                        'AddToCart.Timeleft',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formattedTimeLeft,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ShoppingCart.Auctionends:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(widget.model.endTimeLocalTime!),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (isAuctionActive)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: bidController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      final double bidValue =
                          double.tryParse(bidController.text) ?? 0;
                      if (bidValue > widget.model.highestBidValue &&
                          bidValue > widget.model.startPrice) {
                        widget.onPlaceBid(widget.model.productId, bidValue);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Your bid must be higher than the current highest bid'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.gavel),
                    label: const Text('ShoppingCart.Bid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
