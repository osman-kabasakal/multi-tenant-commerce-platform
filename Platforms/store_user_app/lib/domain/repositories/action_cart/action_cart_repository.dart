import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/action_cart/action_cart_data_source.dart';
import '../../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../../entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import '../../entities/anonymous_type_01_fa76_b1/anonymous_type_01_fa76_b1.dart';
import '../../entities/models/shopping_cart/product_catalog_cart/product_catalog_cart.dart';
import '../../entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import '../../entities/models/shopping_cart/add_bid_model/add_bid_model.dart';

@lazySingleton
class ActionCartRepository extends BaseRepository {
  final ActionCartDataSource _dataSource;

  ActionCartRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<AnonymousType_97C14FD8>?> postActionCartAddProductCatalog(
      ProductCatalogCart model) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/ActionCart/AddProductCatalog",
      cacheKey:
          null, //generateCacheKey("/ActionCart/AddProductCatalog", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postActionCartAddProductCatalog(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_FA6C6C9F>?> postActionCartAddProductDetails(
      ProductDetailsCart model) async {
    return await decorator.execute<ApiResponse<AnonymousType_FA6C6C9F>>(
      operationName: "/ActionCart/AddProductDetails",
      cacheKey: null, //generateCacheKey("/ActionCart/AddProductDetails", [
      //     model
      // ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postActionCartAddProductDetails(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?> postActionCartUpdateItemCart(
      ProductDetailsCart model) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/ActionCart/UpdateItemCart",
      cacheKey: null, //generateCacheKey("/ActionCart/UpdateItemCart", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postActionCartUpdateItemCart(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?> getActionCartGetItemCart(
      String shoppingCartId) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/ActionCart/GetItemCart",
      cacheKey: generateCacheKey("/ActionCart/GetItemCart", [shoppingCartId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getActionCartGetItemCart(shoppingCartId);
      },
    );
  }

  Future<ApiResponse<AnonymousType_01FA76B1>?> postActionCartAddBid(
      AddBidModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_01FA76B1>>(
      operationName: "/ActionCart/AddBid",
      cacheKey: generateCacheKey("/ActionCart/AddBid", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postActionCartAddBid(model);
      },
    );
  }
}
