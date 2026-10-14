import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';


import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/pages/page_model/page_model.dart';
import '../../entities/anonymous_type_10783450/anonymous_type_10783450.dart';
import '../../entities/models/pages/authenticate_model/authenticate_model.dart';

part 'page_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class PageDataSource {
  @factoryMethod
  factory PageDataSource(Dio dio) {
    return _PageDataSource(dio);
  }
  
  @GET('/Page/PageDetails')
  @Extra({'responseType': ApiResponse<PageModel>()})
  Future<ApiResponse<PageModel>> getPagePageDetails(
      @Query('pageId') String pageId);
  
  @GET('/Page/PageDetailsPopup')
  @Extra({'responseType': ApiResponse<PageModel>()})
  Future<ApiResponse<PageModel>> getPagePageDetailsPopup(
      @Query('systemName') String systemName);
  
  @POST('/Page/Authenticate')
  @Extra({'responseType': ApiResponse<AnonymousType_10783450>()})
  Future<ApiResponse<AnonymousType_10783450>> postPageAuthenticate(
      @Body() AuthenticateModel model);
  
}