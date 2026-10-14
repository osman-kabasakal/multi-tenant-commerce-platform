import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/newsletter/newsletter_data_source.dart';
import '../../entities/anonymous_type_2_f40_fb16/anonymous_type_2_f40_fb16.dart';
import '../../entities/anonymous_type__d4_a20723/anonymous_type__d4_a20723.dart';
import '../../entities/models/newsletter/newsletter_category_model/newsletter_category_model.dart';

@lazySingleton
class NewsletterRepository extends BaseRepository {
  final NewsletterDataSource _dataSource;

  NewsletterRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<AnonymousType_2F40FB16>?>
      postNewsletterSubscribeNewsletter(String email, bool subscribe) async {
    return await decorator.execute<ApiResponse<AnonymousType_2F40FB16>>(
      operationName: "/Newsletter/SubscribeNewsletter",
      cacheKey: generateCacheKey(
          "/Newsletter/SubscribeNewsletter", [email, subscribe]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postNewsletterSubscribeNewsletter(
            email, subscribe);
      },
    );
  }

  Future<ApiResponse<AnonymousType_D4A20723>?> postNewsletterSaveCategories(
      NewsletterCategoryModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_D4A20723>>(
      operationName: "/Newsletter/SaveCategories",
      cacheKey: generateCacheKey("/Newsletter/SaveCategories", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postNewsletterSaveCategories(model);
      },
    );
  }

  Future<dynamic> getNewsletterSubscriptionActivation(
      String token, bool active) async {
    return await decorator.execute<dynamic>(
      operationName: "/Newsletter/SubscriptionActivation",
      cacheKey: generateCacheKey(
          "/Newsletter/SubscriptionActivation", [token, active]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getNewsletterSubscriptionActivation(
            token, active);
      },
    );
  }
}
