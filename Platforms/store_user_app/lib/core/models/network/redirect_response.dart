import 'package:freezed_annotation/freezed_annotation.dart';

part 'redirect_response.freezed.dart';
part 'redirect_response.g.dart';

@freezed
class RedirectResponse with _$RedirectResponse {
  @JsonSerializable(includeIfNull: false)
  const factory RedirectResponse({
    @Default(null) Uri? redirectUri,
    @Default(null) int? responseStatus,
  }) = _RedirectResponse;

  factory RedirectResponse.fromJson(Map<String, dynamic> json) =>
      _$RedirectResponseFromJson(json);

}
