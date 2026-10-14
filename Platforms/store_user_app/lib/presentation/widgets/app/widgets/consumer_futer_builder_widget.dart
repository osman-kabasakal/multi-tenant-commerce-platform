import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConsumerFuterBuilderWidget<TState, TSelector> extends ConsumerWidget {
  final Future<TSelector> Function(WidgetRef ref) futureBuilder;

  final Widget Function(BuildContext context, WidgetRef snapShotRef,
      AsyncSnapshot<TSelector> snapshot) builder;

  final Widget Function(BuildContext context, WidgetRef snapShotRef,
      AsyncSnapshot<TSelector> snapshot)? loadingBuilder;

  final Widget Function(BuildContext context, WidgetRef snapShotRef,
      AsyncSnapshot<TSelector> snapshot)? errorBuilder;

  const ConsumerFuterBuilderWidget({
    super.key,
    required this.futureBuilder,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<TSelector>(
        future: futureBuilder(ref),
        builder: (futureContext, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasError &&
              !snapshot.hasData) {
            if (loadingBuilder != null) {
              return loadingBuilder!(futureContext, ref, snapshot);
            }
          }

          if (snapshot.hasError) {
            if (errorBuilder != null) {
              return errorBuilder!(futureContext, ref, snapshot);
            }
          }

          return builder(futureContext, ref, snapshot);
        });
  }
}
