import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/service/assigned_course_service.dart';
import 'package:islamic_online_learning/features/curriculum/service/curriculum_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_state.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/past_lesson_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/past_lesson_state.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/CurriculumController/curriculum_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/CurriculumController/curriculum_state.dart';

// Provide the service instance
final curriculumServiceProvider = Provider<CurriculumService>((ref) {
  return CurriculumService();
});

final assignedCourseServiceProvider = Provider<AssignedCourseService>((ref) {
  return AssignedCourseService();
});

// Provide the state notifier
final curriculumNotifierProvider =
    StateNotifierProvider<CurriculumNotifier, CurriculumState>((ref) {
  final service = ref.watch(curriculumServiceProvider);
  return CurriculumNotifier(service);
});

final assignedCoursesNotifierProvider =
    StateNotifierProvider<AssignedCoursesNotifier, AssignedCoursesState>((ref) {
  final service = ref.watch(curriculumServiceProvider);
  return AssignedCoursesNotifier(service);
});

final pastLessonStateProvider = StateNotifierProvider<PastLessonNotifier, PastLessonState>((ref) {
  final service = ref.watch(assignedCourseServiceProvider);
  return PastLessonNotifier(service);
});