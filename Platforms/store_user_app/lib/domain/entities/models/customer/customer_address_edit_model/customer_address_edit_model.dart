import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/address_model/address_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_address_edit_model.freezed.dart';
part 'customer_address_edit_model.g.dart';

@freezed
class CustomerAddressEditModel
    extends StoreJsonSerializable<CustomerAddressEditModel>
    with _$CustomerAddressEditModel {
  factory CustomerAddressEditModel(
      {@JsonKey(name: 'Address', includeIfNull: false) AddressModel? address,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerAddressEditModel;

  factory CustomerAddressEditModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressEditModelFromJson(json);
}
