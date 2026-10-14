import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/vendor/vendor_data_source.dart';
import '../../entities/models/vendors/apply_vendor_model/apply_vendor_model.dart';
import '../../entities/models/vendors/contact_vendor_model/contact_vendor_model.dart';


@lazySingleton
class VendorRepository extends BaseRepository {
  final VendorDataSource _dataSource;

  VendorRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<ApplyVendorModel>?> getVendorApplyVendor() async
     {
    return await decorator.execute<ApiResponse<ApplyVendorModel>>(
      operationName: "/Vendor/ApplyVendor",
      cacheKey: generateCacheKey("/Vendor/ApplyVendor", [
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getVendorApplyVendor(
        );
      },
    );
  }
  
  Future<ApiResponse<ApplyVendorModel>?> postVendorApplyVendor(
    ApplyVendorModel model) async
     {
    return await decorator.execute<ApiResponse<ApplyVendorModel>>(
      operationName: "/Vendor/ApplyVendor",
      cacheKey: generateCacheKey("/Vendor/ApplyVendor", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postVendorApplyVendor(
            model
        );
      },
    );
  }
  
  Future<ApiResponse<ContactVendorModel>?> postVendorContactVendor(
    ContactVendorModel model) async
     {
    return await decorator.execute<ApiResponse<ContactVendorModel>>(
      operationName: "/Vendor/ContactVendor",
      cacheKey: generateCacheKey("/Vendor/ContactVendor", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postVendorContactVendor(
            model
        );
      },
    );
  }
  
}