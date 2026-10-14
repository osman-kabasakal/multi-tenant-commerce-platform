import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/address_model/address_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_address_list_model.freezed.dart';
part 'customer_address_list_model.g.dart';

@freezed
class CustomerAddressListModel
    extends StoreJsonSerializable<CustomerAddressListModel>
    with _$CustomerAddressListModel {
  factory CustomerAddressListModel(
      {@JsonKey(name: 'Addresses', includeIfNull: false)
      @Default([])
      List<AddressModel>? addresses,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerAddressListModel;

  factory CustomerAddressListModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressListModelFromJson(json);
}
