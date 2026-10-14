import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class HomeDataSource {
  @factoryMethod
  factory HomeDataSource(Dio dio) {
    return _HomeDataSource(dio);
  }
}
