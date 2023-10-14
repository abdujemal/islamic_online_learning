// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/download_list_state.dart';

class DownloadListNotifier extends StateNotifier<DownloadListState> {
  MainRepo mainRepo;
  DownloadListNotifier(
    this.mainRepo,
  ) : super(const DownloadListState.initial());

  getCourses() async {
    state = const DownloadListState.loading();

    final res = await mainRepo.getDownloadedCourses();

    res.fold(
      (l) {
        state = DownloadListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = DownloadListState.empty(courses: r);
        } else {
          state = DownloadListState.loaded(courses: r);
        }
      },
    );
  }
}
