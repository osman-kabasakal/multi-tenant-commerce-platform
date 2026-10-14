import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/checkout/update_section_json_model/update_section_json_model.dart';

part 'anonymous_type_55_b93_bb6.freezed.dart';
part 'anonymous_type_55_b93_bb6.g.dart';

@freezed
class AnonymousType_55B93BB6
    extends StoreJsonSerializable<AnonymousType_55B93BB6>
    with _$AnonymousType_55B93BB6 {
  factory AnonymousType_55B93BB6({
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
  }) = _AnonymousType_55B93BB6;

  factory AnonymousType_55B93BB6.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_55B93BB6FromJson(json);
}
