import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'merchandise_return_reason_model.freezed.dart';
part 'merchandise_return_reason_model.g.dart';

@freezed
class MerchandiseReturnReasonModel
    extends StoreJsonSerializable<MerchandiseReturnReasonModel>
    with _$MerchandiseReturnReasonModel {
  factory MerchandiseReturnReasonModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnReasonModel;

  factory MerchandiseReturnReasonModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnReasonModelFromJson(json);
}
