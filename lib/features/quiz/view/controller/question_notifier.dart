import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/question_state.dart';

class QuestionNotifier extends StateNotifier<QuestionState> {
  final QuizService quizService;
  QuestionNotifier(this.quizService) : super(QuestionState());

  Future<void> getTestQuestion() async {
    try {
      state = state.copyWith(isLoading: true);
      final quizzes = await quizService.getTestQuestions();

      state = state.copyWith(isLoading: false, questions: quizzes);
    } catch (err) {
      state = state.copyWith(isLoading: false, error: "ጥያቄዎቹን ማግኘት አልተቻለም!");
      print(err);
    }
  }
}
