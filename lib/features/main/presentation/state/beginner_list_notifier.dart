import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/beginner_list_state.dart';

class BeginnerListNotifier extends StateNotifier<BeginnerListState> {
  MainRepo mainRepo;
  BeginnerListNotifier(this.mainRepo)
      : super(const BeginnerListState.initial());

  getCourses() async {
    state = const BeginnerListState.loading();

    final res = await mainRepo.getBeginnerCourses();

    res.fold(
      (l) {
        state = BeginnerListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = BeginnerListState.empty(courses: r);
        } else {
          state = BeginnerListState.loaded(courses: r);
        }
      },
    );
  }
}
