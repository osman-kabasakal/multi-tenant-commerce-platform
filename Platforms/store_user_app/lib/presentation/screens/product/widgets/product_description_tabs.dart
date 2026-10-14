import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';

class ProductDescriptionTabs extends HookConsumerWidget {
  final int selectedTab;
  final void Function(int index) onTabChanged;

  const ProductDescriptionTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            _buildTabButton(
              context,
              0,
              'Detay',
              selectedTab,
              () => onTabChanged(0),
            ),
            const SizedBox(width: 10),
            _buildTabButton(
              context,
              1,
              'Değerlendirmeler',
              selectedTab,
              () => onTabChanged(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    int index,
    String name,
    int selectedTab,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: index == selectedTab
                ? theme.brightness == Brightness.dark
                    ? Colors.white
                    : theme.primaryColor
                : theme.brightness == Brightness.dark
                    ? theme.primaryColor
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: index == selectedTab
                  ? Colors.transparent
                  : Colors.grey.shade400,
            ),
          ),
          child: Center(
            child: Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: index == selectedTab
                    ? theme.brightness == Brightness.dark
                        ? theme.primaryColor
                        : Colors.white
                    : theme.brightness == Brightness.dark
                        ? Colors.white
                        : theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
