import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/knowledgebase/knowledgebase_data_source.dart';
import '../../entities/models/knowledgebase/knowledgebase_home_page_model/knowledgebase_home_page_model.dart';
import '../../entities/models/knowledgebase/knowledgebase_article_model/knowledgebase_article_model.dart';


@lazySingleton
class KnowledgebaseRepository extends BaseRepository {
  final KnowledgebaseDataSource _dataSource;

  KnowledgebaseRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<KnowledgebaseHomePageModel>?> getKnowledgebaseList() async
     {
    return await decorator.execute<ApiResponse<KnowledgebaseHomePageModel>>(
      operationName: "/Knowledgebase/List",
      cacheKey: generateCacheKey("/Knowledgebase/List", [
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getKnowledgebaseList(
        );
      },
    );
  }
  
  Future<ApiResponse<KnowledgebaseHomePageModel>?> getKnowledgebaseArticlesByCategory(
    String categoryId) async
     {
    return await decorator.execute<ApiResponse<KnowledgebaseHomePageModel>>(
      operationName: "/Knowledgebase/ArticlesByCategory",
      cacheKey: generateCacheKey("/Knowledgebase/ArticlesByCategory", [
          categoryId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getKnowledgebaseArticlesByCategory(
            categoryId
        );
      },
    );
  }
  
  Future<ApiResponse<KnowledgebaseHomePageModel>?> getKnowledgebaseItemsByKeyword(
    String keyword) async
     {
    return await decorator.execute<ApiResponse<KnowledgebaseHomePageModel>>(
      operationName: "/Knowledgebase/ItemsByKeyword",
      cacheKey: generateCacheKey("/Knowledgebase/ItemsByKeyword", [
          keyword
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getKnowledgebaseItemsByKeyword(
            keyword
        );
      },
    );
  }
  
  Future<ApiResponse<KnowledgebaseArticleModel>?> getKnowledgebaseKnowledgebaseArticle(
    String articleId) async
     {
    return await decorator.execute<ApiResponse<KnowledgebaseArticleModel>>(
      operationName: "/Knowledgebase/KnowledgebaseArticle",
      cacheKey: generateCacheKey("/Knowledgebase/KnowledgebaseArticle", [
          articleId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getKnowledgebaseKnowledgebaseArticle(
            articleId
        );
      },
    );
  }
  
  Future<ApiResponse<KnowledgebaseArticleModel>?> postKnowledgebaseArticleCommentAdd(
    KnowledgebaseArticleModel model) async
     {
    return await decorator.execute<ApiResponse<KnowledgebaseArticleModel>>(
      operationName: "/Knowledgebase/ArticleCommentAdd",
      cacheKey: generateCacheKey("/Knowledgebase/ArticleCommentAdd", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postKnowledgebaseArticleCommentAdd(
            model
        );
      },
    );
  }
  
}