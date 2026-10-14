import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/vendors/apply_vendor_model/apply_vendor_model.dart';
import '../../entities/models/vendors/contact_vendor_model/contact_vendor_model.dart';

part 'vendor_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class VendorDataSource {
  @factoryMethod
  factory VendorDataSource(Dio dio) {
    return _VendorDataSource(dio);
  }

  @GET('/Vendor/ApplyVendor')
  @Extra({'responseType': ApiResponse<ApplyVendorModel>()})
  Future<ApiResponse<ApplyVendorModel>> getVendorApplyVendor();

  @POST('/Vendor/ApplyVendor')
  @Extra({'responseType': ApiResponse<ApplyVendorModel>()})
  Future<ApiResponse<ApplyVendorModel>> postVendorApplyVendor(
    @Body() ApplyVendorModel model,
  );

  @POST('/Vendor/ContactVendor')
  @Extra({'responseType': ApiResponse<ContactVendorModel>(), 'csrf': true})
  Future<ApiResponse<ContactVendorModel>> postVendorContactVendor(
    @Body() ContactVendorModel model,
  );
}
