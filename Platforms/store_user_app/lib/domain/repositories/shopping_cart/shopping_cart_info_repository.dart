

import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';

import '../../../core/models/network/api_response.dart';
import '../../entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';
import '../../remote_data_sources/shopping_cart/shopping_cart_info_data_source.dart';

@lazySingleton
class ShoppingCartInfoRepository extends BaseRepository {
  final ShoppingCartInfoDataSource _dataSource;

  ShoppingCartInfoRepository(this._dataSource, super.decorator, super.eventBus);


  Future<ApiResponse<ShoppingCartInfoResponse>?>
  getShoppingCartSidebarShoppingCart() async {
    return await decorator.execute<ApiResponse<ShoppingCartInfoResponse>>(
      operationName: "/ShoppingCartInfo/info",
      cacheKey: generateCacheKey("/ShoppingCartInfo/info", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getShoppingCartInfo();
      },
    );
  }
}