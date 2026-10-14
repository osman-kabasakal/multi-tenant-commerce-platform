// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ShoppingCartDataSource implements ShoppingCartDataSource {
  _ShoppingCartDataSource(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<MiniShoppingCartModel>>
  getShoppingCartSidebarShoppingCart() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<MiniShoppingCartModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/SidebarShoppingCart',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<MiniShoppingCartModel> _value;
    try {
      _value = ApiResponse<MiniShoppingCartModel>.fromJson(
        _result.data!,
        (json) => MiniShoppingCartModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_A25E79E1>>
  postShoppingCartCheckoutAttributeChange(
    CheckoutAttributeSelectedModel model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_A25E79E1>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/CheckoutAttributeChange',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_A25E79E1> _value;
    try {
      _value = ApiResponse<AnonymousType_A25E79E1>.fromJson(
        _result.data!,
        (json) => AnonymousType_A25E79E1.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_5F706788>>
  postShoppingCartUploadFileCheckoutAttribute(
    String attributeId,
    File file,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'attributeId': attributeId};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'file',
        MultipartFile.fromFileSync(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
    final _options = _setStreamType<ApiResponse<AnonymousType_5F706788>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/UploadFileCheckoutAttribute',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_5F706788> _value;
    try {
      _value = ApiResponse<AnonymousType_5F706788>.fromJson(
        _result.data!,
        (json) => AnonymousType_5F706788.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ShoppingCartModel>> getShoppingCartCart(
    bool checkoutAttributes,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{
      r'checkoutAttributes': checkoutAttributes,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<ShoppingCartModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/Cart',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ShoppingCartModel> _value;
    try {
      _value = ApiResponse<ShoppingCartModel>.fromJson(
        _result.data!,
        (json) => ShoppingCartModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ShoppingCartModel>> getShoppingCartCartSummary() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<ShoppingCartModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/CartSummary',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ShoppingCartModel> _value;
    try {
      _value = ApiResponse<ShoppingCartModel>.fromJson(
        _result.data!,
        (json) => ShoppingCartModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<OrderTotalsModel>> getShoppingCartCartTotal() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<OrderTotalsModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/CartTotal',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<OrderTotalsModel> _value;
    try {
      _value = ApiResponse<OrderTotalsModel>.fromJson(
        _result.data!,
        (json) => OrderTotalsModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_6F488518>> postShoppingCartUpdateQuantity(
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
    final _options = _setStreamType<ApiResponse<AnonymousType_6F488518>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/UpdateQuantity',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_6F488518> _value;
    try {
      _value = ApiResponse<AnonymousType_6F488518>.fromJson(
        _result.data!,
        (json) => AnonymousType_6F488518.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<dynamic> getShoppingCartClearCart() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<dynamic>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/ClearCart',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_845BADBC>> postShoppingCartDeleteCartItem(
    DeleteCartItemModel model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_845BADBC>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/DeleteCartItem',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_845BADBC> _value;
    try {
      _value = ApiResponse<AnonymousType_845BADBC>.fromJson(
        _result.data!,
        (json) => AnonymousType_845BADBC.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_F96D6EB9>>
  postShoppingCartChangeTypeCartItem(ChangeTypeCartItemModel model) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_F96D6EB9>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/ChangeTypeCartItem',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_F96D6EB9> _value;
    try {
      _value = ApiResponse<AnonymousType_F96D6EB9>.fromJson(
        _result.data!,
        (json) => AnonymousType_F96D6EB9.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<bool>?> postShoppingCartStartCheckout(
    CheckoutAttributeSelectedModel model,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<bool>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/StartCheckout',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late ApiResponse<bool>? _value;
    try {
      _value =
          _result.data == null
              ? null
              : ApiResponse<bool>.fromJson(
                _result.data!,
                (json) => json as bool,
              );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_EF661507>>
  postShoppingCartApplyDiscountCoupon(DiscountCouponModel model) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_EF661507>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/ApplyDiscountCoupon',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_EF661507> _value;
    try {
      _value = ApiResponse<AnonymousType_EF661507>.fromJson(
        _result.data!,
        (json) => AnonymousType_EF661507.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_EF661507>> postShoppingCartApplyGiftVoucher(
    GiftVoucherCouponModel model,
  ) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<AnonymousType_EF661507>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/ApplyGiftVoucher',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_EF661507> _value;
    try {
      _value = ApiResponse<AnonymousType_EF661507>.fromJson(
        _result.data!,
        (json) => AnonymousType_EF661507.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<dynamic> postShoppingCartGetEstimateShipping(
    EstimateShippingModel model,
  ) async {
    final _extra = <String, dynamic>{'csrf': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/GetEstimateShipping',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_EF661507>>
  getShoppingCartRemoveDiscountCoupon(String discountId) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'discountId': discountId};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AnonymousType_EF661507>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/RemoveDiscountCoupon',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_EF661507> _value;
    try {
      _value = ApiResponse<AnonymousType_EF661507>.fromJson(
        _result.data!,
        (json) => AnonymousType_EF661507.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_EF661507>>
  getShoppingCartRemoveGiftVoucherCode(String giftVoucherId) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'giftVoucherId': giftVoucherId};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AnonymousType_EF661507>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/ShoppingCart/RemoveGiftVoucherCode',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_EF661507> _value;
    try {
      _value = ApiResponse<AnonymousType_EF661507>.fromJson(
        _result.data!,
        (json) => AnonymousType_EF661507.fromJson(json as Map<String, dynamic>),
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
