import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseConcreteAsyncNotifier<T> extends AutoDisposeAsyncNotifier<T> {
  @override
  FutureOr<T> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
