import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/media/picture_model/picture_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class BundleItemModel {
  final String productId;
  final String name;
  final String seName;
  final String shortDescription;
  final double quantity;
  final String price;
  final PictureModel defaultPictureModel;
  final List<ProductAttributeModel> productAttributes;

  BundleItemModel({
    required this.productId,
    required this.name,
    required this.seName,
    required this.shortDescription,
    required this.quantity,
    required this.price,
    required this.defaultPictureModel,
    required this.productAttributes,
  });
}

class ProductBundlesWidget extends StatelessWidget {
  final List<BundleItemModel> bundles;
  final Function(String) onProductTap;
  final Function(String, String, dynamic) onAttributeChanged;

  const ProductBundlesWidget({
    super.key,
    required this.bundles,
    required this.onProductTap,
    required this.onAttributeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (bundles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            bundles.map((bundle) => _buildBundleItem(context, bundle)).toList(),
      ),
    );
  }

  Widget _buildBundleItem(BuildContext context, BundleItemModel bundle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              SizedBox(
                width: 100,
                child: OptimizedCacheImage(
                  imageUrl: bundle.defaultPictureModel.imageUrl!,
                  sizeConfig: ImageSizeConfig(width: 100, height: 100),
                  fit: BoxFit.fitWidth,
                ),
              ),
              // Product details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${bundle.quantity} x ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: bundle.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => onProductTap(bundle.seName),
                            ),
                            TextSpan(
                              text: ' (${bundle.price})',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      if (bundle.shortDescription.isNotEmpty)
                        Text(
                          bundle.shortDescription,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Product attributes
          if (bundle.productAttributes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductAttributesWidget(
                attributes: bundle.productAttributes,
                productId: bundle.productId,
                onAttributeChanged: onAttributeChanged,
              ),
            ),
        ],
      ),
    );
  }
}

class ProductAttributesWidget extends StatefulWidget {
  final List<ProductAttributeModel> attributes;
  final String productId;
  final Function(String, String, dynamic) onAttributeChanged;

  const ProductAttributesWidget({
    super.key,
    required this.attributes,
    required this.productId,
    required this.onAttributeChanged,
  });

  @override
  State<ProductAttributesWidget> createState() =>
      _ProductAttributesWidgetState();
}

class _ProductAttributesWidgetState extends State<ProductAttributesWidget> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children:
          widget.attributes.map((attr) => _buildAttributeRow(attr)).toList(),
    );
  }

  TableRow _buildAttributeRow(ProductAttributeModel attr) {
    return TableRow(
      children: [
        // Attribute name
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        attr.name ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (attr.isRequired ?? false)
                      const Text(
                        ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                if (attr.textPrompt != null)
                  Text(
                    attr.textPrompt!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (attr.description != null)
                  Text(
                    attr.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        // Attribute control
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildAttributeControl(attr),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeControl(ProductAttributeModel attr) {
    // 1 = DropdownList
    if (attr.attributeControlType!.value == 1) {
      return DropdownButtonFormField<String>(
        value: attr.values!
            .firstWhere((v) => v.isPreSelected ?? false,
                orElse: () => attr.values!.first)
            .id,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          if (!(attr.isRequired ?? false))
            const DropdownMenuItem(
              value: '',
              child: Text('---'),
            ),
          ...attr.values!
              .map((value) => DropdownMenuItem(
                    value: value.id,
                    child: Text(
                      value.priceAdjustment == null
                          ? value.name ?? ''
                          : '${value.name} [${value.priceAdjustment}]',
                    ),
                  ))
              .toList(),
        ],
        onChanged: (newValue) {
          widget.onAttributeChanged(widget.productId, attr.id!, newValue);
        },
      );
    }
    // 2 = RadioList
    else if (attr.attributeControlType!.value == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attr.values!
            .map((value) => RadioListTile<String>(
                  title: Text(
                    value.priceAdjustment == null
                        ? value.name ?? ''
                        : '${value.name} [${value.priceAdjustment}]',
                  ),
                  value: value.id!,
                  groupValue: attr.values!
                      .firstWhere((v) => v.isPreSelected ?? false,
                          orElse: () => attr.values!.first)
                      .id,
                  onChanged: (newValue) {
                    widget.onAttributeChanged(
                      widget.productId,
                      attr.id!,
                      newValue,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ))
            .toList(),
      );
    }
    // 3 = Checkboxes
    else if (attr.attributeControlType!.value == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attr.values!
            .map((value) => CheckboxListTile(
                  title: Text(
                    value.priceAdjustment == null
                        ? value.name ?? ''
                        : '${value.name} [${value.priceAdjustment}]',
                  ),
                  value: value.isPreSelected,
                  onChanged: (newValue) {
                    widget.onAttributeChanged(widget.productId, attr.id!,
                        {'valueId': value.id, 'selected': newValue});
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                ))
            .toList(),
      );
    }
    // 4 = TextBox
    else if (attr.attributeControlType!.value == 4) {
      return TextFormField(
        initialValue: attr.defaultValue ?? '',
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (newValue) {
          widget.onAttributeChanged(widget.productId, attr.id!, newValue);
        },
      );
    }
    // Default case
    return const Text('Unsupported attribute type');
  }
}
