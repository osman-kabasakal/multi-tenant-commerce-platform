import '../../models/network/api_response.dart';
import '../../models/network/redirect_response.dart';
import 'json_converter.dart';

class ApiResponseConverter<T>
    implements JsonConverter<ApiResponse<T>, Map<String, dynamic>> {
  final JsonConverter<T, dynamic> valueConverter;

  ApiResponseConverter(this.valueConverter);

  @override
  Map<String, dynamic> toJson(ApiResponse<T> value) {
    return {
      'data': value.data != null
          ? T == String || T == int || T == double || T == bool || T == Map
              ? value.data as T
              : valueConverter.toJson(value.data as T)
          : null,
      'meta': value.meta,
      'redirect': value.redirect?.toJson(),
    };
  }

  @override
  ApiResponse<T> fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      data: json['data'] != null
          ? T == String || T == int || T == double || T == bool || T == Map
              ? json['data'] as T
              : valueConverter.fromJson(json['data'])
          : null,
      meta: (json['meta'] as Map) as Map<String, dynamic>?,
      redirect: json['redirect'] != null
          ? RedirectResponse.fromJson(
              (json['redirect'] as Map<String, dynamic>))
          : null,
    );
  }
}
