import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'merchandise_return_item_model/merchandise_return_item_model.dart';

import '../../../orders/merchandise_return_status/merchandise_return_status.dart';

import '../../common/address_model/address_model.dart';

import 'merchandise_return_note/merchandise_return_note.dart';

import '../../../common/user_field/user_field.dart';

part 'merchandise_return_details_model.freezed.dart';
part 'merchandise_return_details_model.g.dart';

@freezed
class MerchandiseReturnDetailsModel
    extends StoreJsonSerializable<MerchandiseReturnDetailsModel>
    with _$MerchandiseReturnDetailsModel {
  factory MerchandiseReturnDetailsModel(
      {@JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
      @Default([])
      List<MerchandiseReturnItemModel>? merchandiseReturnItems,
      @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
      @JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
      @JsonKey(name: 'ExternalId', includeIfNull: false) String? externalId,
      @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
      @Default(MerchandiseReturnStatus.pending)
      MerchandiseReturnStatus? merchandiseReturnStatus,
      @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
      DateTime? createdOnUtc,
      @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
      @Default(false)
      bool? showPickupDate,
      @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
      @Default(false)
      bool? showPickupAddress,
      @JsonKey(name: 'PickupAddress', includeIfNull: false)
      AddressModel? pickupAddress,
      @JsonKey(name: 'PickupDate', includeIfNull: false) DateTime? pickupDate,
      @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
      @Default([])
      List<MerchandiseReturnNote>? merchandiseReturnNotes,
      @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
      @Default(false)
      bool? showAddMerchandiseReturnNote,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnDetailsModel;

  factory MerchandiseReturnDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnDetailsModelFromJson(json);
}
