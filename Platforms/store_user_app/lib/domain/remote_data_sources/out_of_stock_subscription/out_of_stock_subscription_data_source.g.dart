// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_of_stock_subscription_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _OutOfStockSubscriptionDataSource
    implements OutOfStockSubscriptionDataSource {
  _OutOfStockSubscriptionDataSource(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<String> getOutOfStockSubscriptionSubscribeButton(
    String productId,
    String warehouseId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'productId': productId,
      r'warehouseId': warehouseId,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<String>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/OutOfStockSubscription/SubscribeButton',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_F3E1E574>>
  postOutOfStockSubscriptionSubscribePopup(ProductModel model) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_F3E1E574>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/OutOfStockSubscription/SubscribePopup',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_F3E1E574> _value;
    try {
      _value = ApiResponse<AnonymousType_F3E1E574>.fromJson(
        _result.data!,
        (json) => AnonymousType_F3E1E574.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>>
  getOutOfStockSubscriptionCustomerSubscriptions(int pageNumber) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<ApiResponse<CustomerOutOfStockSubscriptionsModel>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/OutOfStockSubscription/CustomerSubscriptions',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CustomerOutOfStockSubscriptionsModel> _value;
    try {
      _value = ApiResponse<CustomerOutOfStockSubscriptionsModel>.fromJson(
        _result.data!,
        (json) => CustomerOutOfStockSubscriptionsModel.fromJson(
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
  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>>
  postOutOfStockSubscriptionCustomerSubscriptions(
    List<String> subscriptions,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = subscriptions;
    final _options =
        _setStreamType<ApiResponse<CustomerOutOfStockSubscriptionsModel>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/OutOfStockSubscription/CustomerSubscriptions',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CustomerOutOfStockSubscriptionsModel> _value;
    try {
      _value = ApiResponse<CustomerOutOfStockSubscriptionsModel>.fromJson(
        _result.data!,
        (json) => CustomerOutOfStockSubscriptionsModel.fromJson(
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
