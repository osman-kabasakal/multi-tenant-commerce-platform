import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef AsyncTask<TReturn> = ({
  ValueNotifier<Future<TReturn>?> pending,
  AsyncSnapshot<TReturn> snapshot,
  bool hasError,
  Color loaderColor,
  double loaderStrokeWidth,
});

/// Creates a hook that provides a [snapshot] of the current asynchronous task passed
/// to [pending], a [hasError] value, and loader style properties.
/// 
/// The [loaderColor] defaults to white for contrast with most button backgrounds.
/// The [loaderStrokeWidth] can be adjusted based on the button size.
AsyncTask<TReturn> useAsyncTask<TReturn>({
  Color loaderColor = Colors.white,
  double loaderStrokeWidth = 2.0,
}) {
  final pending = useState<Future<TReturn>?>(null);
  final snapshot = useFuture<TReturn>(pending.value);
  final hasError =
      snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

  return (
    pending: pending, 
    snapshot: snapshot, 
    hasError: hasError,
    loaderColor: loaderColor,
    loaderStrokeWidth: loaderStrokeWidth,
  );
}
