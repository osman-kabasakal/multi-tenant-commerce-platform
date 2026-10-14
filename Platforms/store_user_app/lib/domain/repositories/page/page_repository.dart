import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/page/page_data_source.dart';
import '../../entities/models/pages/page_model/page_model.dart';
import '../../entities/anonymous_type_10783450/anonymous_type_10783450.dart';
import '../../entities/models/pages/authenticate_model/authenticate_model.dart';


@lazySingleton
class PageRepository extends BaseRepository {
  final PageDataSource _dataSource;

  PageRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<PageModel>?> getPagePageDetails(
    String pageId) async
     {
    return await decorator.execute<ApiResponse<PageModel>>(
      operationName: "/Page/PageDetails",
      cacheKey: generateCacheKey("/Page/PageDetails", [
          pageId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getPagePageDetails(
            pageId
        );
      },
    );
  }
  
  Future<ApiResponse<PageModel>?> getPagePageDetailsPopup(
    String systemName) async
     {
    return await decorator.execute<ApiResponse<PageModel>>(
      operationName: "/Page/PageDetailsPopup",
      cacheKey: generateCacheKey("/Page/PageDetailsPopup", [
          systemName
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getPagePageDetailsPopup(
            systemName
        );
      },
    );
  }
  
  Future<ApiResponse<AnonymousType_10783450>?> postPageAuthenticate(
    AuthenticateModel model) async
     {
    return await decorator.execute<ApiResponse<AnonymousType_10783450>>(
      operationName: "/Page/Authenticate",
      cacheKey: generateCacheKey("/Page/Authenticate", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postPageAuthenticate(
            model
        );
      },
    );
  }
  
}