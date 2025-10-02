import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/service/assigned_course_service.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_state.dart';

class AssignedCoursesNotifier extends StateNotifier<AssignedCoursesState> {
  final AssignedCourseService service;

  AssignedCoursesNotifier(this.service) : super(AssignedCoursesState());

  Future<void> getAssignedCourses() async {
   
  }
}
