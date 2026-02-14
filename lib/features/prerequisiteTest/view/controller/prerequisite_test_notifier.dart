import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/service/prerequisite_test_service.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/view/controller/prerequisite_test_state.dart';

class PrerequisiteTestNotifier extends StateNotifier<PrerequisiteTestState> {
  final PrerequisiteTestService service;
  PrerequisiteTestNotifier(this.service) : super(PrerequisiteTestState());

  Future<void> getQuizzes(Curriculum curr) async {
    try {
      state = state.copyWith(isLoading: true);
      final quizzes = await service.getQuizzes(curr);

      state = state.copyWith(isLoading: false, quizzes: quizzes);
    } catch (err) {
        state = state.copyWith(
          isLoading: false,
          error: "ጥያቄዎቹን ማግኘት አልተቻለም!",
        );
    }
  }
}
