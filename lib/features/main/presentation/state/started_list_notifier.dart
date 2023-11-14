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
  ) : super(const StartedListState.initial());

  getCouses() async {
    state = const StartedListState.loading();

    final res = await mainRepo.getStartedCourses();

    res.fold(
      (l) {
        state = StartedListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = StartedListState.empty(courses: r);
        } else {
          state = StartedListState.loaded(courses: r);
        }
      },
    );
  }
}
