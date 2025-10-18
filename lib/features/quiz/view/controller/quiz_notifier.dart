import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/quiz_state.dart';

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizService quizService;
  QuizNotifier(this.quizService) : super(QuizState());

  Future<void> getQuizzes(String lessonId) async {
    try {
      state = state.copyWith(isLoading: true);
      final quizzes = await quizService.getQuizzes(lessonId);

      state = state.copyWith(isLoading: false, quizzes: quizzes);
    } catch (err) {
      state = state.copyWith(isLoading: false, error: "ጥያቄዎቹን ማግኘት አልተቻለም!");
      print(err);
    }
  }

  Future<void> submitQuestions(
      Lesson lesson, List<Map<String, int>> answers, WidgetRef ref) async {
    try {
      state = state.copyWith(isSubmitting: true);
      await quizService.submitQuizzes(lesson, answers);

      state = state.copyWith(isSubmitting: false);
    } catch (err) {
      state = state.copyWith(isSubmitting: false);
      toast("ሙከራውን ማስረከብ አልተቻለም!", ToastType.error, ref.context);
      print(err);
    }
  }
}
// {
//   "streakType":	"Lesson",
//   "streakPass": "",
//   "lessonId": "",
// }
