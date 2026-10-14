import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/common/user_field/user_field.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'payment_info_step_model.freezed.dart';
part 'payment_info_step_model.g.dart';

@freezed
class PaymentInfoStepModel extends StoreJsonSerializable<PaymentInfoStepModel>
    with _$PaymentInfoStepModel {
  const factory PaymentInfoStepModel(
      {@JsonKey(name: 'PaymentUrl', includeIfNull: false) String? paymentUrl,
      @JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PaymentInfoStepModel;

  factory PaymentInfoStepModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoStepModelFromJson(json);
}
