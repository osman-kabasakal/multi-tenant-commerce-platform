import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';

part 'anonymous_type_2_fbe9_f46.freezed.dart';
part 'anonymous_type_2_fbe9_f46.g.dart';

@freezed
class AnonymousType_2FBE9F46
    extends StoreJsonSerializable<AnonymousType_2FBE9F46>
    with _$AnonymousType_2FBE9F46 {
  factory AnonymousType_2FBE9F46({
    @JsonKey(name: 'update_section', includeIfNull: false)
    UpdateSectionJsonModel? update_section,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    @Default(false)
    bool? wrong_shipping_address,
    @JsonKey(name: 'model_state', includeIfNull: false)
    @Default([])
    List<String> model_state,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
    int? success,
    String? redirect,
  }) = _AnonymousType_2FBE9F46;

  factory AnonymousType_2FBE9F46.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_2FBE9F46FromJson(json);
}
