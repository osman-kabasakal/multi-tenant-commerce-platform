import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/common/common_data_source.dart';
import '../../entities/models/common/sitemap_model/sitemap_model.dart';
import '../../entities/anonymous_type__b6395690/anonymous_type__b6395690.dart';
import '../../entities/anonymous_type_343_f9_e63/anonymous_type_343_f9_e63.dart';
import '../../entities/models/common/location_model/location_model.dart';

@lazySingleton
class CommonRepository extends BaseRepository {
  final CommonDataSource _dataSource;

  CommonRepository(this._dataSource, super.decorator, super.eventBus);

  Future<dynamic> getCommonSetLanguage(
      String langCode, String? returnUrl) async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/SetLanguage",
      cacheKey: generateCacheKey("/Common/SetLanguage", [langCode, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSetLanguage(langCode, returnUrl);
      },
    );
  }

  Future<dynamic> getCommonSetCurrency(
      String currencyCode, String? returnUrl) async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/SetCurrency",
      cacheKey:
          generateCacheKey("/Common/SetCurrency", [currencyCode, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSetCurrency(currencyCode, returnUrl);
      },
    );
  }

  Future<dynamic> getCommonSetStore(String shortcut, String? returnUrl) async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/SetStore",
      cacheKey: generateCacheKey("/Common/SetStore", [shortcut, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSetStore(shortcut, returnUrl);
      },
    );
  }

  Future<dynamic> getCommonSetTaxType(
      int customerTaxType, String? returnUrl) async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/SetTaxType",
      cacheKey:
          generateCacheKey("/Common/SetTaxType", [customerTaxType, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSetTaxType(
            customerTaxType, returnUrl);
      },
    );
  }

  Future<dynamic> getCommonSetStoreTheme(
      String themeName, String? returnUrl) async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/SetStoreTheme",
      cacheKey:
          generateCacheKey("/Common/SetStoreTheme", [themeName, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSetStoreTheme(themeName, returnUrl);
      },
    );
  }

  Future<ApiResponse<SitemapModel>?> getCommonSitemap() async {
    return await decorator.execute<ApiResponse<SitemapModel>>(
      operationName: "/Common/Sitemap",
      cacheKey: generateCacheKey("/Common/Sitemap", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonSitemap();
      },
    );
  }

  Future<ApiResponse<AnonymousType_B6395690>?> postCommonCookieAccept(
      bool accept) async {
    return await decorator.execute<ApiResponse<AnonymousType_B6395690>>(
      operationName: "/Common/CookieAccept",
      cacheKey: generateCacheKey("/Common/CookieAccept", [accept]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCommonCookieAccept(accept);
      },
    );
  }

  Future<ApiResponse<AnonymousType_343F9E63>?>
      getCommonPrivacyPreference() async {
    return await decorator.execute<ApiResponse<AnonymousType_343F9E63>>(
      operationName: "/Common/PrivacyPreference",
      cacheKey: generateCacheKey("/Common/PrivacyPreference", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonPrivacyPreference();
      },
    );
  }

  Future<ApiResponse<AnonymousType_343F9E63>?> postCommonPrivacyPreference(
      Map<String, String> model) async {
    return await decorator.execute<ApiResponse<AnonymousType_343F9E63>>(
      operationName: "/Common/PrivacyPreference",
      cacheKey: generateCacheKey("/Common/PrivacyPreference", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCommonPrivacyPreference(model);
      },
    );
  }

  Future<dynamic> getCommonRobotsTextFile() async {
    return await decorator.execute<dynamic>(
      operationName: "/Common/RobotsTextFile",
      cacheKey: generateCacheKey("/Common/RobotsTextFile", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCommonRobotsTextFile();
      },
    );
  }

  Future<String?> postCommonSaveCurrentPosition(LocationModel model) async {
    return await decorator.execute<String>(
      operationName: "/Common/SaveCurrentPosition",
      cacheKey:
          null, //generateCacheKey("/Common/SaveCurrentPosition", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCommonSaveCurrentPosition(model);
      },
    );
  }
}
