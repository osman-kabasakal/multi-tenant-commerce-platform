import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/common/sitemap_model/sitemap_model.dart';
import '../../entities/anonymous_type__b6395690/anonymous_type__b6395690.dart';
import '../../entities/anonymous_type_343_f9_e63/anonymous_type_343_f9_e63.dart';
import '../../entities/models/common/location_model/location_model.dart';

part 'common_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class CommonDataSource {
  @factoryMethod
  factory CommonDataSource(Dio dio) {
    return _CommonDataSource(dio);
  }

  @GET('/Common/SetLanguage')
  Future<dynamic> getCommonSetLanguage(@Query('langCode') String langCode,
      @Query('returnUrl') String? returnUrl);

  @GET('/Common/SetCurrency')
  Future<dynamic> getCommonSetCurrency(
      @Query('currencyCode') String currencyCode,
      @Query('returnUrl') String? returnUrl);

  @GET('/Common/SetStore')
  Future<dynamic> getCommonSetStore(@Query('shortcut') String shortcut,
      @Query('returnUrl') String? returnUrl);

  @GET('/Common/SetTaxType')
  Future<dynamic> getCommonSetTaxType(
      @Query('customerTaxType') int customerTaxType,
      @Query('returnUrl') String? returnUrl);

  @GET('/Common/SetStoreTheme')
  Future<dynamic> getCommonSetStoreTheme(@Query('themeName') String themeName,
      @Query('returnUrl') String? returnUrl);

  @GET('/Common/Sitemap')
  @Extra({'responseType': ApiResponse<SitemapModel>()})
  Future<ApiResponse<SitemapModel>> getCommonSitemap();

  @POST('/Common/CookieAccept')
  @Extra({'responseType': ApiResponse<AnonymousType_B6395690>()})
  Future<ApiResponse<AnonymousType_B6395690>> postCommonCookieAccept(
      @Query('accept') bool accept);

  @GET('/Common/PrivacyPreference')
  @Extra({'responseType': ApiResponse<AnonymousType_343F9E63>()})
  Future<ApiResponse<AnonymousType_343F9E63>> getCommonPrivacyPreference();

  @POST('/Common/PrivacyPreference')
  @Extra({'responseType': ApiResponse<AnonymousType_343F9E63>()})
  Future<ApiResponse<AnonymousType_343F9E63>> postCommonPrivacyPreference(
      @Body() Map<String, String> model);

  @GET('/Common/RobotsTextFile')
  Future<dynamic> getCommonRobotsTextFile();

  @POST('/Common/SaveCurrentPosition')
  Future<dynamic> postCommonSaveCurrentPosition(@Body() LocationModel model);
}
