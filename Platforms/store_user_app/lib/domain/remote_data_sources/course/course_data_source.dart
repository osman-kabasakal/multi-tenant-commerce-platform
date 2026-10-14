import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';


import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/course/course_model/course_model.dart';
import '../../entities/models/course/lesson_model/lesson_model.dart';
import '../../entities/anonymous_type_3037_ab66/anonymous_type_3037_ab66.dart';

part 'course_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class CourseDataSource {
  @factoryMethod
  factory CourseDataSource(Dio dio) {
    return _CourseDataSource(dio);
  }
  
  @GET('/Course/Details')
  @Extra({'responseType': ApiResponse<CourseModel>()})
  Future<ApiResponse<CourseModel>> getCourseDetails(
      @Query('courseId') String courseId);
  
  @GET('/Course/Lesson')
  @Extra({'responseType': ApiResponse<LessonModel>()})
  Future<ApiResponse<LessonModel>> getCourseLesson(
      @Query('id') String id);
  
  @GET('/Course/DownloadFile')
  
  Future<dynamic> getCourseDownloadFile(
      @Query('id') String id);
  
  @GET('/Course/VideoFile')
  
  Future<dynamic> getCourseVideoFile(
      @Query('id') String id);
  
  @GET('/Course/Approved')
  @Extra({'responseType': ApiResponse<AnonymousType_3037AB66>()})
  Future<ApiResponse<AnonymousType_3037AB66>> getCourseApproved(
      @Query('id') String id);
  
}