import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/service/assigned_course_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/past_lesson_state.dart';

class PastLessonNotifier extends StateNotifier<PastLessonState> {
  final AssignedCourseService assignedCourseService;
  PastLessonNotifier(this.assignedCourseService)
      : super(
          PastLessonState(),
        );

  Future<void> getLessonForCourse(String courseId) async {
    try {
      state = state.copyWith(isLoading: true);
      final lessons =
          await assignedCourseService.fetchLessonsOfAssignedCourses(courseId);
      state = state.copyWith(isLoading: false, lessons: lessons);
    } catch (e) {
      print("Error: $e");
      state = state.copyWith(isLoading: false, error: "ደርሶቹን ማግኘት አልተቻለም።");
    }
  }
}
