import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_details_model.dart';

part 'order_detail_view_model.freezed.dart';

@freezed
class OrderDetailViewModel with _$OrderDetailViewModel {
  const factory OrderDetailViewModel({
    @Default(true) bool isLoading,
    OrderDetailsModel? orderDetailsModel,
  }) = _OrderDetailViewModel;
}
