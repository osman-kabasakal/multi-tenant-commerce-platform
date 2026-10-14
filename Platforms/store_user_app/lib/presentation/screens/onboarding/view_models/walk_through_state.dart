import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_through_state.freezed.dart';

@freezed
class WalkThroughState with _$WalkThroughState {
  const factory WalkThroughState({
    @Default([]) List<Walkthrough> walkthroughs,
    @Default(0) int currentIndex,
  }) = _WalkThroughState;
}

class Walkthrough {
  final String title;
  final String description;
  final String image;

  Walkthrough(
      {required this.title, required this.description, required this.image});
}
