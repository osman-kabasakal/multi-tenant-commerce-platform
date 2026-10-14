import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../entities/models/common/state_province_model/state_province_model.dart';
import '../../remote_data_sources/country/country_data_source.dart';

@lazySingleton
class CountryRepository extends BaseRepository {
  final CountryDataSource _dataSource;

  CountryRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<List<StateProvinceModel>>?> getCountryGetStatesByCountryId(
      String countryId, bool addSelectStateItem) async {
    return await decorator.execute<ApiResponse<List<StateProvinceModel>>>(
      operationName: "/Country/GetStatesByCountryId",
      cacheKey: generateCacheKey(
          "/Country/GetStatesByCountryId", [countryId, addSelectStateItem]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCountryGetStatesByCountryId(
            countryId, addSelectStateItem);
      },
    );
  }
}
