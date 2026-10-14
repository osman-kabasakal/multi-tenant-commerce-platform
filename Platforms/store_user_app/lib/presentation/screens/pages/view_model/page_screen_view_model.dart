import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_screen_view_model.freezed.dart';

@freezed
class PageScreenViewModel with _$PageScreenViewModel{
  const factory PageScreenViewModel({
     String? pageId,
     String? pageTitle,
     String? pageContent,
     DateTime? lastUpdated,
     @Default(false) bool isLoading,
  }) = _PageScreenViewModel;
}