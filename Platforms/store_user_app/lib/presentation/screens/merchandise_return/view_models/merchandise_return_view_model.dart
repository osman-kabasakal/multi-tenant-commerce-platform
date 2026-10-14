import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/order_item_model/order_item_model.dart';

part 'merchandise_return_view_model.freezed.dart';

@freezed
class MerchandiseReturnViewModel with _$MerchandiseReturnViewModel {
  const factory MerchandiseReturnViewModel({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(null) String? error,
    @Default(null) String? result,
    required MerchandiseReturnModel merchandiseReturnModel,
    @Default([]) List<OrderItemModel> returnItems,
    @Default(0) int totalSteps,
    @Default(0) int currentStep,
  }) = _MerchandiseReturnViewModel;
}
