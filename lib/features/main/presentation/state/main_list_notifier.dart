import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_state.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../../data/main_data_src.dart';

class MainListNotifier extends StateNotifier<MainListState> {
  final MainRepo mainRepo;
  final Ref ref;
  MainListNotifier(
    this.mainRepo,
    this.ref,
  ) : super(const MainListState.initial());

  List<CourseModel> courses = [];

  int itreationCounter = 0;

  Future<void> getCourses({
    bool isNew = true,
    String? key,
    String? val,
    SortingMethod method = SortingMethod.dateDSC,
  }) async {
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
      final res = await mainRepo.getCourses(isNew, key, val, method);
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
          if (kDebugMode) {
            print(r.length);
          }
          courses = [
            ...courses,
            ...r,
          ];
          state = MainListState.loaded(
            courses: courses,
            noMoreToLoad: r.isEmpty,
            isLoadingMore: false,
          );
        }
      });
    }
  }

  Future<void> updateCourse(CourseModel courseModel) async {
    courses =
        courses.map((e) => e.id == courseModel.id ? courseModel : e).toList();
    state = MainListState.loaded(
      courses: courses,
      noMoreToLoad: false,
      isLoadingMore: true,
    );
  }

  Future<CourseModel?> getSingleCourse(
      String courseId, BuildContext context) async {
    CourseModel? courseModel;
    final res = await mainRepo.getSingleCourse(courseId);

    res.fold(
      (l) {
        toast(l.messege, ToastType.error, context);
      },
      (r) {
        courseModel = r;
      },
    );
    return courseModel;
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

  updateCourses() async {
    List<CourseModel> savedCourses =
        await ref.read(mainDataSrcProvider).getSavedCourses();

    List<CourseModel> newList = [];

    for (CourseModel cm in courses) {
      final matchings = savedCourses.where((e) => e.courseId == cm.courseId);
      if (matchings.isNotEmpty) {
        CourseModel savedCourse = matchings.first;
        newList.add(
          CourseModel.fromMap(
            cm.toOriginalMap(),
            cm.courseId,
            copyFrom: savedCourse,
          ),
        );
      } else {
        newList.add(
          CourseModel.fromMap(
            cm.toOriginalMap(),
            cm.courseId,
          ),
        );
      }
    }

    courses = newList;
    await Future.delayed(const Duration(seconds: 1));
    state = MainListState.loaded(
      courses: newList,
      isLoadingMore: false,
      noMoreToLoad: false,
    );
  }

  Future<int?> saveCourse(
      CourseModel courseModel, int? isFav, BuildContext context,
      {bool showMsg = true}) async {
    final res = await mainRepo.saveCourse(
      courseModel.copyWith(
        isFav: isFav,
      ),
    );

    res.fold(
      (l) {
        toast(l.messege, ToastType.error, context);
        if (kDebugMode) {
          print(l.messege);
        }
      },
      (r) {
        if (showMsg) {
          toast("በተሳካ ሁኔታ ተመዝግብዋል", ToastType.success, context);
        }
        updateCourses();
        ref.read(favNotifierProvider.notifier).getCourse();
        ref.read(startedNotifierProvider.notifier).getCouses();

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
