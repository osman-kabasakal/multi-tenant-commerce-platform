import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';


import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/anonymous_type_2_f40_fb16/anonymous_type_2_f40_fb16.dart';
import '../../entities/anonymous_type__d4_a20723/anonymous_type__d4_a20723.dart';
import '../../entities/models/newsletter/newsletter_category_model/newsletter_category_model.dart';

part 'newsletter_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class NewsletterDataSource {
  @factoryMethod
  factory NewsletterDataSource(Dio dio) {
    return _NewsletterDataSource(dio);
  }
  
  @POST('/Newsletter/SubscribeNewsletter')
  @Extra({'responseType': ApiResponse<AnonymousType_2F40FB16>()})
  Future<ApiResponse<AnonymousType_2F40FB16>> postNewsletterSubscribeNewsletter(
      @Query('email') String email,
      @Query('subscribe') bool subscribe);
  
  @POST('/Newsletter/SaveCategories')
  @Extra({'responseType': ApiResponse<AnonymousType_D4A20723>()})
  Future<ApiResponse<AnonymousType_D4A20723>> postNewsletterSaveCategories(
      @Body() NewsletterCategoryModel model);
  
  @GET('/Newsletter/SubscriptionActivation')
  
  Future<dynamic> getNewsletterSubscriptionActivation(
      @Query('token') String token,
      @Query('active') bool active);
  
}