import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/customer/change_password_model/change_password_model.dart';

part 'change_password_view_model.freezed.dart';

@freezed
class ChangePasswordViewModel with _$ChangePasswordViewModel {
  const factory ChangePasswordViewModel({
    ChangePasswordModel? model,
    bool? isLoading,
    bool? success,
    bool? isSubmitted,
    String? message,
    Object? error,
  }) = _ChangePasswordViewModel;
}
