import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';

class CategorySearchResult {
  final CategoryModel category;
  final List<CategoryModel> path;

  CategorySearchResult({
    required this.category,
    required this.path,
  });
}
