import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/beginner_list_state.dart';

class BeginnerListNotifier extends StateNotifier<BeginnerListState> {
  MainRepo mainRepo;
  BeginnerListNotifier(this.mainRepo) : super(BeginnerListState());

  getCourses() async {
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.getBeginnerCourses();

    res.fold(
      (l) {
        // state = BeginnerListState.error(error: l);
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        if (r.isEmpty) {
          state = state.copyWith(isLoading: false, courses: r);
        } else {
          state = state.copyWith(isLoading: false, courses: r);
        }
      },
    );
  }
}
