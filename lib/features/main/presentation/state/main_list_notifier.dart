import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class MainListNotifier extends StateNotifier<MainListState> {
  final MainRepo mainRepo;
  final Ref ref;
  MainListNotifier(
    this.mainRepo,
    this.ref,
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

  searchCourses(String qwery, int? noOfElt) async {
    state = const MainListState.loading();

    final res = await mainRepo.searchCourses(qwery, noOfElt);

    res.fold(
      (l) {
        state = MainListState.error(error: l);
      },
      (r) {
        if (r.isEmpty) {
          state = MainListState.empty(courses: r);
        } else {
          state = MainListState.loaded(
            courses: r,
            isLoadingMore: false,
            noMoreToLoad: false,
          );
        }
      },
    );
  }

  Future<int?> saveCourse(CourseModel courseModel, bool isFav) async {
    final res = await mainRepo.saveCourse(courseModel.copyWith(isFav: isFav));

    res.fold(
      (l) {
        toast(l.messege, ToastType.error);
      },
      (r) {
        toast("በተሳካ ሁኔታ ተመዝግብዋል", ToastType.error);
        return r;
      },
    );
    return null;
  }

  changeTheme(ThemeMode theme) async {
    final pref = await ref.read(sharedPrefProvider);

    pref.setString("theme", theme == ThemeMode.dark ? 'dark' : 'light');

    getTheme();
  }

  getTheme() async {
    final pref = await ref.read(sharedPrefProvider);

    String currentTheme = pref.getString('theme') ?? 'light';

    ref.read(themeProvider.notifier).update(
        (state) => currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light);
  }
}
