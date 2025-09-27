// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/started_list_state.dart';

class StartedListNotifier extends StateNotifier<StartedListState> {
  MainRepo mainRepo;
  Ref ref;
  StartedListNotifier(
    this.mainRepo,
    this.ref,
  ) : super(StartedListState());

  Future<void> getCouses() async {
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.getStartedCourses();

    res.fold(
      (l) {
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
