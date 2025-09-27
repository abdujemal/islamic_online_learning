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
  ) : super(MainListState());

  List<CourseModel> courses = [];
  List<CourseModel> filteredCourses = [];

  int itreationCounter = 0;

  Future<void> getCourses({
    bool isNew = true,
    String? key,
    String? val,
    SortingMethod method = SortingMethod.dateDSC,
    required BuildContext context,
  }) async {
    final bool isKeyNull = key == null;
    if (itreationCounter == 0) {
      if (isNew) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          courses: isKeyNull ? courses : filteredCourses,
          noMoreToLoad: false,
          isLoadingMore: true,
        );
      }
      itreationCounter = 1;
      final res = await mainRepo.getCourses(isNew, key, val, method);
      itreationCounter = 0;
      // print(itreationCounter);

      res.fold((l) {
        // if (l.toString().contains("DatabaseException")) {
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (c) => const DownloadDatabase()),
        //     (route) => false,
        //   );
        //   return;
        // }
        state = state.copyWith(isLoading: false, error: l.messege);
      }, (r) {
        if (isNew && r.isEmpty) {
          isKeyNull ? courses = r : filteredCourses = r;
          state = state.copyWith(
            isLoading: false,
            courses: isKeyNull ? courses : filteredCourses,
          );

          return;
        } else if (isNew) {
          if (isKeyNull) {
            print("isKeyNull");
            courses = r;
          } else {
            print("!isKeyNull");

            filteredCourses = r;
          }
          state = state.copyWith(
            isLoading: false,
            courses: isKeyNull ? courses : filteredCourses,
            noMoreToLoad: false,
            isLoadingMore: false,
          );
        } else {
          if (kDebugMode) {
            print(r.length);
          }
          if (isKeyNull) {
            courses = [
              ...courses,
              ...r,
            ];
          } else {
            filteredCourses = [
              ...filteredCourses,
              ...r,
            ];
          }
          state = state.copyWith(
            isLoading: false,
            courses: isKeyNull ? courses : filteredCourses,
            noMoreToLoad: r.isEmpty,
            isLoadingMore: false,
          );
        }
      });
    }
  }

  // Future<void> updateCourse(CourseModel courseModel) async {
  //   courses =
  //       courses.map((e) => e.id == courseModel.id ? courseModel : e).toList();
  //   state = MainListState.loaded(
  //     courses: courses,
  //     noMoreToLoad: false,
  //     isLoadingMore: true,
  //   );
  // }

  Future<CourseModel?> getSingleCourse(
    String courseId,
    BuildContext context, {
    bool fromCloud = false,
  }) async {
    CourseModel? courseModel;
    final res = await mainRepo.getSingleCourse(
      courseId,
      fromCloud,
    );

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
    state = state.copyWith(isLoading: true);

    final res = await mainRepo.searchCourses(qwery, noOfElt);

    res.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.messege);
      },
      (r) {
        if (r.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            courses: r,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            courses: r,
            isLoadingMore: false,
            noMoreToLoad: false,
          );
        }
      },
    );
  }

  updateCourses({String? keey, String? val}) async {
    print('keey: $keey');
    print('val: $val');
    List<CourseModel> savedCourses =
        await ref.read(mainDataSrcProvider).getSavedCourses();

    List<CourseModel> newList = [];

    // List<CourseModel> fcourses = [];
    // if (keey != null && val != null) {
    //   fcourses = courses.where((e) {
    //     final c = e.toMap();
    //     return c[keey] == val;
    //   }).toList();
    //   print("fcourses len ${fcourses.length}");
    // }

    for (CourseModel cm in keey == null ? courses : filteredCourses) {
      final matchings =
          savedCourses.where((e) => e.ustaz == cm.ustaz && e.title == cm.title);
      print(" matchings ${matchings.length}");
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
        newList.add(cm);
      }
    }
    if (keey == null) {
      filteredCourses = newList;
    } else {
      courses = newList;
    }
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      courses: newList,
      isLoadingMore: true,
      noMoreToLoad: false,
    );
  }

  Future<int?> saveCourse(
      CourseModel courseModel, int? isFav, BuildContext context,
      {bool showMsg = true, String? keey, String? val}) async {
    final res = await mainRepo.saveCourse(
      courseModel.copyWith(
        isFav: isFav,
      ),
    );

    int? id;

    res.fold(
      (l) {
        toast(l.messege, ToastType.error, context);
        if (kDebugMode) {
          print(l.messege);
        }
        id = null;
      },
      (r) {
        if (showMsg) {
          toast("በተሳካ ሁኔታ ተመዝግብዋል", ToastType.success, context);
        }
        updateCourses(keey: keey, val: val);
        ref.read(favNotifierProvider.notifier).getCourse();
        ref.read(startedNotifierProvider.notifier).getCouses();
        print("real id : $r");
        id = r;
      },
    );

    return id;
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
