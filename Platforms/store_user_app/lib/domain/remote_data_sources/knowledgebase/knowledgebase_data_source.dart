import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/knowledgebase/knowledgebase_home_page_model/knowledgebase_home_page_model.dart';
import '../../entities/models/knowledgebase/knowledgebase_article_model/knowledgebase_article_model.dart';

part 'knowledgebase_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class KnowledgebaseDataSource {
  @factoryMethod
  factory KnowledgebaseDataSource(Dio dio) {
    return _KnowledgebaseDataSource(dio);
  }

  @GET('/Knowledgebase/List')
  @Extra({'responseType': ApiResponse<KnowledgebaseHomePageModel>()})
  Future<ApiResponse<KnowledgebaseHomePageModel>> getKnowledgebaseList();

  @GET('/Knowledgebase/ArticlesByCategory')
  @Extra({'responseType': ApiResponse<KnowledgebaseHomePageModel>()})
  Future<ApiResponse<KnowledgebaseHomePageModel>>
  getKnowledgebaseArticlesByCategory(@Query('categoryId') String categoryId);

  @GET('/Knowledgebase/ItemsByKeyword')
  @Extra({'responseType': ApiResponse<KnowledgebaseHomePageModel>()})
  Future<ApiResponse<KnowledgebaseHomePageModel>>
  getKnowledgebaseItemsByKeyword(@Query('keyword') String keyword);

  @GET('/Knowledgebase/KnowledgebaseArticle')
  @Extra({'responseType': ApiResponse<KnowledgebaseArticleModel>()})
  Future<ApiResponse<KnowledgebaseArticleModel>>
  getKnowledgebaseKnowledgebaseArticle(@Query('articleId') String articleId);

  @POST('/Knowledgebase/ArticleCommentAdd')
  @Extra({
    'responseType': ApiResponse<KnowledgebaseArticleModel>(),
    'csrf': true,
  })
  Future<ApiResponse<KnowledgebaseArticleModel>>
  postKnowledgebaseArticleCommentAdd(@Body() KnowledgebaseArticleModel model);
}
