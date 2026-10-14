import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadComponentWhenVisible extends HookConsumerWidget {
  final Widget Function(bool isLoading) builder;
  final Future<void> Function() onVisible;
  final double visibilityFraction;
  final bool showLoadingIndicator;
  final Widget? loadingIndicator;

  const LoadComponentWhenVisible({
    super.key,
    required this.onVisible,
    this.visibilityFraction = 0.1,
    this.showLoadingIndicator = false,
    this.loadingIndicator,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final hasLoaded = useState(false);
    final key = useMemoized(() => const Uuid().v4());

    return VisibilityDetector(
      key: Key(key),
      onVisibilityChanged: (info) async {
        if (!hasLoaded.value && info.visibleFraction >= visibilityFraction) {
          isLoading.value = true;
          hasLoaded.value = false;

          try {
            await onVisible();
          } finally {
            if (context.mounted) {
              isLoading.value = false;
              hasLoaded.value = true;
            }
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(flex: 1, child: builder(isLoading.value)),
          if (showLoadingIndicator && isLoading.value)
            loadingIndicator ??
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }
}
