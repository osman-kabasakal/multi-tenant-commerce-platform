import 'package:flutter/material.dart';

class ProductCodesModel {
  final String sku;
  final String mpn;
  final String gtin;
  final bool showSku;
  final bool showMpn;
  final bool showGtin;
  final BrandModel? brandModel;
  final VendorModel? vendorModel;
  final bool showVendor;

  ProductCodesModel({
    this.sku = '',
    this.mpn = '',
    this.gtin = '',
    this.showSku = false,
    this.showMpn = false,
    this.showGtin = false,
    this.brandModel,
    this.vendorModel,
    this.showVendor = false,
  });
}

class BrandModel {
  final String name;
  final String seName;

  BrandModel({
    required this.name,
    required this.seName,
  });
}

class VendorModel {
  final String name;
  final String seName;

  VendorModel({
    required this.name,
    required this.seName,
  });
}

class CodesWidget extends StatelessWidget {
  final ProductCodesModel model;
  final Function(String) onBrandTap;
  final Function(String) onVendorTap;

  const CodesWidget({
    super.key,
    required this.model,
    required this.onBrandTap,
    required this.onVendorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.showSku && model.sku.isNotEmpty)
            _buildInfoRow(context, 'Products.Sku:', model.sku),
          if (model.showMpn && model.mpn.isNotEmpty)
            _buildInfoRow(context, 'Products.Mpn:', model.mpn),
          if (model.showGtin && model.gtin.isNotEmpty)
            _buildInfoRow(context, 'Products.GTIN:', model.gtin),
          if (model.brandModel != null)
            _buildTappableRow(
                context,
                'Products.Brand:',
                model.brandModel!.name,
                () => onBrandTap(model.brandModel!.seName)),
          if (model.showVendor && model.vendorModel != null)
            _buildTappableRow(
                context,
                'Products.Vendor:',
                model.vendorModel!.name,
                () => onVendorTap(model.vendorModel!.seName)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTappableRow(
      BuildContext context, String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onTap,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
