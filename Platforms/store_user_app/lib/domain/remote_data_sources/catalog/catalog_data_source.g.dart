// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _CatalogDataSource implements CatalogDataSource {
  _CatalogDataSource(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<CategoryModel>> getCatalogCategory({
    required String categoryId,
    CatalogPagingFilteringModel? command,
    Map<String, String>? filterItems,
  }) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'categoryId': categoryId};
    queryParameters.addAll(filterItems ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<ApiResponse<CategoryModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/Category',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CategoryModel> _value;
    try {
      _value = ApiResponse<CategoryModel>.fromJson(
        _result.data!,
        (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CategoryListModel>> getCatalogCategoryAll(
    CategoryPagingModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<CategoryListModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/CategoryAll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CategoryListModel> _value;
    try {
      _value = ApiResponse<CategoryListModel>.fromJson(
        _result.data!,
        (json) => CategoryListModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<BrandModel>> getCatalogBrand(
    String brandId,
    CatalogPagingFilteringModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'brandId': brandId};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<BrandModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/Brand',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<BrandModel> _value;
    try {
      _value = ApiResponse<BrandModel>.fromJson(
        _result.data!,
        (json) => BrandModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<BrandListModel>> getCatalogBrandAll(
    BrandPagingModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<BrandListModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/BrandAll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<BrandListModel> _value;
    try {
      _value = ApiResponse<BrandListModel>.fromJson(
        _result.data!,
        (json) => BrandListModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CollectionModel>> getCatalogCollection(
    String collectionId,
    CatalogPagingFilteringModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'collectionId': collectionId};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<CollectionModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/Collection',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CollectionModel> _value;
    try {
      _value = ApiResponse<CollectionModel>.fromJson(
        _result.data!,
        (json) => CollectionModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CollectionListModel>> getCatalogCollectionAll(
    CollectionPagingModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<CollectionListModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/CollectionAll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CollectionListModel> _value;
    try {
      _value = ApiResponse<CollectionListModel>.fromJson(
        _result.data!,
        (json) => CollectionListModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<VendorModel>> getCatalogVendor(
    String vendorId,
    CatalogPagingFilteringModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'vendorId': vendorId};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<VendorModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/Vendor',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<VendorModel> _value;
    try {
      _value = ApiResponse<VendorModel>.fromJson(
        _result.data!,
        (json) => VendorModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<VendorListModel>> getCatalogVendorAll(
    VendorPagingModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<VendorListModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/VendorAll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<VendorListModel> _value;
    try {
      _value = ApiResponse<VendorListModel>.fromJson(
        _result.data!,
        (json) => VendorListModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<VendorReviewsModel>> postCatalogVendorReviews(
    VendorReviewsModel model,
  ) async {
    final _extra = <String, dynamic>{
      'responseType': ApiResponse(),
      'csrf': true,
    };
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<ApiResponse<VendorReviewsModel>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/VendorReviews',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<VendorReviewsModel> _value;
    try {
      _value = ApiResponse<VendorReviewsModel>.fromJson(
        _result.data!,
        (json) => VendorReviewsModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AnonymousType_1EDE6D30>>
  postCatalogSetVendorReviewHelpfulness(
    String VendorReviewId,
    String vendorId,
    bool washelpful,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{
      r'VendorReviewId': VendorReviewId,
      r'vendorId': vendorId,
      r'washelpful': washelpful,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AnonymousType_1EDE6D30>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/SetVendorReviewHelpfulness',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AnonymousType_1EDE6D30> _value;
    try {
      _value = ApiResponse<AnonymousType_1EDE6D30>.fromJson(
        _result.data!,
        (json) => AnonymousType_1EDE6D30.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ProductsByTagModel>> getCatalogProductsByTag(
    String productTagId,
    CatalogPagingFilteringModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'productTagId': productTagId};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<ProductsByTagModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/ProductsByTag',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ProductsByTagModel> _value;
    try {
      _value = ApiResponse<ProductsByTagModel>.fromJson(
        _result.data!,
        (json) => ProductsByTagModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ProductsByTagModel>> getCatalogProductsByTagName(
    String seName,
    CatalogPagingFilteringModel command,
  ) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'seName': seName};
    final _headers = <String, dynamic>{};
    final _data = {'command': command};
    final _options = _setStreamType<ApiResponse<ProductsByTagModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/ProductsByTagName',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ProductsByTagModel> _value;
    try {
      _value = ApiResponse<ProductsByTagModel>.fromJson(
        _result.data!,
        (json) => ProductsByTagModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<PopularProductTagsModel>>
  getCatalogProductTagsAll() async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<PopularProductTagsModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/ProductTagsAll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<PopularProductTagsModel> _value;
    try {
      _value = ApiResponse<PopularProductTagsModel>.fromJson(
        _result.data!,
        (json) =>
            PopularProductTagsModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<SearchModel>> getCatalogSearch({
    required String query,
    Map<String, String>? filterItems,
    required SearchModel model,
    required CatalogPagingFilteringModel command,
  }) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{r'q': query};
    queryParameters.addAll(filterItems ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'model': model, 'command': command};
    final _options = _setStreamType<ApiResponse<SearchModel>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/Search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<SearchModel> _value;
    try {
      _value = ApiResponse<SearchModel>.fromJson(
        _result.data!,
        (json) => SearchModel.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<SearchAutoCompleteModel>>>
  getCatalogSearchTermAutoComplete(String term, String categoryId) async {
    final _extra = <String, dynamic>{'responseType': ApiResponse()};
    final queryParameters = <String, dynamic>{
      r'term': term,
      r'categoryId': categoryId,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<SearchAutoCompleteModel>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/Catalog/SearchTermAutoComplete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<SearchAutoCompleteModel>> _value;
    try {
      _value = ApiResponse<List<SearchAutoCompleteModel>>.fromJson(
        _result.data!,
        (json) =>
            json is List<dynamic>
                ? json
                    .map<SearchAutoCompleteModel>(
                      (i) => SearchAutoCompleteModel.fromJson(
                        i as Map<String, dynamic>,
                      ),
                    )
                    .toList()
                : List.empty(),
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
