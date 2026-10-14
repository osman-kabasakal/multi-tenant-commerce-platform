import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/location/view_models/address_picker_view_model.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/address_list_widget.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/create_or_update_address_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

import '../providers/adress_picker_controller_interface.dart';

class AddressPicker extends ConsumerStatefulWidget {
  final String? selectedAddressId;
  final bool selectable;
  final FutureOr<void> Function(AddressModel)? onAddressSelected;
  final bool addressEditable;
  final ProviderBase<AsyncValue<AddressPickerViewModel>> provider;
  final IAdressPickerController controller;

  const AddressPicker({
    super.key,
    required this.controller,
    required this.provider,
    this.selectedAddressId,
    this.selectable = true,
    this.onAddressSelected,
    this.addressEditable = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPickerState();
}

class _AddressPickerState extends ConsumerState<AddressPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(widget.provider).when(
            data: (data) {
              return AddressListWidget(
                addresses: data.addresses.reversed.toList(),
                editable: widget.addressEditable,
                selectable: widget.selectable,
                refresh: widget.controller.refresh,
                onAddressEdited: (curentAddress) async {
                  if (curentAddress.id == null) return;
                  var addressModel =
                      await widget.controller.getAddressModel(curentAddress.id);

                  var newAddress = await showDialog(
                    context: context,
                    builder: (p0) {
                      return Dialog.fullscreen(
                        child:
                            CreateOrUpdateAddressWidget(model: addressModel!),
                      );
                    },
                    barrierDismissible: true,
                  );

                  // await context.router.pushWidget<AddressModel>(
                  //     CreateOrUpdateAddressWidget(model: addressModel));
                  if (newAddress != null && newAddress is AddressModel) {
                    await widget.controller.updateAddress(newAddress);
                  }
                },
                onAddressSelected: (address) {
                  widget.onAddressSelected?.call(address);
                },
                onAddressDeleted: (p0) {
                  widget.controller.removeAddress(p0.id!);
                },
              );
            },
            error: (err, stack) => AppErrorWidget(
              message: err.toString(),
            ),
            loading: () => AppCard(
              child: SkeletonListView(
                itemCount: 5,
                scrollable: false,
                item: SkeletonListTile(
                  hasSubtitle: true,
                  trailing: SkeletonAvatar(),
                ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var addressModel = await widget.controller.getAddressModel();
          if (addressModel != null) {
            var newAddress = await showDialog(
              context: context,
              builder: (p0) {
                return Dialog.fullscreen(
                    child: CreateOrUpdateAddressWidget(model: addressModel));
              },
              barrierDismissible: true,
            );

            // await context.router.pushWidget<AddressModel>(
            //     CreateOrUpdateAddressWidget(model: addressModel));
            if (newAddress != null && newAddress is AddressModel) {
              await widget.controller.addAddress(newAddress);
            }
          }
        },
        child: Icon(
          Icons.add,
          color: colorPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
