// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_cart_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ActionCartDataSource implements ActionCartDataSource {
  _ActionCartDataSource(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<AnonymousType_97C14FD8>> postActionCartAddProductCatalog(
    ProductCatalogCart model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_97C14FD8>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ActionCart/AddProductCatalog',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_97C14FD8> _value;
    try {
      _value = ApiResponse<AnonymousType_97C14FD8>.fromJson(
        _result.data!,
        (json) => AnonymousType_97C14FD8.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_FA6C6C9F>> postActionCartAddProductDetails(
    ProductDetailsCart model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_FA6C6C9F>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ActionCart/AddProductDetails',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_FA6C6C9F> _value;
    try {
      _value = ApiResponse<AnonymousType_FA6C6C9F>.fromJson(
        _result.data!,
        (json) => AnonymousType_FA6C6C9F.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_97C14FD8>> postActionCartUpdateItemCart(
    ProductDetailsCart model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_97C14FD8>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ActionCart/UpdateItemCart',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_97C14FD8> _value;
    try {
      _value = ApiResponse<AnonymousType_97C14FD8>.fromJson(
        _result.data!,
        (json) => AnonymousType_97C14FD8.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_97C14FD8>> getActionCartGetItemCart(
    String shoppingCartId,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AnonymousType_97C14FD8>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/getitemcart/${shoppingCartId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_97C14FD8> _value;
    try {
      _value = ApiResponse<AnonymousType_97C14FD8>.fromJson(
        _result.data!,
        (json) => AnonymousType_97C14FD8.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_01FA76B1>> postActionCartAddBid(
    AddBidModel model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_01FA76B1>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ActionCart/AddBid',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_01FA76B1> _value;
    try {
      _value = ApiResponse<AnonymousType_01FA76B1>.fromJson(
        _result.data!,
        (json) => AnonymousType_01FA76B1.fromJson(json as Map<String, dynamic>),
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
