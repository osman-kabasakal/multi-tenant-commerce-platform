import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/blog/blog_data_source.dart';
import '../../entities/models/blogs/blog_post_list_model/blog_post_list_model.dart';
import '../../entities/models/blogs/blog_post_model/blog_post_model.dart';
import '../../entities/models/blogs/blog_paging_filtering_model/blog_paging_filtering_model.dart';
import '../../entities/models/blogs/add_blog_comment_model/add_blog_comment_model.dart';


@lazySingleton
class BlogRepository extends BaseRepository {
  final BlogDataSource _dataSource;

  BlogRepository(this._dataSource, super.decorator, super.eventBus);

  
  Future<ApiResponse<BlogPostListModel>?> getBlogList(
    BlogPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<BlogPostListModel>>(
      operationName: "/Blog/List",
      cacheKey: generateCacheKey("/Blog/List", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogList(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostListModel>?> getBlogBlogByTag(
    BlogPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<BlogPostListModel>>(
      operationName: "/Blog/BlogByTag",
      cacheKey: generateCacheKey("/Blog/BlogByTag", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogBlogByTag(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostListModel>?> getBlogBlogByMonth(
    BlogPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<BlogPostListModel>>(
      operationName: "/Blog/BlogByMonth",
      cacheKey: generateCacheKey("/Blog/BlogByMonth", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogBlogByMonth(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostListModel>?> getBlogBlogByCategory(
    BlogPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<BlogPostListModel>>(
      operationName: "/Blog/BlogByCategory",
      cacheKey: generateCacheKey("/Blog/BlogByCategory", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogBlogByCategory(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostListModel>?> getBlogBlogByKeyword(
    BlogPagingFilteringModel command) async
     {
    return await decorator.execute<ApiResponse<BlogPostListModel>>(
      operationName: "/Blog/BlogByKeyword",
      cacheKey: generateCacheKey("/Blog/BlogByKeyword", [
          command
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogBlogByKeyword(
            command
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostModel>?> getBlogBlogPost(
    String blogPostId) async
     {
    return await decorator.execute<ApiResponse<BlogPostModel>>(
      operationName: "/Blog/BlogPost",
      cacheKey: generateCacheKey("/Blog/BlogPost", [
          blogPostId
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getBlogBlogPost(
            blogPostId
        );
      },
    );
  }
  
  Future<ApiResponse<BlogPostModel>?> postBlogBlogPost(
    AddBlogCommentModel model) async
     {
    return await decorator.execute<ApiResponse<BlogPostModel>>(
      operationName: "/Blog/BlogPost",
      cacheKey: generateCacheKey("/Blog/BlogPost", [
          model
      ]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postBlogBlogPost(
            model
        );
      },
    );
  }
  
}