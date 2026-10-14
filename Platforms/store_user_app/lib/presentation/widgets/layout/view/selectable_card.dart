import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';

/// Seçilebilir kart bileşeni.
/// [child] parametresi kartın içeriğini,
/// [isSelected] seçili olup olmadığını,
/// [onTap] ise karta dokunulduğunda yapılacak işlemi belirtir.
class SelectableCard extends HookConsumerWidget {
  final Widget child;
  final bool isSelected;
  final FutureOr<void> Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool showSelectionCheckbox;

  const SelectableCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
    this.margin,
    this.selectedColor,
    this.unselectedColor,
    this.showSelectionCheckbox = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Temaya uygun renk ve kenarlık ayarları
    final borderColor =
        isSelected
            ? (selectedColor ?? AppTheme.foodLightTheme.primaryColor)
            : (unselectedColor ?? Colors.grey[300]!);
    final borderWidth = isSelected ? 2.0 : 1.0;
    final (
      :pending,
      :snapshot,
      hasError: _,
      loaderColor: _,
      loaderStrokeWidth: _,
    ) = useAsyncTask();

    return GestureDetector(
      onTap:
          onTap == null
              ? null
              : snapshot.connectionState == ConnectionState.waiting
              ? null
              : () => pending.value = (() async => await onTap!())(),
      child: Container(
        margin:
            margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color:
              getIt<ThemeController>().isDarkMode
                  ? cardDarkColor
                  : cardLightColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
        ),
        child: Stack(
          children: [
            Padding(padding: const EdgeInsets.all(12.0), child: child),
            if (isSelected && showSelectionCheckbox)
              Positioned(
                top: 8,
                right: 8,
                child: Checkbox(
                  value: true,
                  onChanged: (_) {},
                  activeColor:
                      selectedColor ?? AppTheme.foodLightTheme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
