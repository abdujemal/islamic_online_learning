import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_state.dart';

class MainListNotifier extends StateNotifier<MainListState> {
  final MainRepo mainRepo;
  MainListNotifier(
    this.mainRepo,
  ) : super(const MainListState.initial());

  List<CourseModel> courses = [];

  Future<void> getCourses(int page, bool isNew) async {
    state = const MainListState.loading();

    final res = await mainRepo.getCourses(page);
    res.fold((l) {
      state = MainListState.error(error: l);
    }, (r) {
      if (isNew) {
        courses = r;
        state = MainListState.loaded(courses: courses);
      } else {
        courses = [...r, ...courses];
        state = MainListState.loaded(courses: courses);
      }
    });
  }
}
