import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import '../view_models/address_picker_view_model.dart';

abstract class IAdressPickerController {
  AsyncValue<AddressPickerViewModel> get state;
  Future<AddressModel?> getAddressModel([String? addressId]);
  Future<void> addAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<void> removeAddress(String addressId);
  Future<void> refresh();
}

mixin AsyncNotiferAddressPickerControllerBase
    on AutoDisposeAsyncNotifier<AddressPickerViewModel>
    implements IAdressPickerController {}

mixin FamilyAsyncNotiferAddressPickerControllerBase
    on BuildlessAutoDisposeAsyncNotifier<AddressPickerViewModel>
    implements IAdressPickerController {}
