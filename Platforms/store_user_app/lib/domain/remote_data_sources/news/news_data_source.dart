import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/news/news_item_list_model/news_item_list_model.dart';
import '../../entities/models/news/news_item_model/news_item_model.dart';
import '../../entities/anonymous_type_03_ad2_c00/anonymous_type_03_ad2_c00.dart';
import '../../entities/models/news/news_paging_filtering_model/news_paging_filtering_model.dart';
import '../../entities/models/news/add_news_comment_model/add_news_comment_model.dart';

part 'news_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class NewsDataSource {
  @factoryMethod
  factory NewsDataSource(Dio dio) {
    return _NewsDataSource(dio);
  }

  @GET('/News/List')
  @Extra({'responseType': ApiResponse<NewsItemListModel>()})
  Future<ApiResponse<NewsItemListModel>> getNewsList(
    @Field('command') NewsPagingFilteringModel command,
  );

  @GET('/News/NewsItem')
  @Extra({'responseType': ApiResponse<NewsItemModel>()})
  Future<ApiResponse<NewsItemModel>> getNewsNewsItem(
    @Query('newsItemId') String newsItemId,
  );

  @POST('/News/NewsCommentAdd')
  @Extra({'responseType': ApiResponse<AnonymousType_03AD2C00>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_03AD2C00>> postNewsNewsCommentAdd(
    @Body() AddNewsCommentModel model,
  );
}
