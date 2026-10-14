import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/merchandise_return/merchandise_return_data_source.dart';
import '../../entities/models/orders/customer_merchandise_returns_model/customer_merchandise_returns_model.dart';
import '../../entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import '../../entities/models/orders/merchandise_return_details_model/merchandise_return_details_model.dart';

@lazySingleton
class MerchandiseReturnRepository extends BaseRepository {
  final MerchandiseReturnDataSource _dataSource;

  MerchandiseReturnRepository(
      this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<CustomerMerchandiseReturnsModel>?>
      getMerchandiseReturnCustomerMerchandiseReturns() async {
    return await decorator
        .execute<ApiResponse<CustomerMerchandiseReturnsModel>>(
      operationName: "/MerchandiseReturn/CustomerMerchandiseReturns",
      cacheKey: null,
      // generateCacheKey("/MerchandiseReturn/CustomerMerchandiseReturns", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getMerchandiseReturnCustomerMerchandiseReturns();
      },
    );
  }

  Future<ApiResponse<MerchandiseReturnModel>?>
      getMerchandiseReturnMerchandiseReturn(String orderId) async {
    return await decorator.execute<ApiResponse<MerchandiseReturnModel>>(
      operationName: "/MerchandiseReturn/MerchandiseReturn",
      cacheKey:
          null, //generateCacheKey("/MerchandiseReturn/MerchandiseReturn", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getMerchandiseReturnMerchandiseReturn(orderId);
      },
    );
  }

  Future<ApiResponse<MerchandiseReturnModel>?>
      postMerchandiseReturnMerchandiseReturn(
          MerchandiseReturnModel model) async {
    return await decorator.execute<ApiResponse<MerchandiseReturnModel>>(
      operationName: "/MerchandiseReturn/MerchandiseReturn",
      cacheKey: null,
      // generateCacheKey("/MerchandiseReturn/MerchandiseReturn", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postMerchandiseReturnMerchandiseReturn(model);
      },
    );
  }

  Future<ApiResponse<MerchandiseReturnDetailsModel>?>
      getMerchandiseReturnMerchandiseReturnDetails(
          String merchandiseReturnId) async {
    return await decorator.execute<ApiResponse<MerchandiseReturnDetailsModel>>(
      operationName: "/MerchandiseReturn/MerchandiseReturnDetails",
      cacheKey: null,
      //generateCacheKey(
      // "/MerchandiseReturn/MerchandiseReturnDetails", [merchandiseReturnId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getMerchandiseReturnMerchandiseReturnDetails(merchandiseReturnId);
      },
    );
  }
}
