import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/orders/customer_merchandise_returns_model/customer_merchandise_returns_model.dart';
import '../../entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import '../../entities/models/orders/merchandise_return_details_model/merchandise_return_details_model.dart';

part 'merchandise_return_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class MerchandiseReturnDataSource {
  @factoryMethod
  factory MerchandiseReturnDataSource(Dio dio) {
    return _MerchandiseReturnDataSource(dio);
  }

  @GET('/merchandisereturn/history')
  @Extra({'responseType': ApiResponse<CustomerMerchandiseReturnsModel>()})
  Future<ApiResponse<CustomerMerchandiseReturnsModel>>
  getMerchandiseReturnCustomerMerchandiseReturns();

  @GET('/merchandisereturn/{orderId}')
  @Extra({'responseType': ApiResponse<MerchandiseReturnModel>()})
  Future<ApiResponse<MerchandiseReturnModel>>
  getMerchandiseReturnMerchandiseReturn(@Path('orderId') String orderId);

  @POST('/MerchandiseReturn/MerchandiseReturn')
  @Extra({'responseType': ApiResponse<MerchandiseReturnModel>(), 'csrf': true})
  Future<ApiResponse<MerchandiseReturnModel>>
  postMerchandiseReturnMerchandiseReturn(@Body() MerchandiseReturnModel model);

  @GET('/merchandisereturndetails/{merchandiseReturnId}')
  @Extra({'responseType': ApiResponse<MerchandiseReturnDetailsModel>()})
  Future<ApiResponse<MerchandiseReturnDetailsModel>>
  getMerchandiseReturnMerchandiseReturnDetails(
    @Path('merchandiseReturnId') String merchandiseReturnId,
  );
}
