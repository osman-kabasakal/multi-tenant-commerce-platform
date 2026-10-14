import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';

import '../../entities/models/common/state_province_model/state_province_model.dart';

part 'country_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class CountryDataSource {
  @factoryMethod
  factory CountryDataSource(Dio dio) {
    return _CountryDataSource(dio);
  }

  @GET('/Country/GetStatesByCountryId')
  @Extra({'responseType': ApiResponse<List<StateProvinceModel>>()})
  Future<ApiResponse<List<StateProvinceModel>>> getCountryGetStatesByCountryId(
      @Query('countryId') String countryId,
      @Query('addSelectStateItem') bool addSelectStateItem);
}
