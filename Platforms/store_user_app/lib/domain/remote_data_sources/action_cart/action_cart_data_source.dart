import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../../entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import '../../entities/anonymous_type_01_fa76_b1/anonymous_type_01_fa76_b1.dart';
import '../../entities/models/shopping_cart/product_catalog_cart/product_catalog_cart.dart';
import '../../entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import '../../entities/models/shopping_cart/add_bid_model/add_bid_model.dart';

part 'action_cart_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ActionCartDataSource {
  @factoryMethod
  factory ActionCartDataSource(Dio dio) {
    return _ActionCartDataSource(dio);
  }

  @POST('/ActionCart/AddProductCatalog')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>> postActionCartAddProductCatalog(
      @Body() ProductCatalogCart model);

  @POST('/ActionCart/AddProductDetails')
  @Extra({'responseType': ApiResponse<AnonymousType_FA6C6C9F>()})
  Future<ApiResponse<AnonymousType_FA6C6C9F>> postActionCartAddProductDetails(
      @Body() ProductDetailsCart model);

  @POST('/ActionCart/UpdateItemCart')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>> postActionCartUpdateItemCart(
      @Body() ProductDetailsCart model);

  @GET('/getitemcart/{shoppingCartId}')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>> getActionCartGetItemCart(
      @Path('shoppingCartId') String shoppingCartId);

  @POST('/ActionCart/AddBid')
  @Extra({'responseType': ApiResponse<AnonymousType_01FA76B1>()})
  Future<ApiResponse<AnonymousType_01FA76B1>> postActionCartAddBid(
      @Body() AddBidModel model);
}
