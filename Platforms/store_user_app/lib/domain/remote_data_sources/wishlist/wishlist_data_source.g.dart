// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _WishlistDataSource implements WishlistDataSource {
  _WishlistDataSource(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<MiniWishlistModel>> getWishlistSidebarWishlist() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<MiniWishlistModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Wishlist/SidebarWishlist',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<MiniWishlistModel> _value;
    try {
      _value = ApiResponse<MiniWishlistModel>.fromJson(
        _result.data!,
        (json) => MiniWishlistModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<WishlistModel>> getWishlistIndex([
    String? customerGuid,
  ]) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'customerGuid': customerGuid};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<WishlistModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/wishlist',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<WishlistModel> _value;
    try {
      _value = ApiResponse<WishlistModel>.fromJson(
        _result.data!,
        (json) => WishlistModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_2FEC469E>> postWishlistUpdateQuantity(
    UpdateQuantityModel model,
  ) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_2FEC469E>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Wishlist/UpdateQuantity',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_2FEC469E> _value;
    try {
      _value = ApiResponse<AnonymousType_2FEC469E>.fromJson(
        _result.data!,
        (json) => AnonymousType_2FEC469E.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_97C14FD8>>
  postWishlistAddItemToCartFromWishlist(AddCartFromWishlistModel model) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_97C14FD8>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Wishlist/AddItemToCartFromWishlist',
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
  Future<ApiResponse<AnonymousType_97C14FD8>> getWishlistDeleteItemFromWishlist(
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
            '/wishlist/deleteitemfromwishlist/${shoppingCartId}',
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
  Future<ApiResponse<WishlistEmailAFriendModel>> postWishlistEmailWishlist(
    WishlistEmailAFriendModel model,
  ) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<WishlistEmailAFriendModel>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/emailwishlist',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<WishlistEmailAFriendModel> _value;
    try {
      _value = ApiResponse<WishlistEmailAFriendModel>.fromJson(
        _result.data!,
        (json) =>
            WishlistEmailAFriendModel.fromJson(json as Map<String, dynamic>),
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
