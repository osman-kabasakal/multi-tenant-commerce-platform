import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_view_model.freezed.dart';

@freezed
class HomeViewModel with _$HomeViewModel {
  const factory HomeViewModel({
    @Default(true) bool isLoading,
    @Default(false) bool hasMessages,
  }) = _HomeViewModel;
}
