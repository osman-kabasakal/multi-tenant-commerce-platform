import 'package:flutter/material.dart';
import 'package:store_user_app/domain/entities/models/catalog/collection_model/collection_model.dart';

class CollectionsWidget extends StatelessWidget {
  final List<CollectionModel> collections;
  final Function(String) onCollectionTap;

  const CollectionsWidget({
    super.key,
    required this.collections,
    required this.onCollectionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            collections.length == 1 ? 'Koleksiyon:' : 'Koleksiyonlar:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            children: List.generate(
              collections.length,
              (index) => InkWell(
                onTap: () => onCollectionTap(collections[index].seName ?? ''),
                child: Text(
                  (collections[index].name ?? '') +
                      (index < collections.length - 1 ? ', ' : ''),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
