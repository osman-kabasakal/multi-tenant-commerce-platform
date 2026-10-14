import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'checkout_step_response.freezed.dart';
part 'checkout_step_response.g.dart';

@freezed
class CheckoutStepResponse extends StoreJsonSerializable<CheckoutStepResponse>
    with _$CheckoutStepResponse {
  @JsonSerializable(includeIfNull: false)
  const factory CheckoutStepResponse(
      {@JsonKey(name: 'update_section') UpdateSectionJsonModel? UpdateSection,
      @JsonKey(name: 'goto_section') String? goToSection,
      @JsonKey(name: 'wrong_billing_address')
      @Default(false)
      bool wrongBillingAddress,
      @JsonKey(name: 'model_state') @Default([]) List<String> modelState,
      @JsonKey(name: 'error') int? error,
      @JsonKey(name: 'message') String? message,
      int? success,
      String? redirect}) = _CheckoutStepResponse;

  factory CheckoutStepResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutStepResponseFromJson(json);
}
