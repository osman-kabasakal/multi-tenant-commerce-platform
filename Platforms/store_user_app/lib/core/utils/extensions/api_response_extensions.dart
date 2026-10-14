import 'package:store_user_app/core/models/network/api_response.dart';

extension ApiResponseExtensions on ApiResponse? {
  bool get success => this?.data != null;
}
