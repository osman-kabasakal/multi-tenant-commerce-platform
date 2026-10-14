import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_cart_info_state.freezed.dart';

enum ShoppingCartInfoDisplayMode {
  compact,
  expanded,
  hidden,
}

enum ShoppingCartInfoStatus {
  empty,
  belowMinimum,
  aboveMinimumBelowFreeShipping,
  readyToCheckout,
}

@freezed
class ShoppingCartInfoState with _$ShoppingCartInfoState {
  const factory ShoppingCartInfoState({
    @Default(ShoppingCartInfoDisplayMode.compact) ShoppingCartInfoDisplayMode displayMode,
    @Default(ShoppingCartInfoStatus.empty) ShoppingCartInfoStatus status,
    @Default(false) bool isAnimating,
    @Default(false) bool isDismissed,
    @Default(0.0) double progressPercentage,
    String? primaryMessage,
    String? secondaryMessage,
    String? actionText,
  }) = _ShoppingCartInfoState;
}