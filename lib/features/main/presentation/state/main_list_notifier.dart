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

  int itreationCounter = 0;

  Future<void> getCourses({bool isNew = true, String? key, String? val}) async {
    if (itreationCounter == 0) {
      if (isNew) {
        state = const MainListState.loading();
      } else {
        state = MainListState.loaded(
          courses: courses,
          noMoreToLoad: false,
          isLoadingMore: true,
        );
      }
      itreationCounter = 1;
      final res = await mainRepo.getCourses(isNew, key, val);
      itreationCounter = 0;
      // print(itreationCounter);

      res.fold((l) {
        state = MainListState.error(error: l);
      }, (r) {
        if (isNew && r.isEmpty) {
          state = MainListState.empty(courses: r);
          return;
        } else if (isNew) {
          courses = r;
          state = MainListState.loaded(
            courses: courses,
            noMoreToLoad: false,
            isLoadingMore: false,
          );
        } else {
          print(r.length);
          courses = [...r, ...courses];
          courses.sort((a, b) => b.courseId.compareTo(a.courseId));
          state = MainListState.loaded(
            courses: courses,
            noMoreToLoad: r.isEmpty,
            isLoadingMore: false,
          );
        }
      });
    }
  }

  searchCourses(String qwery) {}
}
