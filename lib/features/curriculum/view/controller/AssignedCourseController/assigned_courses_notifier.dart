import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    }catch (e) {
      print("Error: $e");
      state = state.copyWith(isLoading: false, error: "ደርሶቹን ማግኘት አልተቻለም።");
    }
  }
}
