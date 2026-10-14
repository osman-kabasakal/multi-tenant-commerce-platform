import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';

class AddressCardWidget extends HookConsumerWidget {
  final AddressModel address;
  final bool isSelected;
  final FutureOr<void> Function()? onSelected;
  final FutureOr<void> Function()? onTap;
  final FutureOr<void> Function()? onDelete;
  final bool editable;
  final bool selectable;
  const AddressCardWidget({
    super.key,
    required this.address,
    required this.isSelected,
    this.onSelected,
    this.onTap,
    this.onDelete,
    this.editable = true,
    this.selectable = true,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = getIt<ThemeController>().isDarkMode;
    var contentWidget = Stack(
      fit: StackFit.loose,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(isDarkMode),
                  const SizedBox(height: 8),
                  _buildAddressDetails(context, isDarkMode),
                ],
              ),
            ),
            if (editable) _buildEditButton(),
          ],
        ),
        // if (editable)
        //   Positioned(
        //     top: -10,
        //     right: -10,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 16),
        //       child: _buildDeleteButton(isDarkMode),
        //     ),
        //   ),
      ],
    );

    if (!selectable) {
      return contentWidget;
    }

    return SelectableCard(
        onTap: onSelected,
        isSelected: isSelected,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: contentWidget,
        ));
  }

  Widget _buildTitleSection(bool isDarkMode) {
    final displayName = _getDisplayName();

    return Row(
      children: [
        SvgPicture.asset(
          locationIcon,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            isSelected ? colorPrimary : colorGrey500,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.fontFamily,
              color: isSelected
                  ? colorPrimary
                  : (isDarkMode ? whiteColor : textColor),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressDetails(BuildContext context, bool isDarkMode) {
    final addressText = [
      address.company,
      address.address1,
      address.address2,
      address.city,
      address.stateProvinceName,
      address.zipPostalCode,
      address.countryName,
      address.phoneNumber,
    ].where((element) => element != null && element.isNotEmpty).join(', ');

    return Text(
      addressText,
      style: context.textTheme.bodyMedium?.copyWith(
        color: isDarkMode ? colorGrey300 : colorGrey700,
        height: 1.5,
        fontFamily: AppTheme.fontFamily,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      icon: SvgPicture.asset(
        edit1Icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          colorPrimary,
          BlendMode.srcIn,
        ),
      ),
      onPressed: onTap,
      splashRadius: 24,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    );
  }

  String _getDisplayName() {
    if (address.nameEnabled == true && address.name?.isNotEmpty == true) {
      return address.name!;
    }

    final nameParts = [
      address.firstName,
      address.lastName,
    ].where((part) => part != null && part.isNotEmpty);

    return nameParts.join(' ');
  }
}
