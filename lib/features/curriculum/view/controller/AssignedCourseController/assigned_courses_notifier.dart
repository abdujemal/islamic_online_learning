// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/auth_state.dart';
// import 'package:islamic_online_learning/core/constants.dart';

import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_state.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/provider.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/provider.dart';
import 'package:islamic_online_learning/utils.dart';

class AssignedCoursesNotifier extends StateNotifier<AssignedCoursesState> {
  final CurriculumService service;
  final Ref ref;
  AssignedCoursesNotifier(this.service, this.ref)
      : super(AssignedCoursesState());

  Future<void> getCurriculum(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      ref
          .read(authNotifierProvider.notifier)
          .setCourseStarted(CourseStarted.LOADING);
      final curriculumNGroup = await service.fetchCurriculum();
      final curriculum = curriculumNGroup.curriculum;
      final scores = curriculumNGroup.scores;
      final testAttempts = curriculumNGroup.testAttempts;
      final discussions = curriculumNGroup.discussions;
      final group = curriculumNGroup.group;
      final rests = curriculumNGroup.rests;
      if (curriculum == null) {
        throw Exception("No curriculum assigned yet");
      }
      // print(curriculum);
      ref.read(authNotifierProvider.notifier).setCourseRelatedData(group);
      ref
          .read(groupChatNotifierProvider.notifier)
          .setUnreadChats(curriculumNGroup.unreadChats);
      ref
          .read(notificationNotifierProvider.notifier)
          .setUnreadNotifications(curriculumNGroup.unReadNotifications);
      ref
          .read(authNotifierProvider.notifier)
          .setCourseStarted(CourseStarted.STARTED);
      state = state.copyWith(
        isLoading: false,
        curriculum: curriculum,
        scores: scores,
        testAttempts: testAttempts,
        discussions: discussions,
        rests: rests,
      );
    } catch (e) {
      print("Error: $e");
      if (e.toString().contains("course_is_not_started")) {
        ref
            .read(authNotifierProvider.notifier)
            .setCourseStarted(CourseStarted.NOTSTARTED);
      }
      handleError(
        e.toString(),
        context,
        ref,
        () {
          ref
              .read(authNotifierProvider.notifier)
              .setCourseStarted(CourseStarted.STARTED);
          state = state.copyWith(
            isLoading: false,
            error: getErrorMsg(e.toString(), "ደርሶቹን ማግኘት አልተቻለም።"),
          );
        },
      );
    }
  }

  void addScore(Score score) {
    if (state.scores.where((e) => e.id == score.id).isNotEmpty) return;
    state = state.copyWith(scores: [...state.scores, score]);
  }

  void changeExpandedCourse(int order) {
    if (state.expandedCourseOrder == order) {
      state = state.copyWith(expandedCourseOrder: null);
    } else {
      state = state.copyWith(expandedCourseOrder: order);
    }
  }

  double getProgress(WidgetRef ref) {
    double progress = 0;
    final authState = ref.read(authNotifierProvider);
    int lessonNum = (authState.courseRelatedData?.lessonNum ?? 0);
    int courseNum = (authState.courseRelatedData?.courseNum ?? 0);
    int numOfCourses = (state.curriculum?.assignedCourses?.length ?? 1);
    int numOfLessons = (state.curriculum?.lessons?.length ?? 1);

    double prctLesson = (lessonNum / numOfLessons);
    progress = (courseNum + prctLesson) / numOfCourses;
    // print("progress: $progress");
    //check if is is nan and return 0 if it is
    if (progress.isNaN) {
      return 0;
    }
    if (progress.isInfinite) {
      return 0;
    }
    return progress;
  }

  List<int> getLessonStructure(
      int lessonPerDay, DateTime courseStartDay, int noOfLessons) {
    final lastLessonDay = courseStartDay.add(Duration(
        days: 4 -
            courseStartDay
                .weekday)); //addDays(courseStartDay, 4 - getDay(courseStartDay))
    final noOfTheFirstWeekLessons = (lastLessonDay
                .difference(courseStartDay)
                .inDays +
            1) *
        lessonPerDay; //(differenceInDays(lastLessonDay, courseStartDay)+1)*lessonPerDay
    // startDate.add(Duration(days: 4 - getWeek(courseStartDay)));

    List<int> lessonStructure = [noOfTheFirstWeekLessons];
    while (true) {
      if (lessonStructure.reduce((pv, cv) => pv + cv) == noOfLessons) {
        break;
      }
      if (noOfLessons - lessonStructure.reduce((pv, cv) => pv + cv) <
          (4 * lessonPerDay)) {
        lessonStructure
            .add(noOfLessons - lessonStructure.reduce((pv, cv) => pv + cv));
        continue;
      }
      if (lessonStructure.length % 4 == 0) {
        lessonStructure.add(3 * lessonPerDay);
        continue;
      }
      lessonStructure.add(4 * lessonPerDay);
    }
    print("lessonStructure: $lessonStructure");
    return lessonStructure;
  }

  List<dynamic> getLessonStructureWRest(DateTime courseStartDay,
      int noOfLessons, int lessonPerDay, List<Rest> rests) {
    DateTime startDay = courseStartDay;
    List<dynamic> mainLessonStructure = [];
    // console.log("Started...");
    for (Rest rest in rests) {
      if (rest.startDate
              .compareTo(addDaysIgnoringWeekend(courseStartDay, noOfLessons)) ==
          1) {
        print("rest: ${rest.id} is jumped");
        continue;
      }
      final lessonLen = businessDaysBetween(rest.startDate, startDay);
      print("rest: ${rest.id} lessonLen: $lessonLen is jumped");

      //differenceInBusinessDays(rest.date, startDay) - differenceInWeeks(rest.date, startDay)

      // console.log("lessonLen:",lessonLen, "after date:", rest.date, "before date:", startDay)
      final lessonStructure =
          getLessonStructure(lessonPerDay, startDay, lessonLen);
      mainLessonStructure = [...mainLessonStructure, ...lessonStructure];
      List<int> cleanMainStructure = mainLessonStructure
          .where((e) => e.runtimeType == int)
          .map((e) => e as int)
          .toList();
      final restIndex = cleanMainStructure.reduce((pv, cv) => pv + cv) - 1;
      mainLessonStructure.add(rest.copyWith(afterLesson: restIndex));
      startDay = addDaysIgnoringWeekend(rest.startDate, rest.numOfDays);
      print("mainLessonStructure: $mainLessonStructure");

      // if(getDay(startDay) == 5){
      //   startDay = addBusinessDays(startDay, 1);
      // }
      // console.log("week day of", rest.id, ": ", getDay(startDay))
    }
    List<int> cleanStructure = mainLessonStructure
        .where((e) => e.runtimeType == int)
        .map((e) => e as int)
        .toList();

    // f cleanStructure:number[] = mainLessonStructure.filter((e)=>typeof e == 'number')
    // console.log({mainLessonStructure})
    // print("cleanStructure: $cleanStructure, mainLessonStructure: $mainLessonStructure");
    if (cleanStructure.isEmpty ||
        noOfLessons > cleanStructure.reduce((pv, cv) => pv + cv)) {
      final l = noOfLessons -
          (cleanStructure.isEmpty
              ? 0
              : cleanStructure.reduce((pv, cv) => pv + cv));
      final lastStructure = getLessonStructure(lessonPerDay, startDay, l);
      mainLessonStructure = [...mainLessonStructure, ...lastStructure];
    }

    List<int> cleanMainStructure = mainLessonStructure
        .where((e) => e.runtimeType == int)
        .map((e) => e as int)
        .toList();
    List<Rest> cleanRestStructure = mainLessonStructure
        .where((e) => e.runtimeType == Rest)
        .map((e) => e as Rest)
        .toList();

    // const cleanMainStructure:number[] = mainLessonStructure.filter((e)=>typeof e == 'number')
    // const cleanRestStructure:number[] = mainLessonStructure.filter((e)=>typeof e != 'number')

    print({"mainLessonStructure": mainLessonStructure});
    print("mainLessonStructure: ${[cleanMainStructure, cleanRestStructure]}");
    return [cleanMainStructure, cleanRestStructure];
  }

  bool hasDiscussion(List<int> lessonStructure, int noOfLesson, int index) {
    int totalL = 0;
    for (int l in lessonStructure) {
      totalL = totalL + l;
      if ((index + 1) == totalL) {
        return true;
      } else if ((index + 1) < totalL) {
        return false;
      }
    }
    return false;
  }

  bool hasExam(
      List<int> lessonStructure, int noOfLesson, int index, int lessonsPerDay) {
    int totalLesson = 0;
    int i = 0;
    for (int l in lessonStructure) {
      // final lessonS = lessonStructure.sublist(0, lessonStructure.indexOf(l));
      // print("lessonS.length: ${i}");
      if (
          // (index + 1) == totalLesson &&
          //   l == (3 * lessonsPerDay) &&
          (index + 1) == totalLesson && i % 4 == 0) {
        return true;
      } else if ((index + 1) < totalLesson) {
        return false;
      }
      totalLesson = totalLesson + l;
      i++;
    }
    if (index + 1 == noOfLesson) {
      return true;
    }
    return false;
  }

  DiscussionData getDiscussionData2(int index, List<int> lessonStructure) {
    final lessons = state.curriculum!.lessons!;
    int upToD = 0;
    int i = 0;

    while (true) {
      if (upToD < index + 1) {
        upToD = upToD + lessonStructure[i];
      } else {
        break;
      }
      i++;
    }

    int initialIndex = 0;

    if (i > 1) {
      initialIndex =
          lessonStructure.sublist(0, i - 1).reduce((pv, cv) => pv + cv);
    }

    return DiscussionData(
      title: "ከ${lessons[initialIndex].title} እስክ ${lessons[index].title}",
      lessonFrom: initialIndex,
      lessonTo: index,
      discussionIndex: index,
    );
  }
  // bool isTodayMoreThanDiscussionDay(WidgetRef ref) {
  //   final authState = ref.read(authNotifierProvider);
  //   final discussionDay = authState.user?.group.discussionDay ?? "jk";
  //   final discussionWeekDay = getWeekDayFromText(discussionDay);

  //   DateTime today = DateTime.now();
  //   return today.weekday >= DateTime.tuh;
  // }

  int getWeekDayFromText(String text) {
    switch (text) {
      case "Friday":
        return 5;
      case "Saturday":
        return 6;
      default:
        return 7;
      // throw Exception("no days");
    }
  }

  bool isTodayDiscussionDay(WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);
    final discussionDay = authState.user?.group.discussionDay ?? "k";
    final discussionWeekDay = getWeekDayFromText(discussionDay);

    DateTime today = DateTime.now();
    return today.weekday >= discussionWeekDay;
  }

  bool isBetweenLessonAndDiscussion(WidgetRef ref) {
    DateTime today = DateTime.now();
    return !isTodayDiscussionDay(ref) && today.weekday > 4;
  }

  bool isTodayExamDay(int index, List<int> lessonStructure, int noOfLessons,
      int noOfLessonADay) {
    int upToD = 0;
    int i = 0;
    DateTime today = DateTime.now();

    while (true) {
      if (upToD < index + 1) {
        upToD = upToD + lessonStructure[i];
      } else {
        break;
      }
      i++;
    }

    final numOfLessonV = List.generate(noOfLessonADay, (i) => noOfLessons - i);

    if (i - 1 == 0) {
      return false;
    }
    if (numOfLessonV.contains(index + 1)) {
      return today.weekday == DateTime.monday && true;
    }

    int sum = lessonStructure.sublist(0, i).reduce((pv, cv) => pv + cv) -
        1; //i % 4 == 0;
    final sums = List.generate(noOfLessonADay, (i) => sum - i);
    bool cond = sums.contains(index); //index == sum;
    // print("index == sum: $index == $sum");
    //lessonStructure.sublist(0, i -).reduce((pv, cv) => pv + cv);
    // if(lessonStructure[i-1] )
    return cond && today.weekday == DateTime.monday;
  }

  bool isTodayLessonDay(/*List<int> lessonStructure*/) {
    // final hasExam =
    //     discussionData == null ? false : realIndex == discussionData.lessonTo;
    DateTime today = DateTime.now();
    final lessonDays = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday
    ];
    // print("$realIndex == ${discussionData?.lessonTo}");
    return lessonDays.contains(today.weekday); // && !hasExam;
  }

  ExamData getExamData(List<DiscussionData> discussions, WidgetRef ref) {
    //get exam data for the all the discussions that it holds
    discussions.sort((a, b) => a.lessonFrom.compareTo(b.lessonFrom));
    print("discussionLsn: ${discussions.length}");
    print(
        "discussions: ${discussions.map((e) => "${e.lessonFrom} - ${e.lessonTo}")}");
    final lessons = state.curriculum?.lessons ?? [];

    if (discussions.isEmpty || lessons.isEmpty) {
      return ExamData(
        title: "ምንም ውልውል የለም",
        lessonFrom: 0,
        lessonTo: 0,
        discussionIndex: 0,
      );
    } else {
      final startLesson = lessons[discussions[0].lessonFrom];
      final endLesson = lessons[discussions.last.lessonTo];
      return ExamData(
        title:
            "ከ${startLesson.title}${discussions[0].lessonFrom} እስክ ${endLesson.title}${discussions.last.lessonTo} ድረስ",
        lessonFrom: discussions[0].lessonFrom,
        lessonTo: discussions.last.lessonTo,
        discussionIndex: discussions.last.discussionIndex,
      );
    }
  }

  // ExamData getExamData(int index, List<int> lessonStructure, int lessonNo) {
  //   if (index == lessonNo) {}
  //   return ExamData(
  //     title:
  //         "ከ${startLesson.title}${discussions[0].lessonFrom} እስክ ${endLesson.title}${discussions.last.lessonTo} ድረስ",
  //     lessonFrom: discussions[0].lessonFrom,
  //     lessonTo: discussions.last.lessonTo,
  //     discussionIndex: discussions.last.discussionIndex,
  //   );
  // }

  int getNumOfDiscussionUpToIndex(int lessonIndex, WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);

    final user = authState.user!;

    final lessonStructure = getLessonStructure(
      user.group.noOfLessonsPerDay,
      user.group.courseStartDate!,
      state.curriculum!.lessons!.length,
    );

    int upToD = 0;
    int i = 0;
    while (true) {
      if (upToD < lessonIndex + 1) {
        upToD = upToD + lessonStructure[i];
      } else {
        break;
      }
      i++;
    }
    return i - 1;
  }

  int numOfExamsUpToIndex(int index, WidgetRef ref) {
    int numOfDiscussions = getNumOfDiscussionUpToIndex(index, ref);
    return (numOfDiscussions / 4).floor();
  }

  // bool isThisDiscussionHasExam(int discussionIndex, WidgetRef ref) {
  //   int noOfDiscussions = getDiscussionNumOfCurrentCourse(ref);

  //   int reminder = noOfDiscussions % 4;

  //   // print("${reminder != 0} && $discussionIndex == $noOfDiscussions");
  //   if (discussionIndex % 4 == 0) {
  //     return true;
  //   } else if (reminder != 0 && discussionIndex == noOfDiscussions) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool hasExamWithoutTheEnd(int discussionIndex, WidgetRef ref) {
  //   if (discussionIndex % 4 == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool isIndexDiscussion(int index, WidgetRef ref) {
  //   final authState = ref.read(authNotifierProvider);

  //   DateTime startDate =
  //       authState.user?.group.courseStartDate ?? DateTime.now();

  //   DateTime lastLessonDay =
  //       startDate.add(Duration(days: 4 - startDate.weekday));

  //   int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

  //   int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;
  //   // int withOutRemainder =
  //   //     ((totalNumOfLesson - noOfLessonsIn1stWeek) / 4).floor();

  //   int totalDiscussion = getDiscussionNumOfCurrentCourse(ref);

  //   // print("last ${index + 1} == ${(totalNumOfLesson + totalDiscussion)}");
  //   if (index < noOfLessonsIn1stWeek) {
  //     return false;
  //   } else if (index == noOfLessonsIn1stWeek) {
  //     return true;
  //   } else if (index + 1 == (totalNumOfLesson + totalDiscussion)) {
  //     return true;
  //   } else {
  //     // print("ind: ${(index - noOfLessonsIn1stWeek)}");
  //     if ((index - noOfLessonsIn1stWeek) % 19 == 0) {
  //       return true;
  //     } else if ((index - noOfLessonsIn1stWeek) % 19 < 16) {
  //       int i = (index - noOfLessonsIn1stWeek) % 19;
  //       if (i % 5 == 0) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  // }

  // bool isIndexDis(int index, WidgetRef ref) {
  //   final authState = ref.read(authNotifierProvider);

  //   DateTime startDate =
  //       authState.user?.group.courseStartDate ?? DateTime.now();

  //   DateTime lastLessonDay =
  //       startDate.add(Duration(days: 4 - startDate.weekday));

  //   int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

  //   // int totalNumOfLesson = 40; //tate.curriculum?.lessons?.length ?? 0;
  //   // int withOutRemainder =
  //   //     ((totalNumOfLesson - noOfLessonsIn1stWeek) / 4).floor();

  //   // int totalDiscussion = getDiscussionNumOfCurrentCourse(ref);

  //   // print("last ${index + 1} == ${(totalNumOfLesson + totalDiscussion)}");
  //   if (index < noOfLessonsIn1stWeek) {
  //     return false;
  //   } else if (index == noOfLessonsIn1stWeek) {
  //     return true;
  //   }
  //   // else if (index + 1 == (totalNumOfLesson + totalDiscussion)) {
  //   //   return true;
  //   // }
  //   else {
  //     // print("ind: ${(index - noOfLessonsIn1stWeek)}");
  //     if ((index - noOfLessonsIn1stWeek) % 19 == 0) {
  //       return true;
  //     } else if ((index - noOfLessonsIn1stWeek) % 19 < 16) {
  //       int i = (index - noOfLessonsIn1stWeek) % 19;
  //       if (i % 5 == 0) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  // }
  // List<Map<int, List<int>>> getLessonsOfDiscussions(
  //     WidgetRef ref, int noOfLessons) {
  //   int discussionCount = 0;
  //   int lessonCount = 0;
  //   int index = 1;
  //   List<Map<int, List<int>>> lessonsInDiscussions = [];
  //   // bool isLastDiscussion = false;
  //   while (true) {
  //     if (lessonCount < (noOfLessons - 1)) {
  //       if (isIndexDis(index, ref)) {
  //         discussionCount++;
  //         lessonsInDiscussions.add({discussionCount: []});
  //         // isLastDiscussion = true;
  //       } else {
  //         lessonCount++;
  //         lessonsInDiscussions = lessonsInDiscussions
  //             .map((e) => e.keys.first == discussionCount
  //                 ? {
  //                     discussionCount: [...e.values.first, lessonCount]
  //                   }
  //                 : e)
  //             .toList();
  //         // isLastDiscussion = false;
  //       }
  //     } else {
  //       break;
  //     }
  //     index++;
  //   }
  //   // print("lessonsInDiscussions: ${lessonsInDiscussions.length}");
  //   return lessonsInDiscussions;
  // }

  // DiscussionData getDiscussionData(
  //     int index, int realIndex, int discussionIndex, WidgetRef ref) {
  //   final lessons = state.curriculum?.lessons ?? [];

  //   if (realIndex < 5) {
  //     return DiscussionData(
  //       title: "ከ${lessons[0].title} እስክ ${lessons[realIndex].title}",
  //       lessonFrom: 0,
  //       lessonTo: realIndex,
  //       discussionIndex: index,
  //     );
  //   } else {
  //     final lessonInDiscussions = getLessonsOfDiscussions(ref, lessons.length);
  //     final currentDiscussionLessons = lessonInDiscussions[discussionIndex - 1];
  //     final firstLesson = currentDiscussionLessons.values.first.first;

  //     final just1Lesson = realIndex == firstLesson;

  //     return DiscussionData(
  //       title: just1Lesson
  //           ? lessons[firstLesson].title
  //           : "ከ${lessons[firstLesson].title} እስክ ${lessons[realIndex].title}",
  //       lessonFrom: firstLesson,
  //       lessonTo: realIndex,
  //       discussionIndex: index,
  //     );
  //   }
  //   // else if (realIndex < lessons.length - 4) {
  //   //   if ((discussionIndex) % 4 == 0) {
  //   //     return DiscussionData(
  //   //       title:
  //   //           "ከ${lessons[realIndex - 2].title}${realIndex - 2} እስክi ${lessons[realIndex].title}",
  //   //       lessonFrom: realIndex - 2,
  //   //       lessonTo: realIndex,
  //   //       discussionIndex: index,
  //   //     );
  //   //   }
  //   //   return DiscussionData(
  //   //     title:
  //   //         "ከ${lessons[realIndex - 3].title}${realIndex - 3} እስክi ${lessons[realIndex].title}",
  //   //     lessonFrom: realIndex - 3,
  //   //     lessonTo: realIndex,
  //   //     discussionIndex: index,
  //   //   );
  //   // } else {
  //   //   final authState = ref.read(authNotifierProvider);

  //   //   DateTime startDate =
  //   //       authState.user?.group.courseStartDate ?? DateTime.now();

  //   //   DateTime lastLessonDay =
  //   //       startDate.add(Duration(days: 4 - startDate.weekday));

  //   //   int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

  //   //   int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;

  //   //   int remainderAtTheLast = (totalNumOfLesson - noOfLessonsIn1stWeek) % 4;

  //   //   int firstLessonIndexOfLastWeek = remainderAtTheLast - 1;

  //   //   int lessonIndex = realIndex - firstLessonIndexOfLastWeek;

  //   //   return DiscussionData(
  //   //     title:
  //   //         "ከ${lessons[lessonIndex > lessons.length ? lessons.length - 1 : lessonIndex].title}${lessonIndex > lessons.length ? lessons.length - 1 : lessonIndex} እስክ ${lessons[realIndex].title}",
  //   //     lessonFrom: realIndex - firstLessonIndexOfLastWeek,
  //   //     lessonTo: realIndex,
  //   //     discussionIndex: index,
  //   //   );
  //   // }
  // }

  // int getDiscussionNumOfCurrentCourse(WidgetRef ref) {
  //   // final authState = ref.read(authNotifierProvider);

  //   // DateTime startDate = authState.user!.group.courseStartDate!;

  //   // DateTime lastLessonDay =
  //   //     startDate.add(Duration(days: 4 - startDate.weekday));

  //   // int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

  //   int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;

  //   if (totalNumOfLesson == 0) {
  //     return 0;
  //   }

  //   // int withOutRemainder =
  //   //     ((totalNumOfLesson - noOfLessonsIn1stWeek) / 4).floor();

  //   // int remainderAtTheLast = (totalNumOfLesson - noOfLessonsIn1stWeek) % 4;

  //   // print("_______________");
  //   // print("startDate:: ${startDate.weekday}");
  //   // print("lastLessonDay:: ${lastLessonDay.weekday.toString()}");
  //   // print("noOfLessonsIn1stWeek:: $noOfLessonsIn1stWeek");
  //   // print("remainderAtTheLast:: $remainderAtTheLast");
  //   // print("withOutRemainder:: $withOutRemainder");
  //   // print("_______________");

  //   // bool cond = withOutRemainder % 40 == 0;
  //   // int countExam = (withOutRemainder / 4).floor();
  //   // final lessonsAfterTheFirstWeek = totalNumOfLesson - noOfLessonsIn1stWeek;

  //   int discussionCount = 0;
  //   int lessonCount = 0;
  //   int index = 1;
  //   bool isLastDiscussion = false;
  //   while (true) {
  //     if (lessonCount < (totalNumOfLesson - 1)) {
  //       if (isIndexDis(index, ref)) {
  //         discussionCount++;
  //         isLastDiscussion = true;
  //       } else {
  //         lessonCount++;
  //         isLastDiscussion = false;
  //       }
  //     } else {
  //       break;
  //     }
  //     index++;
  //   }
  //   if (isLastDiscussion) {
  //     // print("isLastDiscussion: $isLastDiscussion at index: $index");
  //     // print("discussionCount: $discussionCount");
  //     return discussionCount;
  //   } else {
  //     //  print("isLastDiscussion: $isLastDiscussion at index: $index");
  //     // print("discussionCount: ${discussionCount+1}");
  //     return discussionCount + 1;
  //   }

  //   // print("discussionCount: ${discussionCount + 1}, lessonCount: $lessonCount");
  //   // return discussionCount + 1;
  //   // final lessonAfterTheFirstExam = lessonsAfterTheFirstWeek - (3*4);
  //   // discussionCount = lessonsAfterTheFirstWeek + (lessonsAfterTheFirstWeek /)
  //   // if (withOutRemainder % 4 == 0) {

  //   // }
  //   // print("totalNumOfLesson: $totalNumOfLesson");
  //   // print("lessonsAfterTheFirstWeek: $lessonsAfterTheFirstWeek");

  //   // if (remainderAtTheLast == 0) {
  //   //   print("discussionCount: ${discussionCount + 1}");
  //   //   return discussionCount + 1 + 3 + 2;
  //   // } else {
  //   //   print("discussionCount: ${discussionCount + 2}");

  //   //   return discussionCount + 2 + 3 + 2;
  //   // }
  // }
}

class DiscussionData {
  final String title;
  final int lessonFrom;
  final int lessonTo;
  final int discussionIndex;
  DiscussionData({
    required this.title,
    required this.lessonFrom,
    required this.lessonTo,
    required this.discussionIndex,
  });
}

class ExamData {
  final String title;
  final int lessonFrom;
  final int lessonTo;
  final int discussionIndex;
  ExamData({
    required this.title,
    required this.lessonFrom,
    required this.lessonTo,
    required this.discussionIndex,
  });
}

enum LessonCardStatus { NONE, LESSON, DISCUSSION, EXAM }
