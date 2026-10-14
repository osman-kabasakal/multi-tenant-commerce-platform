import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/contact/contact_data_source.dart';
import '../../entities/models/contact/contact_us_model/contact_us_model.dart';
import '../../entities/anonymous_type_84_f04_ecc/anonymous_type_84_f04_ecc.dart';
import '../../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../../entities/models/contact/contact_attribute_change_model/contact_attribute_change_model.dart';


@lazySingleton
class ContactRepository extends BaseRepository {
  final ContactDataSource _dataSource;

  ContactRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<ContactUsModel>?> getContactIndex() async
     {
    return await decorator.execute<ApiResponse<ContactUsModel>>(
      operationName: "/Contact/Index",
      cacheKey: generateCacheKey("/Contact/Index", [
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getContactIndex(
        );
      },
    );
  }
  
  Future<ApiResponse<ContactUsModel>?> postContactIndex(
    ContactUsModel model) async
     {
    return await decorator.execute<ApiResponse<ContactUsModel>>(
      operationName: "/Contact/Index",
      cacheKey: generateCacheKey("/Contact/Index", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postContactIndex(
            model
        );
      },
    );
  }
  
  Future<ApiResponse<AnonymousType_84F04ECC>?> postContactContactAttributeChange(
    ContactAttributeChangeModel model) async
     {
    return await decorator.execute<ApiResponse<AnonymousType_84F04ECC>>(
      operationName: "/Contact/ContactAttributeChange",
      cacheKey: generateCacheKey("/Contact/ContactAttributeChange", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postContactContactAttributeChange(
            model
        );
      },
    );
  }
  
  Future<ApiResponse<AnonymousType_5F706788>?> postContactUploadFileContactAttribute(
    String attributeId) async
     {
    return await decorator.execute<ApiResponse<AnonymousType_5F706788>>(
      operationName: "/Contact/UploadFileContactAttribute",
      cacheKey: generateCacheKey("/Contact/UploadFileContactAttribute", [
          attributeId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postContactUploadFileContactAttribute(
            attributeId
        );
      },
    );
  }
  
}