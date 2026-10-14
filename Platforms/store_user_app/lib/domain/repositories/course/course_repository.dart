import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/course/course_data_source.dart';
import '../../entities/models/course/course_model/course_model.dart';
import '../../entities/models/course/lesson_model/lesson_model.dart';
import '../../entities/anonymous_type_3037_ab66/anonymous_type_3037_ab66.dart';

@lazySingleton
class CourseRepository extends BaseRepository {
  final CourseDataSource _dataSource;

  CourseRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<CourseModel>?> getCourseDetails(String courseId) async {
    return await decorator.execute<ApiResponse<CourseModel>>(
      operationName: "/Course/Details",
      cacheKey: generateCacheKey("/Course/Details", [courseId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCourseDetails(courseId);
      },
    );
  }

  Future<ApiResponse<LessonModel>?> getCourseLesson(String id) async {
    return await decorator.execute<ApiResponse<LessonModel>>(
      operationName: "/Course/Lesson",
      cacheKey: generateCacheKey("/Course/Lesson", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCourseLesson(id);
      },
    );
  }

  Future<dynamic> getCourseDownloadFile(String id) async {
    return await decorator.execute<dynamic>(
      operationName: "/Course/DownloadFile",
      cacheKey: generateCacheKey("/Course/DownloadFile", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCourseDownloadFile(id);
      },
    );
  }

  Future<dynamic> getCourseVideoFile(String id) async {
    return await decorator.execute<dynamic>(
      operationName: "/Course/VideoFile",
      cacheKey: generateCacheKey("/Course/VideoFile", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCourseVideoFile(id);
      },
    );
  }

  Future<ApiResponse<AnonymousType_3037AB66>?> getCourseApproved(
      String id) async {
    return await decorator.execute<ApiResponse<AnonymousType_3037AB66>>(
      operationName: "/Course/Approved",
      cacheKey: generateCacheKey("/Course/Approved", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCourseApproved(id);
      },
    );
  }
}
