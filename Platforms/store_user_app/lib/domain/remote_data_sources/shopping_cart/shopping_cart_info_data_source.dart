
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/models/network/api_response.dart';
import '../../entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';

part 'shopping_cart_info_data_source.g.dart';


@RestApi()
@lazySingleton
abstract class ShoppingCartInfoDataSource{
  @factoryMethod
  factory ShoppingCartInfoDataSource(Dio dio) {
    return _ShoppingCartInfoDataSource(dio);
  }

  @GET('/ShoppingCartInfo/info')
  @Extra({'responseType': ApiResponse<ShoppingCartInfoResponse>()})
  Future<ApiResponse<ShoppingCartInfoResponse>>
  getShoppingCartInfo();
}