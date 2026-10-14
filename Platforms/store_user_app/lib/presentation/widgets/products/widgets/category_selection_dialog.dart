import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/category_serach_result.dart';
import 'package:nb_utils/nb_utils.dart';

class CategorySelectionDialog extends StatefulWidget {
  final List<CategoryModel> initialCategories;
  final String? selectedCategoryId;
  final Function(CategoryModel?) onCategorySelected;
  const CategorySelectionDialog({
    super.key,
    required this.initialCategories,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> _currentCategory = [];
  List<CategoryModel> _categoryPath = [];
  late CategoryModel? _selectedCategory;
  String _searchText = '';
  List<CategorySearchResult> _searchResults = [];

  late FormBuilder<String> categorySearchFormBuilder;
  late AppFormController<String> formController;

  @override
  void initState() {
    super.initState();
    _initists();
    categorySearchFormBuilder = FormBuilder<String>('');
    categorySearchFormBuilder.addField('categorySearch', (s) => s);
    formController = AppFormController<String>(
      categorySearchFormBuilder.build(),
      onFieldChange: (fieldName, value) {
        _performSearch(value);
      },
      onDispose: () {
        if (kDebugMode) {
          debugPrint('CategorySelectionDialog disposed');
        }
      },
    );
  }

  void _initists() {
    _selectedCategory = widget.initialCategories
        .where((c) => c.id == widget.selectedCategoryId)
        .firstOrNull;

    _currentCategory = widget.initialCategories
        .where(
          (c) =>
              (_selectedCategory != null &&
                  c.parentCategoryId == _selectedCategory!.parentCategoryId) ||
              (_selectedCategory == null && c.parentCategoryId.isEmptyOrNull),
        )
        .toList();

    _categoryPath = _getCategoryBreadPath(_selectedCategory);
  }

  @override
  didUpdateWidget(CategorySelectionDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategoryId != widget.selectedCategoryId) {
      _initists();
    }
  }

  @override
  dispose() {
    _searchController.dispose();
    formController.dispose();
    super.dispose();
  }

  List<CategoryModel> _getCategoryBreadPath(CategoryModel? categoryModel) {
    List<CategoryModel> categoryPath = [];
    var hasChild = widget.initialCategories
        .any((c) => c.parentCategoryId == categoryModel?.id);
    if (categoryModel != null &&
        !categoryModel.parentCategoryId.isEmptyOrNull) {
      if (hasChild) categoryPath.add(categoryModel);
      var parent = widget.initialCategories
          .where((c) => c.id == categoryModel.parentCategoryId)
          .firstOrNull;
      while (parent != null) {
        categoryPath.add(parent);
        if (parent.parentCategoryId.isEmptyOrNull) {
          break;
        }
        parent = widget.initialCategories
            .where((c) => c.id == parent?.parentCategoryId)
            .firstOrNull;
      }
    } else {
      if (categoryModel != null && hasChild) categoryPath.add(categoryModel);
    }
    return categoryPath.reversed.toList();
  }

  void _closeDropdown() {
    context.router.maybePop(_selectedCategory);
  }

  void _navigateToSubcategory(CategoryModel category) {
    setState(() {
      _categoryPath = _getCategoryBreadPath(category);
      _currentCategory = widget.initialCategories
          .where((c) => c.parentCategoryId == category.id)
          .toList();
      _searchText = '';
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _navigateBack() {
    if (_categoryPath.isNotEmpty) {
      setState(() {
        final newPath = List<CategoryModel>.from(_categoryPath);
        newPath.removeLast();
        _categoryPath = newPath;

        if (newPath.isEmpty) {
          _currentCategory = widget.initialCategories
              .where((c) => c.parentCategoryId.isEmptyOrNull)
              .toList();
        } else {
          final parentCategory = newPath.last;
          _currentCategory = widget.initialCategories
              .where((c) => c.parentCategoryId == parentCategory.id)
              .toList();
        }
      });
    }
  }

  void _navigateToRoot() {
    setState(() {
      _categoryPath = [];
      _currentCategory = widget.initialCategories
          .where((c) => c.parentCategoryId.isEmptyOrNull)
          .toList();
      _searchText = '';
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _toggleCategorySelection(CategoryModel category) {
    setState(() {
      final isSelected =
          _selectedCategory != null && _selectedCategory?.id == category.id;

      if (isSelected) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  void _performSearch(String searchText) {
    setState(() {
      _searchText = searchText;
      if (searchText.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _searchCategories(
            widget.initialCategories, searchText.toLowerCase());
      }
    });
  }

  List<CategorySearchResult> _searchCategories(
      List<CategoryModel> categories, String searchText) {
    final results = <CategorySearchResult>[];

    void searchInCategory(CategoryModel category, List<CategoryModel> path) {
      final currentPath = [...path, category];

      if ((category.name ?? '').toLowerCase().contains(searchText)) {
        results
            .add(CategorySearchResult(category: category, path: currentPath));
      }
      var subCategories = widget.initialCategories
          .where((c) => c.parentCategoryId == category.id)
          .toList();
      for (final child in subCategories) {
        searchInCategory(child, currentPath);
      }
    }

    for (final category in categories) {
      searchInCategory(category, []);
    }

    return results;
  }

  void _navigateToSearchResult(CategorySearchResult result) {
    final path = result.path;

    setState(() {
      // Son kategoriyi hariç tut (seçilecek olan)
      _categoryPath = path.sublist(0, path.length - 1);

      if (_categoryPath.isEmpty) {
        _currentCategory = widget.initialCategories.where((c) {
          return c.parentCategoryId.isEmptyOrNull;
        }).toList();
      } else {
        final parentCategory = _categoryPath.last;
        _currentCategory = widget.initialCategories
            .where((c) => c.parentCategoryId == parentCategory.id)
            .toList();
      }

      _searchText = '';
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _applyFilters() {
    widget.onCategorySelected(_selectedCategory);
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      maxWidthPercentage: 0.8,
      maxHeightPercentage: 0.7,
      contentBuilder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchField(),
          if (_searchText.isEmpty) _buildBreadcrumbs(),
          Flexible(
            child: _searchText.isNotEmpty
                ? _buildSearchResults()
                : _buildCategoryList(),
          ),
        ],
      ),
      footerBuilder: (context) {
        return _buildDropdownFooter();
      },
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: formController.getController('categorySearch'),
        decoration: InputDecoration(
          hintText: 'Kategori ara...',
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onSubmitted: _performSearch,
        focusNode: formController.getFocusNode('categorySearch'),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: _navigateToRoot,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.blue.shade600,
              ),
              child: const Text(
                'Ana Kategori',
                style: TextStyle(fontSize: 12),
              ),
            ),
            for (int i = 0; i < _categoryPath.length; i++)
              Row(
                children: [
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentCategory = widget.initialCategories
                            .where((c) =>
                                c.parentCategoryId == _categoryPath[i].id)
                            .toList();
                        final newPath = _getCategoryBreadPath(_categoryPath[i]);
                        _categoryPath = newPath;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.blue.shade600,
                    ),
                    child: Text(_categoryPath[i].name ?? '',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text('Arama sonucu bulunamadı',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: _searchResults.length,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final category = result.category;

        // Kategori yolu oluştur (en son kategori hariç)
        final pathItems = result.path.sublist(0, result.path.length - 1);
        final pathText = pathItems.isEmpty
            ? ''
            : pathItems.map((cat) => cat.name).join(' > ');

        return ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Text(category.name ?? ''),
          subtitle: pathText.isNotEmpty
              ? Text(
                  pathText,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () => _navigateToSearchResult(result),
          ),
          onTap: () => _navigateToSearchResult(result),
        );
      },
    );
  }

  Widget _buildDropdownFooter() {
    return AppBottomNavigation(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: AppCommonButton.adaptive(
            text: 'İptal',
            onPressed: _closeDropdown,
            bgColor: Colors.grey.shade200,
            borderColor: context.theme.primaryColor,
            textColor: context.theme.primaryColor,
          )),
          const SizedBox(width: 8),
          Expanded(
            child: AppCommonButton.adaptive(
              text: 'Uygula',
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    if (_currentCategory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Alt kategori bulunamadı',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: _currentCategory.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = _currentCategory[index];
        final isSelected =
            _selectedCategory != null && _selectedCategory?.id == category.id;

        return ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: GestureDetector(
            onTap: () => _toggleCategorySelection(category),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
                color: isSelected ? Colors.blue.shade50 : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: Colors.blue.shade600)
                  : null,
            ),
          ),
          onTap: widget.initialCategories
                  .any((c) => c.parentCategoryId == category.id)
              ? () => _navigateToSubcategory(category)
              : () => _toggleCategorySelection(category),
          title: Text(category.name ?? ''),
          trailing: widget.initialCategories.any((c) =>
                  c.parentCategoryId ==
                  category.id) // Eğer alt kategori varsa sağa ok ekle
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () => _navigateToSubcategory(category),
                )
              : null,
        );
      },
    );
  }
}
