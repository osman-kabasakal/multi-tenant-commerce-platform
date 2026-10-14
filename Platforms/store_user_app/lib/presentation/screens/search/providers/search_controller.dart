import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/presentation/screens/search/view_models/search_screen_view_model.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  final String searchHistoryBoxName = 'searchHistory';
  @override
  FutureOr<SearchScreenViewModel> build() async {
    if (!Hive.isBoxOpen(searchHistoryBoxName)) {
      await Hive.openBox<String>(searchHistoryBoxName);
    }

    ref.onDispose(() {
      Hive.box<String>(searchHistoryBoxName).close();
    });

    return SearchScreenViewModel();
  }

  Future<void> loadSearchHistory() async {
    if (state.isLoading) return;
    state = AsyncValue.data(SearchScreenViewModel(
        isLoading: false,
        searchHistory: Hive.box<String>(searchHistoryBoxName).values.toList()));
  }

  Future<void> addSearchHistory(String search) async {
    var savedSeraches =
        Hive.box<String>(searchHistoryBoxName).values.toList().reversed;
    if (savedSeraches.contains(search)) {
      return;
    }
    if (Hive.box<String>(searchHistoryBoxName).keys.length > 4) {
      await Hive.box<String>(searchHistoryBoxName).deleteAt(0);
    }
    await Hive.box<String>(searchHistoryBoxName).add(search);
    loadSearchHistory();
  }

  Future<void> clearAllHistory() async {
    await Hive.box<String>(searchHistoryBoxName).deleteFromDisk();
    await Hive.openBox<String>(searchHistoryBoxName);
    await loadSearchHistory();
  }

  Future<void> search(String search) async {
    await addSearchHistory(search);
    getIt<AppRouter>().push(SearchResultRoute(searchQuery: search));
  }
}
