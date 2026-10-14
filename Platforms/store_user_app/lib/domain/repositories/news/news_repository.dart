import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/news/news_data_source.dart';
import '../../entities/models/news/news_item_list_model/news_item_list_model.dart';
import '../../entities/models/news/news_item_model/news_item_model.dart';
import '../../entities/anonymous_type_03_ad2_c00/anonymous_type_03_ad2_c00.dart';
import '../../entities/models/news/news_paging_filtering_model/news_paging_filtering_model.dart';
import '../../entities/models/news/add_news_comment_model/add_news_comment_model.dart';


@lazySingleton
class NewsRepository extends BaseRepository {
  final NewsDataSource _dataSource;

  NewsRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<NewsItemListModel>?> getNewsList(
    NewsPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<NewsItemListModel>>(
      operationName: "/News/List",
      cacheKey: generateCacheKey("/News/List", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getNewsList(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<NewsItemModel>?> getNewsNewsItem(
    String newsItemId) async
     {
    return await decorator.execute<ApiResponse<NewsItemModel>>(
      operationName: "/News/NewsItem",
      cacheKey: generateCacheKey("/News/NewsItem", [
          newsItemId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getNewsNewsItem(
            newsItemId
        );
      },
    );
  }
  
  Future<ApiResponse<AnonymousType_03AD2C00>?> postNewsNewsCommentAdd(
    AddNewsCommentModel model) async
     {
    return await decorator.execute<ApiResponse<AnonymousType_03AD2C00>>(
      operationName: "/News/NewsCommentAdd",
      cacheKey: generateCacheKey("/News/NewsCommentAdd", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postNewsNewsCommentAdd(
            model
        );
      },
    );
  }
  
}