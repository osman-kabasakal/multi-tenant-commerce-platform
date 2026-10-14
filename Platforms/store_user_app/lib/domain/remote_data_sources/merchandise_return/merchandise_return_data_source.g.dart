// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _MerchandiseReturnDataSource implements MerchandiseReturnDataSource {
  _MerchandiseReturnDataSource(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<CustomerMerchandiseReturnsModel>>
  getMerchandiseReturnCustomerMerchandiseReturns() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<ApiResponse<CustomerMerchandiseReturnsModel>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/merchandisereturn/history',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CustomerMerchandiseReturnsModel> _value;
    try {
      _value = ApiResponse<CustomerMerchandiseReturnsModel>.fromJson(
        _result.data!,
        (json) => CustomerMerchandiseReturnsModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<MerchandiseReturnModel>>
  getMerchandiseReturnMerchandiseReturn(String orderId) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<MerchandiseReturnModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/merchandisereturn/${orderId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<MerchandiseReturnModel> _value;
    try {
      _value = ApiResponse<MerchandiseReturnModel>.fromJson(
        _result.data!,
        (json) => MerchandiseReturnModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<MerchandiseReturnModel>>
  postMerchandiseReturnMerchandiseReturn(MerchandiseReturnModel model) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<MerchandiseReturnModel>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/MerchandiseReturn/MerchandiseReturn',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<MerchandiseReturnModel> _value;
    try {
      _value = ApiResponse<MerchandiseReturnModel>.fromJson(
        _result.data!,
        (json) => MerchandiseReturnModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<MerchandiseReturnDetailsModel>>
  getMerchandiseReturnMerchandiseReturnDetails(
    String merchandiseReturnId,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<MerchandiseReturnDetailsModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/merchandisereturndetails/${merchandiseReturnId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<MerchandiseReturnDetailsModel> _value;
    try {
      _value = ApiResponse<MerchandiseReturnDetailsModel>.fromJson(
        _result.data!,
        (json) => MerchandiseReturnDetailsModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
