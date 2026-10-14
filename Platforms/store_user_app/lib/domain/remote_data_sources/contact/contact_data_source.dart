import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/contact/contact_us_model/contact_us_model.dart';
import '../../entities/anonymous_type_84_f04_ecc/anonymous_type_84_f04_ecc.dart';
import '../../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../../entities/models/contact/contact_attribute_change_model/contact_attribute_change_model.dart';

part 'contact_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ContactDataSource {
  @factoryMethod
  factory ContactDataSource(Dio dio) {
    return _ContactDataSource(dio);
  }

  @GET('/Contact/Index')
  @Extra({'responseType': ApiResponse<ContactUsModel>()})
  Future<ApiResponse<ContactUsModel>> getContactIndex();

  @POST('/Contact/Index')
  @Extra({'responseType': ApiResponse<ContactUsModel>(), 'csrf': true})
  Future<ApiResponse<ContactUsModel>> postContactIndex(
    @Body() ContactUsModel model,
  );

  @POST('/Contact/ContactAttributeChange')
  @Extra({'responseType': ApiResponse<AnonymousType_84F04ECC>()})
  Future<ApiResponse<AnonymousType_84F04ECC>> postContactContactAttributeChange(
    @Body() ContactAttributeChangeModel model,
  );

  @POST('/Contact/UploadFileContactAttribute')
  @Extra({'responseType': ApiResponse<AnonymousType_5F706788>()})
  Future<ApiResponse<AnonymousType_5F706788>>
  postContactUploadFileContactAttribute(
    @Query('attributeId') String attributeId,
  );
}
