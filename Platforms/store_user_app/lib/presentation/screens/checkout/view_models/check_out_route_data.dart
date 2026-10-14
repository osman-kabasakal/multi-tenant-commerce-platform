import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_out_route_data.freezed.dart';

@freezed
class CheckOutRouteData with _$CheckOutRouteData {
  const factory CheckOutRouteData({
    required bool requireAuthorization,
    required bool checkoutAsGuest,
  }) = _CheckOutRouteData;
}
