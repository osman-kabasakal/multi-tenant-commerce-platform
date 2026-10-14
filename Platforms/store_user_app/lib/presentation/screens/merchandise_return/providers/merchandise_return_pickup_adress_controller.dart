import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/presentation/widgets/location/providers/adress_picker_controller_interface.dart';
import 'package:store_user_app/presentation/widgets/location/view_models/address_picker_view_model.dart';

part 'merchandise_return_pickup_adress_controller.g.dart';

@riverpod
class MerchandiseReturnPickupAdressController
    extends _$MerchandiseReturnPickupAdressController
    with FamilyAsyncNotiferAddressPickerControllerBase {
  ValueNotifier<AddressModel?> newAddressNotifier =
      ValueNotifier<AddressModel?>(null);

  @override
  FutureOr<AddressPickerViewModel> build(
      MerchandiseReturnModel initialModel) async {
    return AddressPickerViewModel(
      addresses: initialModel.existingAddresses ?? [],
    );
  }

  @override
  Future<void> addAddress(AddressModel address) {
    newAddressNotifier.value = address;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        addresses: [...(initialModel.existingAddresses ?? []), address],
      ),
    );
    return Future.value();
  }

  @override
  Future<AddressModel?> getAddressModel([String? addressId]) {
    if (addressId.isEmptyOrNull) {
      if (newAddressNotifier.value != null) {
        return Future.value(newAddressNotifier.value);
      }
      return Future.value(initialModel.merchandiseReturnNewAddress);
    }

    final address = state.requireValue.addresses.firstWhere(
      (element) => element.id == addressId,
      orElse: () => initialModel.merchandiseReturnNewAddress ?? AddressModel(),
    );

    return Future.value(address);
  }

  @override
  Future<void> refresh() {
    state = AsyncValue.data(state.requireValue.copyWith(
      addresses: initialModel.existingAddresses ?? [],
    ));
    return Future.value();
  }

  @override
  Future<void> removeAddress(String addressId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAddress(AddressModel address) {
    if (address.id == null) {
      addAddress(address);
    }

    state = AsyncValue.data(
      state.requireValue.copyWith(
        addresses: [
          ...state.requireValue.addresses
              .where((element) => element.id != address.id),
          address,
        ],
      ),
    );
    return Future.value();
  }
}
