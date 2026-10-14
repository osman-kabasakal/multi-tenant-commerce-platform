import 'package:flutter/material.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';


class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  ErrorBoundaryState createState() => ErrorBoundaryState();
}

class ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset error state when dependencies change
    setState(() => _hasError = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _hasError = false);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    ErrorWidget.builder = (FlutterErrorDetails details) {
      LoggerService.error(
        'UI Rendering Error',
        details.exception,
        details.stack,
      );

      // Set error state
      Future.microtask(() => setState(() => _hasError = true));

      return Container(color: Colors.transparent);
    };
    return ErrorWidget.withDetails();
  }
}