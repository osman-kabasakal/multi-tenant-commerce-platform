import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_screen_view_model.freezed.dart';

@freezed
class SearchScreenViewModel with _$SearchScreenViewModel {
  const factory SearchScreenViewModel({
    @Default(true) bool isLoading,
    @Default([]) List<String> searchHistory,
  }) = _SearchScreenViewModel;
}
