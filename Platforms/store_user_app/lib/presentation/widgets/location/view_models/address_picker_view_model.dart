import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';

part 'address_picker_view_model.freezed.dart';

@freezed
class AddressPickerViewModel with _$AddressPickerViewModel {
  const factory AddressPickerViewModel({
    String? error,
    @Default([]) List<AddressModel> addresses,
  }) = _AddressPickerViewModel;
}
