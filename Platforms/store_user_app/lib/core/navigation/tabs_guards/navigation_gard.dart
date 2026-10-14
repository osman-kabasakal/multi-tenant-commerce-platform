import 'package:flutter/widgets.dart';

abstract class NavigationGuard {
  Future<bool> canNavigate(BuildContext context);
}
