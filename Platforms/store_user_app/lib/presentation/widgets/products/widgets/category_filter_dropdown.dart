import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/category_selection_dialog.dart';

class CategoryFilterDropdown extends StatefulWidget {
  final List<CategoryModel> initialCategories;
  final String? selectedCategoryId;
  final Function(CategoryModel?) onCategorySelected;

  const CategoryFilterDropdown({
    super.key,
    required this.initialCategories,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  State<CategoryFilterDropdown> createState() =>
      _HierarchicalCategoryDropdownState();
}

class _HierarchicalCategoryDropdownState extends State<CategoryFilterDropdown> {
  late CategoryModel? _selectedCategory;

  late final String _displayText = 'Kategori Seçiniz';

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.initialCategories
        .where((c) => c.id == widget.selectedCategoryId)
        .firstOrNull;
  }

  Future<void> _toggleDropdown() async {
    var category = await getIt<AppRouter>().pushWidget(
      Dialog.fullscreen(
        backgroundColor: blackColor.withValues(alpha: 0.4),
        child: SizedBox(
          width: context.width(),
          height: context.height(),
          child: Center(
            child: Container(
              color: context.scaffoldBackgroundColor,
              child: CategorySelectionDialog(
                initialCategories: widget.initialCategories,
                onCategorySelected: widget.onCategorySelected,
                selectedCategoryId: _selectedCategory?.id,
              ),
            ),
          ),
        ),
      ),
      fullscreenDialog: true,
      opaque: false,
    );
    if (category is CategoryModel?) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedCategory != null
                    ? _selectedCategory?.name ?? ''
                    : _displayText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _selectedCategory == null
                      ? Colors.grey.shade600
                      : Colors.black87,
                ),
              ),
            ),
            Icon(
              _selectedCategory != null ? Icons.saved_search : Icons.search,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
