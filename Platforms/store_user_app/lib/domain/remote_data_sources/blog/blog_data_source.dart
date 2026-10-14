import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/blogs/blog_post_list_model/blog_post_list_model.dart';
import '../../entities/models/blogs/blog_post_model/blog_post_model.dart';
import '../../entities/models/blogs/blog_paging_filtering_model/blog_paging_filtering_model.dart';
import '../../entities/models/blogs/add_blog_comment_model/add_blog_comment_model.dart';

part 'blog_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class BlogDataSource {
  @factoryMethod
  factory BlogDataSource(Dio dio) {
    return _BlogDataSource(dio);
  }

  @GET('/Blog/List')
  @Extra({'responseType': ApiResponse<BlogPostListModel>()})
  Future<ApiResponse<BlogPostListModel>> getBlogList(
    @Field('command') BlogPagingFilteringModel command,
  );

  @GET('/Blog/BlogByTag')
  @Extra({'responseType': ApiResponse<BlogPostListModel>()})
  Future<ApiResponse<BlogPostListModel>> getBlogBlogByTag(
    @Field('command') BlogPagingFilteringModel command,
  );

  @GET('/Blog/BlogByMonth')
  @Extra({'responseType': ApiResponse<BlogPostListModel>()})
  Future<ApiResponse<BlogPostListModel>> getBlogBlogByMonth(
    @Field('command') BlogPagingFilteringModel command,
  );

  @GET('/Blog/BlogByCategory')
  @Extra({'responseType': ApiResponse<BlogPostListModel>()})
  Future<ApiResponse<BlogPostListModel>> getBlogBlogByCategory(
    @Field('command') BlogPagingFilteringModel command,
  );

  @GET('/Blog/BlogByKeyword')
  @Extra({'responseType': ApiResponse<BlogPostListModel>()})
  Future<ApiResponse<BlogPostListModel>> getBlogBlogByKeyword(
    @Field('command') BlogPagingFilteringModel command,
  );

  @GET('/Blog/BlogPost')
  @Extra({'responseType': ApiResponse<BlogPostModel>()})
  Future<ApiResponse<BlogPostModel>> getBlogBlogPost(
    @Query('blogPostId') String blogPostId,
  );

  @POST('/Blog/BlogPost')
  @Extra({'responseType': ApiResponse<BlogPostModel>(), 'csrf': true})
  Future<ApiResponse<BlogPostModel>> postBlogBlogPost(
    @Body() AddBlogCommentModel model,
  );
}
