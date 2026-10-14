import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_1_ede6_d30.freezed.dart';
part 'anonymous_type_1_ede6_d30.g.dart';

@freezed
class AnonymousType_1EDE6D30
    extends StoreJsonSerializable<AnonymousType_1EDE6D30>
    with _$AnonymousType_1EDE6D30 {
  factory AnonymousType_1EDE6D30(
          {@JsonKey(name: 'Result', includeIfNull: false) String? result,
          @JsonKey(name: 'TotalYes', includeIfNull: false) int? totalYes,
          @JsonKey(name: 'TotalNo', includeIfNull: false) int? totalNo}) =
      _AnonymousType_1EDE6D30;

  factory AnonymousType_1EDE6D30.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_1EDE6D30FromJson(json);
}
