import 'package:flutter/material.dart';
import 'package:store_user_app/domain/entities/catalog/gift_voucher_type/gift_voucher_type.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/gift_voucher_model/gift_voucher_model.dart';

// enum GiftVoucherType { Virtual, Physical }

// class GiftVoucherModel {
//   final bool isGiftVoucher;
//   final GiftVoucherType giftVoucherType;
//   final String recipientName;
//   final String recipientEmail;
//   final String senderName;
//   final String senderEmail;
//   final String message;

//   GiftVoucherModel({
//     required this.isGiftVoucher,
//     required this.giftVoucherType,
//     this.recipientName = '',
//     this.recipientEmail = '',
//     this.senderName = '',
//     this.senderEmail = '',
//     this.message = '',
//   });
// }

class GiftVoucherInfoWidget extends StatefulWidget {
  final GiftVoucherModel model;
  final Function(GiftVoucherModel) onGiftVoucherInfoChanged;
  final String productId;

  const GiftVoucherInfoWidget({
    super.key,
    required this.model,
    required this.onGiftVoucherInfoChanged,
    required this.productId,
  });

  @override
  State<GiftVoucherInfoWidget> createState() => _GiftVoucherInfoWidgetState();
}

class _GiftVoucherInfoWidgetState extends State<GiftVoucherInfoWidget> {
  late TextEditingController recipientNameController;
  late TextEditingController recipientEmailController;
  late TextEditingController senderNameController;
  late TextEditingController senderEmailController;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    recipientNameController =
        TextEditingController(text: widget.model.recipientName);
    recipientEmailController =
        TextEditingController(text: widget.model.recipientEmail);
    senderNameController = TextEditingController(text: widget.model.senderName);
    senderEmailController =
        TextEditingController(text: widget.model.senderEmail);
    messageController = TextEditingController(text: widget.model.message);
  }

  @override
  void dispose() {
    recipientNameController.dispose();
    recipientEmailController.dispose();
    senderNameController.dispose();
    senderEmailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _updateGiftVoucherInfo() {
    widget.onGiftVoucherInfoChanged(
      GiftVoucherModel(
        isGiftVoucher: widget.model.isGiftVoucher,
        giftVoucherType: widget.model.giftVoucherType,
        recipientName: recipientNameController.text,
        recipientEmail: recipientEmailController.text,
        senderName: senderNameController.text,
        senderEmail: senderEmailController.text,
        message: messageController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.model.isGiftVoucher ?? false)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Products.GiftVoucher.RecipientName:',
            controller: recipientNameController,
            hint: 'Enter recipient name',
          ),
          if (widget.model.giftVoucherType == GiftVoucherType.virtual)
            _buildTextField(
              label: 'Products.GiftVoucher.RecipientEmail:',
              controller: recipientEmailController,
              hint: 'Enter recipient email',
              keyboardType: TextInputType.emailAddress,
            ),
          _buildTextField(
            label: 'Products.GiftVoucher.SenderName:',
            controller: senderNameController,
            hint: 'Enter sender name',
          ),
          if (widget.model.giftVoucherType == GiftVoucherType.virtual)
            _buildTextField(
              label: 'Products.GiftVoucher.SenderEmail:',
              controller: senderEmailController,
              hint: 'Enter sender email',
              keyboardType: TextInputType.emailAddress,
            ),
          _buildTextField(
            label: 'Products.GiftVoucher.Message:',
            controller: messageController,
            hint: 'Enter message',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => _updateGiftVoucherInfo(),
          ),
        ],
      ),
    );
  }
}
