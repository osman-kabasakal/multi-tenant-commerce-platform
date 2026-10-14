import 'package:flutter/material.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_tag_model/product_tag_model.dart';

// class ProductTagModel {
//   final String name;
//   final String seName;
//   final int productCount;

//   ProductTagModel({
//     required this.name,
//     required this.seName,
//     required this.productCount,
//   });
// }

class ProductTagsWidget extends StatelessWidget {
  final List<ProductTagModel> tags;
  final Function(String) onTagTap;

  const ProductTagsWidget({
    super.key,
    required this.tags,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map((tag) => InkWell(
                  onTap: () => onTagTap(tag.seName ?? ''),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: tag.name),
                          TextSpan(
                            text: ' (${tag.productCount})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
