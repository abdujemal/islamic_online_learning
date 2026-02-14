import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/service/assigned_course_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/past_lesson_state.dart';

class PastLessonNotifier extends StateNotifier<PastLessonState> {
  final AssignedCourseService assignedCourseService;
  final Ref ref;
  PastLessonNotifier(this.assignedCourseService, this.ref)
      : super(
          PastLessonState(),
        );

  Future<void> getLessonForCourse(String courseId, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final lessons =
          await assignedCourseService.fetchLessonsOfAssignedCourses(courseId);
      state = state.copyWith(isLoading: false, lessons: lessons);
    } catch (e) {
      print("Error: $e");
      handleError(e.toString(), context, ref, () {
        state = state.copyWith(
          isLoading: false,
          error: getErrorMsg(e.toString(), "ደርሶቹን ማግኘት አልተቻለም።"),
        );
      });
    }
  }
}
