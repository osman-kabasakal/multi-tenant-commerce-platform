import 'package:flutter/material.dart';

enum ErrorType {
  warning,
  error,
  info,
  success,
}

class AppErrorWidget extends StatefulWidget {
  final String message;
  final ErrorType type;
  final VoidCallback? onRetry;
  final bool isDismissible;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.type = ErrorType.error,
    this.onRetry,
    this.isDismissible = true,
  });

  @override
  State<AppErrorWidget> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<AppErrorWidget> {
  bool isVisible = true;

  // Hata türüne göre renk belirleme
  Color _getColor() {
    switch (widget.type) {
      case ErrorType.warning:
        return Colors.orange;
      case ErrorType.error:
        return Colors.red;
      case ErrorType.info:
        return Colors.blue;
      case ErrorType.success:
        return Colors.green;
    }
  }

  // Hata türüne göre icon belirleme
  IconData _getIcon() {
    switch (widget.type) {
      case ErrorType.warning:
        return Icons.warning_rounded;
      case ErrorType.error:
        return Icons.error_rounded;
      case ErrorType.info:
        return Icons.info_rounded;
      case ErrorType.success:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Material(
          color: _getColor().withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIcon(),
                      color: _getColor(),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: _getColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (widget.isDismissible)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          if (isVisible) {
                            setState(() {
                              isVisible = false;
                            });
                          }
                        },
                        color: _getColor(),
                      ),
                  ],
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getColor(),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Tekrar Dene'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
