// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_state.dart';

class AssignedCoursesNotifier extends StateNotifier<AssignedCoursesState> {
  final CurriculumService service;

  AssignedCoursesNotifier(this.service) : super(AssignedCoursesState());

  Future<void> getCurriculum() async {
    try {
      state = state.copyWith(isLoading: true);
      final curriculum = await service.fetchCurriculum();
      print(curriculum);
      state = state.copyWith(
        isLoading: false,
        curriculum: curriculum,
      );
    } catch (e) {
      print("Error: $e");
      state = state.copyWith(isLoading: false, error: "ደርሶቹን ማግኘት አልተቻለም።");
    }
  }

  double getProgress(WidgetRef ref) {
    double progress = 0;
    final authState = ref.read(authNotifierProvider);
    int lessonNum = (authState.user?.group.lessonNum ?? 0);
    int courseNum = (authState.user?.group.courseNum ?? 0);
    int numOfCourses = (state.curriculum?.assignedCourses?.length ?? 1);
    int numOfLessons = (state.curriculum?.lessons?.length ?? 1);

    double prctLesson = (lessonNum / numOfLessons);
    progress = (courseNum + prctLesson) / numOfCourses;
    // print("progress: $progress");
    return progress;
  }

  bool isIndexDiscussion(int index, WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);

    DateTime startDate = authState.user?.group.startDate ?? DateTime.now();

    DateTime lastLessonDay =
        startDate.add(Duration(days: 4 - startDate.weekday));

    int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

    int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;
    // int withOutRemainder =
    //     ((totalNumOfLesson - noOfLessonsIn1stWeek) / 4).floor();

    int totalDiscussion = getDiscussionNumOfCurrentCourse(ref);

    if (index < noOfLessonsIn1stWeek) {
      return false;
    } else if (index == noOfLessonsIn1stWeek) {
      return true;
    } else if (index + 1 == (totalNumOfLesson + totalDiscussion)) {
      return true;
    } else {
      if ((index - noOfLessonsIn1stWeek) % 5 == 0) {
        return true;
      }
      return false;
    }
  }

  bool isTodayDiscussionDay(WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);
    final discussionDay = authState.user?.group.discussionDay ?? "Sunday";
    final discussionWeekDay = getWeekDayFromText(discussionDay);

    DateTime today = DateTime.now();
    return today.weekday == discussionWeekDay;
  }

  int getWeekDayFromText(String text) {
    switch (text) {
      case "Friday":
        return 5;
      case "SaturDay":
        return 6;
      default:
        return 7;
    }
  }

  DiscussionData getDiscussionData(int index, int realIndex, WidgetRef ref) {
    final lessons = state.curriculum?.lessons ?? [];
    if (realIndex < 5) {
      return DiscussionData(
        title: "ከ${lessons[0].title} እስክ ${lessons[realIndex].title}",
        lessonFrom: 0,
        lessonTo: realIndex,
        discussionIndex: index,
      );
    } else if (realIndex < lessons.length - 4) {
      return DiscussionData(
        title:
            "ከ${lessons[realIndex - 3].title} እስክ ${lessons[realIndex].title}",
        lessonFrom: realIndex - 3,
        lessonTo: realIndex,
        discussionIndex: index,
      );
    } else {
      final authState = ref.read(authNotifierProvider);

      DateTime startDate = authState.user?.group.startDate ?? DateTime.now();

      DateTime lastLessonDay =
          startDate.add(Duration(days: 4 - startDate.weekday));

      int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

      int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;

      int remainderAtTheLast = (totalNumOfLesson - noOfLessonsIn1stWeek) % 4;

      int firstLessonIndexOfLastWeek = remainderAtTheLast - 1;

      return DiscussionData(
        title:
            "ከ${lessons[realIndex - firstLessonIndexOfLastWeek].title} እስክ ${lessons[realIndex].title}",
        lessonFrom: realIndex - firstLessonIndexOfLastWeek,
        lessonTo: realIndex,
        discussionIndex: index,
      );
    }
  }

  int getDiscussionNumOfCurrentCourse(WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);

    DateTime startDate = authState.user?.group.startDate ?? DateTime.now();

    DateTime lastLessonDay =
        startDate.add(Duration(days: 4 - startDate.weekday));

    int noOfLessonsIn1stWeek = lastLessonDay.difference(startDate).inDays + 1;

    int totalNumOfLesson = state.curriculum?.lessons?.length ?? 0;

    if (totalNumOfLesson == 0) {
      return 0;
    }

    int withOutRemainder =
        ((totalNumOfLesson - noOfLessonsIn1stWeek) / 4).floor();
    int remainderAtTheLast = (totalNumOfLesson - noOfLessonsIn1stWeek) % 4;

    // print("startDate: ${startDate.weekday}");
    // print("lastLessonDay: ${lastLessonDay.weekday.toString()}");
    // print("noOfLessonsIn1stWeek: $noOfLessonsIn1stWeek");
    // print("remainderAtTheLast: $remainderAtTheLast");
    // print("withOutRemainder: $withOutRemainder");

    if (remainderAtTheLast == 0) {
      return withOutRemainder + 1;
    } else {
      return withOutRemainder + 2;
    }
  }
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
