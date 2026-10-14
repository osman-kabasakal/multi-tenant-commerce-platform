import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_info_model/customer_info_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_navigation_model/customer_navigation_model.dart';

part 'profile_view_model.freezed.dart';

@freezed
class ProfileViewModel with _$ProfileViewModel {
  const factory ProfileViewModel({
    @Default(null) String? error,
    required CustomerNavigationModel customerNavigation,
    required CustomerInfoModel customerInfo,
  }) = _ProfileViewModel;
}
